#!/bin/bash

SOURCE_DIRECTORY=$1
BUILD_DIRECTORY=$2

pushd ${SOURCE_DIRECTORY}/benchmarks/milc > /dev/null

#wget http://www.physics.utah.edu/~detar/milc_qcd-7.8.1.tar.gz
#tar -xf milc_qcd-7.8.1.tar.gz 

# Updates
cp two_params/ks_imp_dyn/* milc_qcd-7.8.1/ks_imp_dyn/
cp two_params/generic/* milc_qcd-7.8.1/generic/
cp Makefile milc_qcd-7.8.1
# Build with MPI
cd milc_qcd-7.8.1/ks_imp_dyn
make CC=${BUILD_DIRECTORY}/bin/clang
cd ../..
find milc_qcd-7.8.1 -name \*.bc | xargs llvm-link -o milc_mpi.bc
find milc_qcd-7.8.1 -name \*.bc | xargs rm
find milc_qcd-7.8.1 -name \*.o | xargs rm

# Updates
cp many_params/ks_imp_dyn/* milc_qcd-7.8.1/ks_imp_dyn/
cp many_params/generic/* milc_qcd-7.8.1/generic/
cp Makefile milc_qcd-7.8.1
# Build with MPI
cd milc_qcd-7.8.1/ks_imp_dyn
make CC=${BUILD_DIRECTORY}/bin/clang
cd ../..
find milc_qcd-7.8.1 -name \*.bc | xargs llvm-link -o milc_full.bc
find milc_qcd-7.8.1 -name \*.bc | xargs rm
find milc_qcd-7.8.1 -name \*.o | xargs rm

popd > /dev/null

