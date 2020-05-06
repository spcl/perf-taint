cmake_minimum_required(VERSION 3.1)
include(ExternalProject)
project(perf-taint)

# dirty hack to remove NDEBUG
string(REPLACE "-DNDEBUG" "" CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_CXX_FLAGS_RELWITHDEBINFO}")

find_package(LLVM REQUIRED CONFIG PATHS ${LLVM_DIR} NO_DEFAULT_PATH)
add_definitions(${LLVM_DEFINITIONS})
include_directories(${LLVM_INCLUDE_DIRS})
link_directories(${LLVM_LIBRARY_DIRS})

# Verify that the compiler used is the same as in LLVM instrumentation
# Otherwise there might be an ABI incompatibility between our pass and runtime
# library and LLVM.
find_program(LLVM_OPT "opt" PATHS ${LLVM_TOOLS_BINARY_DIR} NO_DEFAULT_PATH)
message(STATUS "Using LLVM opt in ${LLVM_OPT}")
find_program(LLVM_LLC "llc" PATHS ${LLVM_TOOLS_BINARY_DIR} NO_DEFAULT_PATH)
message(STATUS "Using LLVM llc in ${LLVM_LLC}")
# TODO: allow using a different compiler?
set(CLANG ${CMAKE_C_COMPILER})
set(CLANGXX ${CMAKE_CXX_COMPILER})

###
# Mandatory: Tainted libc++ 
###
set(LIBCXX_PATH "" CACHE STRING "Path to dataflow-sanitized libc++ installation.")
if( LIBCXX_PATH STREQUAL "")
  message(SEND_ERROR "Please provide the path to dataflow-instrumented libcxx and libcxxabi")
else()
  set(CMAKE_LIBCXX_PATH "${LIBCXX_PATH}")
endif()
message(STATUS "Building with tainted libc++ from: ${LIBCXX_PATH}")

###
# Optional: Control-flow tainting
###
option(LLVM_WITH_CFSAN "Use control-flow tainting in LLVM's dfsan" OFF)
if( LLVM_WITH_CFSAN )
  set(PERF_TAINT_WITH_CF_TAINTING TRUE)
else()
  set(PERF_TAINT_WITH_CF_TAINTING FALSE)
endif()
message(STATUS "Building with control-flow tainting: ${PERF_TAINT_WITH_CF_TAINTING}")

###
# Optional: Use MPI function database and link against MPI.
###
option(WITH_MPI "Enable MPI support." ON)
if( WITH_MPI )
  find_package(MPI REQUIRED)
  include_directories(${MPI_C_INCLUDE_PATH})
  SET(MPI_INCLUDE_PATH ${MPI_C_INCLUDE_PATH})
  SET(MPI_LINK_FLAGS ${MPI_C_LIBRARIES})
  set(PERF_TAINT_WITH_MPI TRUE)
  add_definitions(-DPERF_TAINT_WITH_MPI)
else()
  set(PERF_TAINT_WITH_MPI FALSE)
  SET(MPI_INCLUDE_PATH "")
  SET(MPI_LINK_FLAGS "")
endif()
message(STATUS "Building with MPI: ${PERF_TAINT_WITH_MPI}")

###
# Optional: Use OpenMP function database and link against OpenMP.
###
set(OMP_PATH "" CACHE STRING "Path to OpenMP installation")
if( OMP_PATH STREQUAL "")
  message(STATUS "No path to dataflow-instrumented OpenMP.")
  set(PERF_TAINT_WITH_OMP FALSE)
else()
  set(PERF_TAINT_WITH_OMP true)
  add_definitions(-DPERF_TAINT_WITH_OMP)
  # TODO: Check for existence of static libraries
  set(OpenMP_C_INCLUDE_DIRS "${OMP_PATH}/include")
  set(OpenMP_C_LIBRARIES "${OMP_PATH}/lib/libiomp5.a")
endif()
message(STATUS "Building with tainted OpenMP: ${PERF_TAINT_WITH_OMP}")

###
# Optional: use an existing jsoncpp library
###
set(JSONCPP_PATH "" CACHE STRING "Path to installation of nlohmann_json")
if( NOT JSONCPP_PATH STREQUAL "")
  set(nlohmann_json_DIR "${JSONCPP_PATH}/lib/cmake/nlohmann_json")
endif()

###
# Additional options
###
set(PASS_COMPILER_FLAGS "" CACHE STRING "Additional compiler flags for libraries and tools.")
option(WITH_UNIT_TESTS ON)
if( WITH_UNIT_TESTS )
  set(PERF_TAINT_WITH_UNIT_TESTS TRUE)
else()
  set(PERF_TAINT_WITH_UNIT_TESTS FALSE)
endif()
message(STATUS "Building with unit tests: ${PERF_TAINT_WITH_UNIT_TESTS}")
option(WITH_REGRESSION_TESTS OFF)
if( WITH_REGRESSION_TESTS )
  set(PERF_TAINT_WITH_REGRESSION_TESTS TRUE)
else()
  set(PERF_TAINT_WITH_REGRESSION_TESTS FALSE)
