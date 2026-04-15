# Copyright (c) 2013, Ruslan Baratov
# All rights reserved.

if(DEFINED POLLY_COMPILER_CUDA_CMAKE)
  return()
else()
  set(POLLY_COMPILER_CUDA_CMAKE 1)
endif()

find_program(CMAKE_CUDA_COMPILER nvcc)
find_program(CMAKE_CUDA_HOST_COMPILER clang++)

set(
    CMAKE_CUDA_COMPILER
    "${CMAKE_CUDA_COMPILER}"
    CACHE
    FILEPATH
    "CUDA compiler"
    FORCE
)

set(
    CMAKE_CUDA_HOST_COMPILER
    "${CMAKE_CUDA_HOST_COMPILER}"
    CACHE
    FILEPATH
    "CUDA host compiler"
    FORCE
)




if(NOT DEFINED CMAKE_CUDA_ARCHITECTURES)
  set(CMAKE_CUDA_ARCHITECTURES "all-major" CACHE STRING "CUDA architectures" FORCE)
endif()