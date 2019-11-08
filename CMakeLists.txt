cmake_minimum_required(VERSION 3.1)
include(ExternalProject)


project(loop_extractor.cpp)
# dirty hack to remove NDEBUG
string(REPLACE "-DNDEBUG" "" CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_CXX_FLAGS_RELWITHDEBINFO}")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall")

find_package(LLVM REQUIRED CONFIG)
add_definitions(${LLVM_DEFINITIONS})
include_directories(${LLVM_INCLUDE_DIRS})
link_directories(${LLVM_LIBRARY_DIRS})

find_package(MPI REQUIRED)
include_directories(${MPI_C_INCLUDE_PATH})
SET(CMAKE_MPI_LINK_FLAGS ${MPI_C_LIBRARIES})

set(LIBCXX_PATH "" CACHE STRING "Path to libcxx and libcxxabi installation")
set(LIBOMP_PATH "" CACHE STRING "Path to libiomp5.a installation")

if( LIBCXX_PATH STREQUAL "")
  # TODO: Check for existence of static libraries
  message(SEND_ERROR "Please provide the path to dataflow-instrumented libcxx and libcxxabi")
else()
  set(CMAKE_LIBCXX_PATH "${LIBCXX_PATH}/lib/")
endif()

if( LIBOMP_PATH STREQUAL "")
  # TODO: Check for existence of static libraries
  message(SEND_ERROR "Please provide the path to dataflow-instrumented OpenMP.")
else()
  set(CMAKE_LIBOMP "${LIBOMP_PATH}/lib/libiomp5.a")
endif()

# No need for Polly anymore
#find_package(Polly REQUIRED CONFIG)
#add_definitions(${Polly_DEFINITIONS})
#message(${Polly_DEFINITIONS})
#include_directories(${Polly_INCLUDE_DIRS})
#link_directories(${Polly_LIBRARY_DIRS})

include_directories(include)

set(EXTERNAL_INSTALL_LOCATION ${CMAKE_BINARY_DIR}/external)

# JsonCPP
find_package(Jsoncpp QUIET)
if(NOT Jsoncpp_FOUND)
  ExternalProject_Add(jsoncpp
    GIT_REPOSITORY https://github.com/nlohmann/json.git
    CMAKE_ARGS -DJSON_BuildTests=Off -DJSON_MultipleHeaders=ON -DCMAKE_INSTALL_PREFIX=${EXTERNAL_INSTALL_LOCATION}/jsoncpp/jsoncpp
    PREFIX ${EXTERNAL_INSTALL_LOCATION}/jsoncpp/build
    UPDATE_DISCONNECTED 1
    BUILD_ALWAYS 1
    INSTALL_DIR ${EXTERNAL_INSTALL_LOCATION}/jsoncpp/jsoncpp
  )
  set(JSONCPP_INCLUDE_DIRS ${EXTERNAL_INSTALL_LOCATION}/jsoncpp/jsoncpp/include)
endif()
include_directories(${JSONCPP_INCLUDE_DIRS})


# Not needed anymore..
#file(GLOB StaticExtractor
#    "lib/static-extractor/*.cpp"
#)
#add_library(StaticExtractor MODULE ${StaticExtractor} lib/ParameterFinder.cpp)
#set_property(TARGET StaticExtractor PROPERTY CXX_STANDARD 14)
#set_target_properties(StaticExtractor PROPERTIES COMPILE_FLAGS "-fno-rtti")
#set_target_properties(StaticExtractor PROPERTIES POSITION_INDEPENDENT_CODE On)
#add_dependencies(StaticExtractor jsoncpp)
#target_link_libraries(StaticExtractor LLVMPolly)

file(GLOB DfsanInstrument
    "lib/dfsan-instr/*.cpp"
)
add_library(DfsanInstrument MODULE ${DfsanInstrument} lib/ParameterFinder.cpp)
set_property(TARGET DfsanInstrument PROPERTY CXX_STANDARD 14)
set_target_properties(DfsanInstrument PROPERTIES COMPILE_FLAGS "-fno-rtti")
set_target_properties(DfsanInstrument PROPERTIES POSITION_INDEPENDENT_CODE On)
add_dependencies(DfsanInstrument jsoncpp)
#target_link_libraries(DfsanInstrument LLVMPolly)

# Split into two targets so C++ JSON code is not instrumented
add_library(json_export STATIC lib/runtime/json_export.cpp)
add_library(dfsan_runtime STATIC lib/runtime/runtime.c lib/runtime/json_export.cpp)
target_link_libraries(dfsan_runtime ${MPI_C_LIBRARIES})
set_target_properties(dfsan_runtime PROPERTIES
    COMPILE_FLAGS "-fsanitize=dataflow\
      -fsanitize-blacklist=${CMAKE_SOURCE_DIR}/share/dfsan_abilist.txt\
      -g -stdlib=libc++ -I${LIBCXX_PATH}/include/c++/v1"
)
set_property(TARGET dfsan_runtime PROPERTY POSITION_INDEPENDENT_CODE ON)
set_property(TARGET json_export PROPERTY POSITION_INDEPENDENT_CODE ON)
add_dependencies(json_export jsoncpp)
add_dependencies(dfsan_runtime jsoncpp)

add_executable(ScorePGenerator lib/ScorePGenerator.cpp)
set_property(TARGET ScorePGenerator PROPERTY CXX_STANDARD 14)
add_dependencies(ScorePGenerator jsoncpp)

add_executable(JSONConverter lib/JSONConverter.cpp)
set_property(TARGET JSONConverter PROPERTY CXX_STANDARD 14)
add_dependencies(JSONConverter jsoncpp)

configure_file(tests/lit.cfg.in tests/lit.cfg @ONLY)


