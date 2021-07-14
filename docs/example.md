
In this section, we demonstrate the usage of `perf-taint` on a dummy example. We show
how to take existing applications in C++, perform the manual annotation of parameters
and automatically extract tainted models of parameter dependencies. Then, we show
a simple example of modeling.

We recommend to use the provided Docker images: `spcleth/perf-taint:latest`:

```
docker run -it spcleth/perf-taint:latest /bin/bash
```

Otherwise, a simple build of our tool will be sufficient.

## How to use perf-taint?

We use the following exampleIt includes simple loop-based computation dependent on the command line argument and MPI collectives.

```c++
void f(double * b, size_t size)
{
    while(size--) {
        *b += 2;
        ++b;
    }
}

double h(double * data, size_t size)
{
    for(int i = 0; i < size; ++i)
        data[i]++;
    double acc_rcv = data[0];
    MPI_Reduce(data, &acc_rcv, 1, MPI_DOUBLE, MPI_SUM, 0, MPI_COMM_WORLD);
    return acc_rcv;
}

int main(int argc, char ** argv)
{
    MPI_Init(&argc, &argv);
    int size = atoi(argv[1]);
    int ranks = 1, rank_id;
    MPI_Comm_size(MPI_COMM_WORLD, &ranks);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank_id);

    size /= ranks;
    int start = size * rank_id;
    double * data = (double*) calloc(size, sizeof(double));
    f(data, size);
    double acc_rcv = h(data, size);
    if(rank_id == 0)
        printf("%f\n", acc_rcv);
    MPI_Barrier(MPI_COMM_WORLD);
    free(data);
    MPI_Finalize();
    return 0;
}
```

### Source code annotation

The manual step of our analysis includes annotating program code to indicate which variables
are programs parameters and should be analyzed. MPI's number of ranks is an implicit parameter
that is automatically added. Thus, we add the following line in `main`:

```
int size EXTRAP = atoi(argv[1]);
register_variable(&size, "size");
```

And we add the necessary include: `#include "perf-taint/PerfTaint.hpp"`.

### perf-taint: parameter pruning

Now we show how to use perf-taint, either locally or within Docker.
First, we need to turn the C/C++ code into LLVM IR. For that, `perf-taint` provides
an automatic script. We execute the command:

```
${PERF_TAINT_PATH}/bin/clang++-wrapper mpi_simple.cpp
```

This will generate `mpi_simple.bc`.` perf-taint` installation wraps necessary flags
and MPI headers location. If additional flags might be needed, they can simply be added as
arguments.

Then, we're going to apply our compilation pass and link the application:

```
${PERF_TAINT_PATH}/bin/perf-taint -t mpi_simple -o mpi_simple.exe mpi_simple.bc 2> compiler_output
```

The tainted bitcodes are compiled into object files with `llc` and linked with perf-taint static runtime library,
DataFlowSanitizer static runtime library, `libc++` and MPI.
Details of each step can be found in `bin/perf-taint.in` in program repository.

An artifact of the compilation is the file `perf-taint-pass.json` summarizing results of
static analysis (a sample shown here):

```
{
  "functions": {
    "_Z17register_variableIiEvPT_PKc": {
      "loops": {
        "count": 0
      },
      "pruned": [
        "no_performance_critical_code"
      ]
    },
    "_Z1hPdm": {
      "instrumented": [
        "loops",
        "important_call"
      ],
      "loops": {
        "count": 1,
        "implicit": 1
      }
    },
    "_Z6f_sizePdm": {
      "instrumented": [
        "loops"
      ],
      "loops": {
        "count": 1,
        "implicit": 0
      }
    },
    "_Z7f_constPd": {
      "instrumented": [
        "loops"
      ],
      "loops": {
        "count": 1,
        "implicit": 0
      }
    },
    "_Z8f_size_pPdm": {
      "instrumented": [
        "loops"
      ],
      "loops": {
        "count": 1,
        "implicit": 0
      }
    },
    "main": {
      "instrumented": [
        "important_call"
      ],
      "loops": {
        "count": 0,
        "implicit": 1
      }
    }
  }
}
}
```

As we can see, all functions are considered to be potentially performance
relevant, except a helper function `register_variable` is not interesting for performance modeling.

Finally, we execute the application to perform the dynamic taint analysis and later we process results:

```
DFSAN_OPTIONS=warn_unimplemented=0 mpirun -n 4 ./mpi_simple.exe 10
```

After the application finishes, the JSON files `mpi_simple_{0,1,2,3}.json` contain results
for each MPI rank. To extract information into a summary and prepare the results
for modeling, we use a dedicated tool:

