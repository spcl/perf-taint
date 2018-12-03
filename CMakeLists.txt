cmake_minimum_required(VERSION 3.1)
include(ExternalProject)

project(loop_extractor.cpp)
# dirty hack to remove NDEBUG
string( REPLACE "-DNDEBUG" "" CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_CXX_FLAGS_RELWITHDEBINFO}")

#find_package(LLVM REQUIRED CONFIG)
#add_definitions(${LLVM_DEFINITIONS})
#include_directories(${LLVM_INCLUDE_DIRS})
#link_directories(${LLVM_LIBRARY_DIRS})

find_package(Polly REQUIRED CONFIG)
add_definitions(${Polly_DEFINITIONS})
message(${Polly_DEFINITIONS})
include_directories(${Polly_INCLUDE_DIRS})
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


file(GLOB StaticExtractor
    "lib/static-extractor/*.cpp"
)
add_library(StaticExtractor MODULE ${StaticExtractor} lib/ParameterFinder.cpp)
set_property(TARGET StaticExtractor PROPERTY CXX_STANDARD 14)
set_target_properties(StaticExtractor PROPERTIES COMPILE_FLAGS "-fno-rtti")
set_target_properties(StaticExtractor PROPERTIES POSITION_INDEPENDENT_CODE On)
add_dependencies(StaticExtractor jsoncpp)
target_link_libraries(StaticExtractor LLVMPolly)

file(GLOB DfsanInstrument
    "lib/dfsan-instr/*.cpp"
)
add_library(DfsanInstrument MODULE ${DfsanInstrument} lib/ParameterFinder.cpp)
set_property(TARGET DfsanInstrument PROPERTY CXX_STANDARD 14)
set_target_properties(DfsanInstrument PROPERTIES COMPILE_FLAGS "-fno-rtti")
set_target_properties(DfsanInstrument PROPERTIES POSITION_INDEPENDENT_CODE On)
add_dependencies(DfsanInstrument jsoncpp)
target_link_libraries(DfsanInstrument LLVMPolly)

configure_file(tests/lit.cfg.in tests/lit.cfg @ONLY)


