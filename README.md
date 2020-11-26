# perf-taint

The implementation of taint analysis for performance modeling. The tool requires
LLVM in version 9.0+ and for analysis of C++ applications, it needs a dataflow-sanitized
build of [libc++](https://mcopik.github.io/c++/2020/02/24/dataflow/).

## Building

To build, pass clang as the default compiler, and provide paths to installation of LLVM
and tainted installation of `libc++`.

```
cmake -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ -DLLVM_DIR=... -DLIBCXX_PATH..  /path/to/perf-taint
```

The following options are supported:

* `LLVM_DIR` **mandatory** - provides paths to selected LLVM instalations. No
search in default paths is conducted.
* `LIBCXX_PATH` **mandatory** - path to an installation of `libc++` built with
LLVM's DataFlowSanitizer.
* `LLVM_WITH_CFSAN` **default OFF** - use the control-flow tainting
feature when available in the LLVM build.
* `WITH_MPI` **default ON** - build runtime with support for MPI programs.
* `OMP_PATH` **optional** - path to a tainted installation of OpenMP library. Enables
support for OpenMP programs.
* `JSONCPP_PATH` **optional** - path to an existing installation of jsoncpp library.
When not provided, the library will be downloaded and configured during build.
* `WITH_UNIT_TESTS` **default ON** - include unit tests.
* `WITH_REGRESSION_TESTS` **default ON** - include regression tests.

Verify the build by running `llvm-lit tests` in build directory.

The helper script `bin/perf-taint` provides an integrated tool that accepts
IR files, runs our instrumentation together with dfsan and builds an executable.
The tool includes a handy wrapper of clang that fills all necessary passes and
implements the entire compilation pipeline:

```
/build-dir/bin/perf-taint -t ${output_name} ${input_llvm_ir}
```

The `benchmarks` directory contains ready-to-use LLVM IR bitcodes for LULESH
and MILC's su3_rmd benchmarks that have been manually instrumented with
parameter registration for perf-taint.
