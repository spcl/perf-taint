# perf-taint

The implementation of taint analysis for performance modeling. The tool requires
LLVM in version 9.0+ and for analysis of C++ applications, it needs a dataflow-sanitized
build of [libc++](https://mcopik.github.io/c++/2020/02/24/dataflow/).

To build, pass clang as the default compiler, provide paths to installation of LLVM
and sanitized `libc++`.

```
cmake -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ -DLLVM_DIR=... -DLIBCXX_PATH..  /path/to/perf-taint
```

Verify the build by running `llvm-lit tests/dfsan-unit` in build directory.
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