endif()
message(STATUS "Building with regression tests: ${PERF_TAINT_WITH_REGRESSION_TESTS}")

###
# External dependencies
###
set(EXTERNAL_INSTALL_LOCATION ${CMAKE_BINARY_DIR}/external)
# JsonCPP
find_package(nlohmann_json QUIET)
if(NOT nlohmann_json_FOUND)
  message(STATUS "Downloading and building nlohmann_json dependency")
  ExternalProject_Add(nlohmann_json
    GIT_REPOSITORY https://github.com/nlohmann/json.git
    CMAKE_ARGS -DJSON_BuildTests=Off -DJSON_MultipleHeaders=ON -DCMAKE_INSTALL_PREFIX=${EXTERNAL_INSTALL_LOCATION}/nlohmann_json/install
    PREFIX ${EXTERNAL_INSTALL_LOCATION}/nlohmann_json/build
    UPDATE_DISCONNECTED 0
    # Disable update in every build
    UPDATE_COMMAND ""
    BUILD_ALWAYS 0
    INSTALL_DIR ${EXTERNAL_INSTALL_LOCATION}/nlohmann_json/install
  )
  set(JSONCPP_INCLUDE_DIRS ${EXTERNAL_INSTALL_LOCATION}/nlohmann_json/install/include)
  ExternalProject_Get_Property(nlohmann_json install_dir)
  # unfortunately, no better way...
  # TODO: add jsoncpp as a git submodule, checkout and then add as subdirectory?
  include_directories(${JSONCPP_INCLUDE_DIRS})
else()
  include_directories($<TARGET_PROPERTY:nlohmann_json::nlohmann_json,INTERFACE_INCLUDE_DIRECTORIES>)
endif()

include_directories(include)

###
# Main pass: build C++14, PIC and no RTTI
###
file(GLOB DfsanInstrument
    "lib/dfsan-instr/*.cpp"
)
add_library(DfsanInstrument MODULE ${DfsanInstrument} lib/ParameterFinder.cpp)
set_property(TARGET DfsanInstrument PROPERTY CXX_STANDARD 14)
set_target_properties(DfsanInstrument PROPERTIES COMPILE_FLAGS "-fno-rtti")
set_target_properties(DfsanInstrument PROPERTIES POSITION_INDEPENDENT_CODE On)
set_target_properties(DfsanInstrument PROPERTIES COMPILE_FLAGS "${PASS_COMPILER_FLAGS} -fno-rtti -g")
add_dependencies(DfsanInstrument nlohmann_json)

###
# Runtime library: link to JSON, build C++14, PIC
###
add_library(dfsan_runtime STATIC lib/runtime/runtime.c lib/runtime/json_export.cpp)
target_link_libraries(dfsan_runtime PRIVATE ${MPI_C_LIBRARIES})
set_target_properties(dfsan_runtime PROPERTIES
  COMPILE_FLAGS "-stdlib=libc++ -I${CMAKE_LIBCXX_PATH}/include/c++/v1 -W -Wall -Wextra -pedantic -fsanitize=dataflow -fsanitize-blacklist=${CMAKE_SOURCE_DIR}/share/dfsan_abilist.txt"
)
set_property(TARGET dfsan_runtime PROPERTY POSITION_INDEPENDENT_CODE ON)
add_dependencies(dfsan_runtime nlohmann_json)

###
# Tools
###

add_executable(ScorePGenerator tools/ScorePGenerator.cpp)
set_property(TARGET ScorePGenerator PROPERTY CXX_STANDARD 14)
add_dependencies(ScorePGenerator nlohmann_json)
set_target_properties(ScorePGenerator PROPERTIES COMPILE_FLAGS "-g -Wall")
set_target_properties(ScorePGenerator PROPERTIES RUNTIME_OUTPUT_DIRECTORY tools)

add_executable(JSONConverter tools/JSONConverter.cpp)
set_property(TARGET JSONConverter PROPERTY CXX_STANDARD 14)
set_target_properties(JSONConverter PROPERTIES COMPILE_FLAGS "-g -Wall")
add_dependencies(JSONConverter nlohmann_json)
set_target_properties(JSONConverter PROPERTIES RUNTIME_OUTPUT_DIRECTORY tools)

add_executable(model_comparator tools/model_comparator.cpp)
set_property(TARGET model_comparator PROPERTY CXX_STANDARD 14)
add_dependencies(model_comparator nlohmann_json)
set_target_properties(model_comparator PROPERTIES COMPILE_FLAGS "-g -Wall")
set_target_properties(model_comparator PROPERTIES RUNTIME_OUTPUT_DIRECTORY tools)

configure_file(benchmarks/rebuild_benchmarks.sh.in benchmarks/rebuild_benchmarks.sh @ONLY)
configure_file(bin/perf-taint.in bin/perf-taint @ONLY)
configure_file(bin/clang++.in bin/clang++ @ONLY)
configure_file(bin/clang.in bin/clang @ONLY)
configure_file(tests/lit.cfg.in tests/lit.cfg @ONLY)
configure_file(tools/rebuild_tests.sh.in tools/rebuild_tests.sh @ONLY)

