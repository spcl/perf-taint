# perf-taint

**LLVM-based taint analysis framework for HPC performance modeling.**

# Example:
[![CircleCI](https://circleci.com/gh/spcl/perf-taint.svg?style=shield)](https://circleci.com/ghspcl/perf-taint)
![Release](https://img.shields.io/github/v/release/spcl/perf-taint)
![GitHub issues](https://img.shields.io/github/issues/spcl/perf-taint)
![GitHub pull requests](https://img.shields.io/github/issues-pr/spcl/perf-taint)

The implementation of taint analysis for performance modeling. The tool requires
LLVM in version 9.0+ and for analysis of C++ applications, it needs a dataflow-sanitized
build of [libc++](https://mcopik.github.io/c++/2020/02/24/dataflow/).

When using perf-taint, please cite [our PPoPP'21 paper](https://doi.org/10.1145/3437801.3441613).
A preprint of our paper is [available on arXiv](https://arxiv.org/abs/2012.15592), and you can
find more details about reasearch work [in this paper summary](https://mcopik.github.io/projects/perf_taint/).

```
Marcin Copik, Alexandru Calotoiu, Tobias Grosser, Nicolas Wicki, Felix Wolf, and Torsten Hoefler. 2021.
Extracting clean performance models from tainted programs.
In Proceedings of the 26th ACM SIGPLAN Symposium on Principles and Practice of Parallel Programming (PPoPP '21).
Association for Computing Machinery, New York, NY, USA, 403–417. DOI:https://doi.org/10.1145/3437801.3441613
```

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

## Authors

* [Marcin Copik, ETH Zurich](https://github.com/mcopik/) - main developer.
* [Nicolas Wicki, ETH Zurich](https://github.com/nwicki/) - contributed the control-flow tainting in LLVM and perf-taint, in addition to various bug fixes.
* [Alexandru Calotoiu, ETH Zurich and TU Darmstadt](https://github.com/acalotoiu) - helped with the Extra-P integration.
