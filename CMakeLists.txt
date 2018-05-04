project(loop_extractor.cpp)

find_package(LLVM REQUIRED CONFIG)
add_definitions(${LLVM_DEFINITIONS})
include_directories(${LLVM_INCLUDE_DIRS})
link_directories(${LLVM_LIBRARY_DIRS})
include_directories(include)

add_library(LLVMLoopTools STATIC lib/io/SCEVToString.cpp lib/LoopCounters.cpp lib/io/ValueToString.cpp)
set_property(TARGET LLVMLoopTools PROPERTY CXX_STANDARD 14)
set_target_properties(LLVMLoopTools PROPERTIES COMPILE_FLAGS "-fno-rtti")

add_library(LLVMLoopExtractor MODULE lib/LoopExtractorPass.cpp lib/LoopAnalyzer.cpp)
add_library(LLVMLoopStatistics MODULE lib/LoopStatisticsPass.cpp)
target_link_libraries(LLVMLoopExtractor PRIVATE LLVMLoopTools)
target_link_libraries(LLVMLoopStatistics PRIVATE LLVMLoopTools)
set_property(TARGET LLVMLoopExtractor PROPERTY CXX_STANDARD 14)
set_property(TARGET LLVMLoopStatistics PROPERTY CXX_STANDARD 14)
set_target_properties(LLVMLoopExtractor PROPERTIES COMPILE_FLAGS "-fno-rtti")
set_target_properties(LLVMLoopStatistics PROPERTIES COMPILE_FLAGS "-fno-rtti")

