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
set(JSONCPP_PATH "" CACHE STRING "Path to installation of nlohmann_json")

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

if( NOT JSONCPP_PATH STREQUAL "")
  set(nlohmann_json_DIR "${JSONCPP_PATH}/lib/cmake/nlohmann_json")
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
find_package(nlohmann_json) #QUIET)
if(NOT nlohmann_json_FOUND)
  message(INFO "Downloading and building nlohmann_json dependency")
  ExternalProject_Add(nlohmann_json
    GIT_REPOSITORY https://github.com/nlohmann/json.git
    CMAKE_ARGS -DJSON_BuildTests=Off -DJSON_MultipleHeaders=ON -DCMAKE_INSTALL_PREFIX=${EXTERNAL_INSTALL_LOCATION}/nlohmann_json/install
    PREFIX ${EXTERNAL_INSTALL_LOCATION}/nlohmann_json/build
    UPDATE_DISCONNECTED 1
    BUILD_ALWAYS 1
    INSTALL_DIR ${EXTERNAL_INSTALL_LOCATION}/nlohmann_json/install
  )
  set(JSONCPP_INCLUDE_DIRS ${EXTERNAL_INSTALL_LOCATION}/nlohmann_json/install/include)
  #TODO: how to get target here?
endif()


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
target_link_libraries(DfsanInstrument PRIVATE nlohmann_json::nlohmann_json)
#add_dependencies(DfsanInstrument nlohmann_json)
#target_link_libraries(DfsanInstrument LLVMPolly)

# Split into two targets so C++ JSON code is not instrumented
add_library(json_export STATIC lib/runtime/json_export.cpp)
add_library(dfsan_runtime STATIC lib/runtime/runtime.c lib/runtime/json_export.cpp)
target_link_libraries(dfsan_runtime PRIVATE ${MPI_C_LIBRARIES})
target_link_libraries(dfsan_runtime PRIVATE nlohmann_json::nlohmann_json)
set_target_properties(dfsan_runtime PROPERTIES
  COMPILE_FLAGS "-stdlib=libc++ -I${LIBCXX_PATH}/include/c++/v1 -fsanitize=dataflow -fsanitize-blacklist=${CMAKE_SOURCE_DIR}/share/dfsan_abilist.txt"
)
add_dependencies(dfsan_runtime nlohmann_json)
set_property(TARGET dfsan_runtime PROPERTY POSITION_INDEPENDENT_CODE ON)

set_target_properties(json_export PROPERTIES
  COMPILE_FLAGS "-stdlib=libc++ -I${LIBCXX_PATH}/include/c++/v1 -fsanitize=dataflow -fsanitize-blacklist=${CMAKE_SOURCE_DIR}/share/dfsan_abilist.txt"
)
add_dependencies(json_export nlohmann_json)
target_link_libraries(json_export PRIVATE nlohmann_json::nlohmann_json)
set_property(TARGET json_export PROPERTY POSITION_INDEPENDENT_CODE ON)

add_executable(ScorePGenerator lib/ScorePGenerator.cpp)
set_property(TARGET ScorePGenerator PROPERTY CXX_STANDARD 14)
add_dependencies(ScorePGenerator nlohmann_json)
target_link_libraries(ScorePGenerator PRIVATE nlohmann_json::nlohmann_json)

add_executable(JSONConverter lib/JSONConverter.cpp)
set_property(TARGET JSONConverter PROPERTY CXX_STANDARD 14)
add_dependencies(JSONConverter nlohmann_json)
target_link_libraries(JSONConverter PRIVATE nlohmann_json::nlohmann_json)

configure_file(tests/lit.cfg.in tests/lit.cfg @ONLY)


