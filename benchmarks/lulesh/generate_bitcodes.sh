#!/bin/bash

SOURCE_DIRECTORY=$1
BUILD_DIRECTORY=$2

pushd ${SOURCE_DIRECTORY}/benchmarks/lulesh > /dev/null
git submodule update --recursive --init LULESH
cd LULESH\
  && git checkout -- .\
  && git checkout b56882ba0c1b972631e1e54a8256d2a07893e324\
  && git apply ../lulesh.patch

# Build with MPI
make CXX=${BUILD_DIRECTORY}/bin/clang++ CXXFLAGS="-fno-inline-functions -O2 -mllvm -disable-llvm-optzns -g -I. -Wall -DUSE_MPI=1" LDFLAGS="-g" all
llvm-link *.bc -o lulesh_mpi.bc
mv lulesh_mpi.bc ..
make clean && rm *.bc
cd ..

cd LULESH\
  && git checkout -- .\
  && git apply ../lulesh_full.patch
# Build with MPI
make CXX=${BUILD_DIRECTORY}/bin/clang++ CXXFLAGS="-fno-inline-functions -O2 -mllvm -disable-llvm-optzns -g -I. -Wall -DUSE_MPI=1" LDFLAGS="-g" all
llvm-link *.bc -o lulesh_full.bc
mv lulesh_full.bc ..
make clean && rm *.bc

popd > /dev/null
