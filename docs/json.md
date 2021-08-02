
Perf-taint provides a list of functions that performance changes with input parameters.
For each function, we provide information on the loop structure and parameters affecting each
loop's iteration count and exit conditions.
The information is stored in a single JSON object.

Let's consider a simple example from the unit test [`tests/unit/dataflow/cf_branches.cpp`](tests/unit/dataflow/cf_branches.cpp).
The function `f` has three input parameters and three loops. The first loop depends on parameter
`b`, the second depends on both `a` and `b` and contains a control-flow branch depending on `c`,
and the last one depends on `a`.

```c++
int f(int a, int b, int c)
{
    int tmp = 1;
    for(int i = 0; i < b; ++i) {
      tmp += 2*i;
    }
    for(int i = 0; i < a + b; ++i) {
      if(c > 5)
        tmp += i;
      else
        tmp += 2*i;
    }
    for(int i = 0; i < a; ++i) {
      tmp += 2*i;
    }
    return tmp;
}
```

We invoke the functions two times from the main function, each time with a different combination
of input parameters.

```c++
int main(int argc, char ** argv)
{
    int x1 EXTRAP = atoi(argv[1]);
    int x2 EXTRAP = atoi(argv[2]);
    perf_taint::register_variable(&x1, VARIABLE_NAME(x1));
    perf_taint::register_variable(&x2, VARIABLE_NAME(x2));
    int y = 2*x1 + 1;

    f(x2, y, 10);
    f(x2, y, x1);
  
    // rest of code
    return 0;
}
```

First, the JSON result contains a list of all functions and parameters. Next, function names lists
are sorted according to the function's index. The mangled and demangled names are used to generate
Score-P instrumentation filters (mangled) and matchings for Extra-P call paths (demangled).

```json
{
  "functions_demangled_names": [
    "f(int, int, int)",
    "g(int, int, int)",
    "h(int, int, int)",
    "main",
    "atoi"
  ],
  "functions_mangled_names": [
    "_Z1fiii",
    "_Z1giii",
    "_Z1hiii",
    "main",
    "atoi"
  ],
  "functions_names": [
    "f",
    "g",
    "h",
    "main",
    "atoi"
  ],
  "parameters": [
    "x1",
    "x2"
  ]
}
```

However, the most important part of the JSON is the `_functions` entry that contains all the
data on functions dependencies and structure. The entries use the mangled name as the key
and contain the function index, source code location, and performance data.

```json
{
  "functions": {
    "_Z1fiii": {
      "file": "tests/unit/dataflow/cf_branches.cpp",
      "func_idx": 0,
      "line": 19,
      "loops": [...]
    }
  }
}
```

The `loops` array contains a sequence of entries, each one corresponding to `distinct` calls
to this function. Two function calls representing the same performance profile are considered
equal, even if they result from different call sites.

Below we see the first entry in this array. The `callstacks` array includes all call sites for
this function and uses function indices to describe the entire call stack. In this example,
we call the function `f` directly from `main`, which index is 3.
The object `instance` describes the parameter effect on each loop.
As `x2` and `x1` are passed in the first and second arguments,
respectively, we can see how they affect the iteration count of each loop.
Constant loops are ignored.

```json
{
  "callstacks": [
    [
      3
    ]
  ],
  "instance": {
    "0": {
      "level": 0,
      "params": [
        [
          "x2"
        ]
      ]
    },
    "1": {
      "level": 0,
      "params": [
        [
          "x1",
          "x2"
        ]
      ]
    },
    "2": {
      "level": 0,
      "params": [
        [
          "x1"
        ]
      ]
    }
  }
}
```

We have no nested loops in this function. Otherwise, we would have seen nested entries as in
this example: the outer loop is affected by both `x1` and `x2`, and it includes another loop
affected only by `x2`. The `level` counter describes the nesting level of each loop.

```json
"instance": {
  "0": {
    "level": 0,
    "loops": {
      "0": {
        "level": 1,
        "params": [
          [
            "x2"
          ]
        ]
      }
    },
    "params": [
      [
        "x1",
        "x2"
      ]
    ]
  }
}
```

Function `f` was called twice in `main` with a varying combination of input parameters.
The second call site additionally included `x1` passed as the third parameter (in the first
call, we used a constant value as the last parameter).
This parameter is used in a conditional branch inside the second loop.
We detect such situations as a parameter could be used to conditionally select one version of an
algorithm, affecting the performance of this application.
Therefore, in the second instance, we notice an additional `branches` structure describing
the detection of parametric dependency.

```json
{
  "callstacks": [
    [
      3
    ]
  ],
  "instance": {
    "0": {
      "level": 0,
      "params": [
        [
          "x2"
        ]
      ]
    },
    "1": {
      "branches": {
        "0": [
          "x1"
        ]
      },
      "level": 0,
      "params": [
        [
          "x1",
          "x2"
        ]
      ]
    },
    "2": {
      "level": 0,
      "params": [
        [
          "x1"
        ]
      ]
    }
  }
}
```

The JSON contains all the information needed to enhance performance modeling - which functions
are performance relevant, how parameters affect their computational complexity, and which parameters
are used together.