Local:
```
${PERF_TAINT_PATH}/tools/JSONConverter mpi_simple_0.json mpi_simple.ll.json 2> analysis.txt
```

First, we find in the file `mpi_simple_0.json` that while `h`, `f_size` and `f_size_p`
are performance relevant, the latter doesn't depend on the number of MPi ranks `p` (loop 0 in "instance").
Finally, `f_const` is correctly identified as performance irrelevant and `h` contains a call
to important MPI routine (position 1 in "instance").

```
"_Z1hPdm": {
  "file": "mpi_simple_annotated.cpp",
  "func_idx": 4,
  "line": 34,
  "loops": [
    {
      "callstacks": [
        [
          0
        ]
      ],
      "instance": {
        "0": {
          "level": 0,
          "params": [
            [
              "size",
              "p"
            ]
          ]
        },
        "1": [
          {
            "entry_id": 0,
            "function_idx": 5
          }
        ]
      }
    }
  ]
},
"_Z6f_sizePdm": {
  "file": "mpi_simple_annotated.cpp",
  "func_idx": 2,
  "line": 18,
  "loops": [
    {
      "callstacks": [
        [
          0
        ]
      ],
      "instance": {
        "0": {
          "level": 0,
          "params": [
            [
              "size"
            ]
          ]
        }
      }
    }
  ]
},
"_Z8f_size_pPdm": {
  "file": "mpi_simple_annotated.cpp",
  "func_idx": 3,
  "line": 26,
  "loops": [
    {
      "callstacks": [
        [
          0
        ]
      ],
      "instance": {
        "0": {
          "level": 0,
          "params": [
            [
              "size",
              "p"
            ]
          ]
        }
      }
    }
  ]
}
```

Finally we inspect the summarized results of an analysis:

```
Analyze 1 unimportant and 6 important functions
Important: 6
Function: main params: 0
Function: _Z6f_sizePdm params: 1
Function: _Z8f_size_pPdm params: 2
Function: _Z1hPdm params: 2
MPI functions: 2  empty params: 1
{
  "functions": {
    "p": 2,
    "p_size": 2,
    "size": 3
  },
  "functions_names": {
    "p": [
      "_Z8f_size_pPdm",
      "_Z1hPdm"
    ],
    "p_size": [
      "_Z8f_size_pPdm",
      "_Z1hPdm"
    ],
    "size": [
      "_Z6f_sizePdm",
      "_Z8f_size_pPdm",
      "_Z1hPdm"
    ]
  },
  "loops": 3,
  "param": {
    "p": 2,
    "p_size": 2,
    "size": 3
  }
}
```

We have 6 important functions - three user-defined, `main` and two MPI calls.
With that newly gained knowledge we can attempt performance modeling - there are two functions
beyond `main` that should be modeled and all depend on both parameters.

## Reusability

Our framework supports the analysis of MPI programs in C/C++. Fortran applications have not been
evaluated, but theoretically they should be analyzable with the LLVM-based `flang` compiler.

We don't provide a generic processing script, since the entire framework includes manual
steps that are application specific and cannot be automatized.
Furthermore, we provide the following tools and guidelines:

* To annotate program parameters that perf-taint should analyze, add a call to `register_variable`
immediately after variable definition and initialization (main function, routines parsing
CLI arguments and I/O). If the registration happens before overwriting the variable value, the
information won't be tracked. In addition, please add `EXTRAP` keyword to each variable (backwards
compatibility), as shown in the guide.

* `${PERF_TAINT_PATH}/bin/clang++` is a wrapper that can be used to generate LLVM bitcodes
from a larger project. In our artifact, we use it to extract bitcodes from LULESH and MILC
benchmark. The wrapper generates bitcodes from the compilation of translation units, and it works
well when applied to C/C++ projects implemented with Makefiles or CMake. The IR generation
happens while compiling to object code, so the build process is not interrupted.

* To run a single C++ file and extract LLVM IR bitcode from it, with compilation flags properly
set, we offer a simpler wrapper `${PERF_TAINT_PATH}/bin/clang++-wrapper` (example in the guide).

* When bitocdes are generated inside a project, the simplest way of linking them into a single
file is `find /dir/ -name \*.bc | xargs llvm-link -o out.bc`.

* perf-taint can be used exactly the same as we use it in the guide above.
Only the execution of application instrumented with taint analysis must be decided by the user.
This step already provides the most important results: performance relevant functions, the impact
of parameters on loops and functions, and files necessary for efficient instrumentation and modeling.

* Experiment design is always a manual process. We recommend the Extra-P publications
as a good source of experiment design practices. Taking 5 samples per each
parameter and 5 repetitions per sample is considered to be sufficient.

