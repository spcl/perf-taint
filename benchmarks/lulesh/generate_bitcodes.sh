#!/bin/bash

SOURCE_DIRECTORY=$1
BUILD_DIRECTORY=$2

pushd ${SOURCE_DIRECTORY}/benchmarks/lulesh > /dev/null
git submodule update --recursive --init LULESH
cd LULESH\
  && git checkout b56882ba0c1b972631e1e54a8256d2a07893e324\
  && git checkout -- .\
  && git apply ../lulesh.patch

# Build with MPI
make CXX=${BUILD_DIRECTORY}/bin/clang++ CXXFLAGS="-fno-inline-functions -g -I. -Wall -DUSE_MPI=1" LDFLAGS="-g" all
llvm-link *.bc -o lulesh_mpi.bc
mv lulesh_mpi.bc ..
make clean && rm *.bc

popd > /dev/null
