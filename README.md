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
