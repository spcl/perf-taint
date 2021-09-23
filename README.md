# perf-taint

**LLVM-based taint analysis framework for HPC performance modeling.**

[![CircleCI](https://circleci.com/gh/spcl/perf-taint.svg?style=shield)](https://circleci.com/gh/spcl/perf-taint)
![Release](https://img.shields.io/github/v/release/spcl/perf-taint)
![Docker Image](https://img.shields.io/docker/v/spcleth/perf-taint/latest?label=Docker)
![GitHub issues](https://img.shields.io/github/issues/spcl/perf-taint)
![GitHub pull requests](https://img.shields.io/github/issues-pr/spcl/perf-taint)

Perf-taint implements taint-based analysis of the program's performance to find the performance-relevant
parameters and discover functions that impact the program's performance. Perf-taint generates
a structured JSON file describing relevant functions. We use that to enhance Extra-P empirical
performance modeling tool with our new performance analysis and construct
hybrid, white-box performance models.

The tool consists of two parts: an LLVM compiler pass and a runtime library. The compiler pass
performs static analysis to determine which functions are definitely not performance-relevant
and instruments the code with taint propagation. The resulting application is linked with our
runtime library that aggregates tainted data and constructs [a JSON performance profile](docs/json.md).
The profile [is passed to Extra-P](docs/extrap.md) to use the program information in the modeling process.
Our tool supports [parallel MPI programs](docs/mpi.md), and [OpenMP support](docs/openmp.md) is planned for the next release.
The documentation describes in detail [the design and implementation of our
tool](docs/design.md) and provides [a step-by-step explanation](docs/example.md) of our compilation and modeling pipeline.

perf-taint can be used with our Docker image `spcleth/perf-taint:latest`, or the tool
can be [installed locally](#installation).

When using perf-taint, please cite [our PPoPP'21 paper](https://doi.org/10.1145/3437801.3441613).
A preprint of our paper is [available on arXiv](https://arxiv.org/abs/2012.15592), and you can
find more details about research work [in this paper summary](https://mcopik.github.io/projects/perf_taint/).

```
@inproceedings{10.1145/3437801.3441613,
  author = {Copik, Marcin and Calotoiu, Alexandru and Grosser, Tobias and Wicki, Nicolas and Wolf, Felix and Hoefler, Torsten},
  title = {Extracting Clean Performance Models from Tainted Programs},
  year = {2021},
  isbn = {9781450382946},
  publisher = {Association for Computing Machinery},
  address = {New York, NY, USA},
  url = {https://doi.org/10.1145/3437801.3441613},
  doi = {10.1145/3437801.3441613},
  booktitle = {Proceedings of the 26th ACM SIGPLAN Symposium on Principles and Practice of Parallel Programming},
  pages = {403–417},
  numpages = {15},
  keywords = {taint analysis, high-performance computing, LLVM, performance modeling, compiler techniques},
  location = {Virtual Event, Republic of Korea},
  series = {PPoPP '21}
}
```

## Requirements

* LLVM 9.0 or higher.
* Alternatively, use our [LLVM fork](https://github.com/nwicki/llvm-project/) to enable control-flow tainting.
* libc++ 9.0 or higher, built with dfsan tainting - [see instructions](https://mcopik.github.io/blog/2020/dataflow/).

We provide a Docker image `mcopik/clang-dfsan:dfsan-9.0` with `LLVM` and `libcxx` installed.

## Installation

To build, pass clang as the default compiler, and provide paths to installation of LLVM
and tainted installation of `libc++`.

```
cmake -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ -DLLVM_DIR=... -DLIBCXX_PATH..  /path/to/perf-taint
```

The following options are supported:


| Arguments         |                                                                         |
|-------------------|-------------------------------------------------------------------------|
| **Mandatory**     |                                                                         |
| `LLVM_DIR`        | Path to the LLVM installation (no search in default paths is conducted). |
| `LIBCXX_PATH`     | Path to the `libc++` installation built with LLVM's DataFlowSanitizer.  |
| **Optional**      |                                                                         |
| `LLVM_WITH_CFSAN` | Use the control-flow tainting provided by LLVM fork (**default OFF**)   |
| `WITH_MPI`        | Build runtime with support for MPI programs (**default ON**)            |
| `JSONCPP_PATH`    | Path to a installation of jsoncpp library. When not provided, the library is downloaded and configured during build. |
| `WITH_UNIT_TESTS` | Enable unit tests (**default ON**)                                      |
| `WITH_REGRESSION_TESTS` | Enable regression tests (**default ON**)                          |
| `OMP_PATH`        | Path to a tainted installation of OpenMP library and enables support for OpenMP programs (**experimental**) |

Verify the build by running `llvm-lit tests/unit` in build directory.

## Usage

Our pipeline requires a minor code modification to allow registration and tainting program parameters.
For each program variable which should be treated as a potentially performance-relevant parameter,
users should add the `EXTRAP` annotation and a call to the `register_variable` function.

```
int size EXTRAP = atoi(argv[1]);
register_variable(&size, "size");
```

Then, the source code should be compiled into the LLVM IR bitcode.
We provide wrappers `/build-dir/bin/clang` and `/build-dir/bin/clang++` that are configured
to use the selected LLVM installation. They behave like regular C/C++ compiler, except
that our wrappers generate bitcodes from the compilation of translation units. It works
well when applied to C/C++ projects implemented with Makefiles or CMake. The IR generation
happens while compiling to object code, so the build process is not interrupted.

The helper script `bin/perf-taint` provides an integrated tool that accepts
IR files runs our instrumentation together with dfsan, and builds an executable.
In addition, the tool includes a handy wrapper that fills all necessary passes and
implements the entire compilation pipeline:

```
/build-dir/bin/perf-taint -t ${output_name} ${input_llvm_ir}
```

The documentation provides [a step-by-step explanation](docs/example.md) of our
compilation and modeling pipeline, and [covers two HPC benchmarks](docs/benchmarks.md): LULESH
and MILC's su3_rmd.

## Limitations

While `perf-taint` supports a wide set of C++, HPC, and MPI applications, it does have few limitations:
* OpenMP support is experimental and might not work as expected.
* Multithreaded applications are not supported at the moment. MPI applications with a single thread per process are fine.
* Recursive functions are not supported and they're not detected as a part of computational complexity (#16).
* Taint labels can be propagated in MPI messages, but this not supported at the moment - so far we have not found this limitation to be problematic.
* When discovering the taint dependency in MPI calls, we support only trivial MPI datatypes. Derived datatypes are not supported.
* When linking LLVM bitcode with `llvm-link`, copies of the same function, e.g., static functions present in header files, might not be resolved.
Thus, the same function might be seen by our instrumentation as "f", "f.2", "f.3", etc.
To merge such functions, use the pass option: `-perf-taint-remove-duplicates`.
The implementation uses LLVM's `MergeFunctions` pass which might have the side effect of merging
different functions presenting the same behavior. To avoid this problem, we offer the experimental
and custom duplicate removal enabled with `-perf-taint-remove-duplicates-experimental`.
**WARNING**: this
option is experimental! It checks that the functions share the same name suffix and they're located
in the same debug location. However, using different preprocessing definitions might generate
different codes for the same function in the same location - we don't verify that at the moment.

## Docker

## Testing

We implement tests as C++ programs with compilation instructions inserted in the header.
The tests are executed with the help of `llvm-lit`, and their execution can be easily parallelized with `-j$PROC`.
Tests are split into `regression` tests, which might use multiple cores and few minutes to execute,
and simple `unit` tests that are sequential and small.

For details on the compilation instructions, please inspect the definitions in [our lit
configuration file](tests/lit.cfg.in).

## Authors

* [Marcin Copik, ETH Zurich](https://github.com/mcopik/) - main developer.
* [Nicolas Wicki, ETH Zurich](https://github.com/nwicki/) - contributed the control-flow tainting in LLVM and perf-taint, in addition to various bug fixes.
* [Alexandru Calotoiu, ETH Zurich and TU Darmstadt](https://github.com/acalotoiu) - worked on the Extra-P integration.
