cmake_minimum_required(VERSION 3.15)

set(CMAKE_TOOLCHAIN_FILE "cmake/aarch64-none-elf.cmake" CACHE PATH "")
set(CMAKE_GENERATOR Ninja)
#set(CMAKE_MAKE_PROGRAM ninja)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
include(git)

project(blaze LANGUAGES C CXX ASM)

set(TARGET_ARCH "arm64" CACHE STRING "Target architecture (arm64 or x64)")
set_property(CACHE TARGET_ARCH PROPERTY STRINGS "arm64" "x64")

message(STATUS "Target architecture: ${TARGET_ARCH}")

if(TARGET_ARCH STREQUAL "arm64")
  set(TARGET_ARCH_ARM64 TRUE)
  set(TARGET_ARCH_64 TRUE)
elseif(TARGET_ARCH STREQUAL "x64")
  set(TARGET_ARCH_x64 TRUE)
  set(TARGET_ARCH_64 TRUE)
else()
  message(FATAL_ERROR "Unsupported target architecture.")
endif()

if(NOT DEFINED CMAKE_TOOLCHAIN_FILE)
    message(FATAL_ERROR "CMAKE_TOOLCHAIN_FILE must be specified for cross-compilation")
endif()

add_subdirectory(bin)
#add_subdirectory(lib)