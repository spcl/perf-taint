project(loop_extractor.cpp)

find_package(LLVM REQUIRED CONFIG)
add_definitions(${LLVM_DEFINITIONS})
include_directories(${LLVM_INCLUDE_DIRS})
link_directories(${LLVM_LIBRARY_DIRS})
include_directories(include)

add_library(LLVMLoopExtractor MODULE lib/LoopExtractor.cpp lib/LoopAnalyzer.cpp lib/io/SCEVToString.cpp lib/LoopCounters.cpp)

set_property(TARGET LLVMLoopExtractor PROPERTY CXX_STANDARD 14)
set_target_properties(LLVMLoopExtractor PROPERTIES COMPILE_FLAGS "-fno-rtti"
)

