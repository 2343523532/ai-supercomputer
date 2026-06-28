cmake_minimum_required(VERSION 3.14)
project(cpp-safe-bank CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

include(FetchContent)
FetchContent_Declare(
  cpp_httplib
  GIT_REPOSITORY https://github.com/yhirose/cpp-httplib.git
  GIT_TAG v0.18.3
)
FetchContent_GetProperties(cpp_httplib)
if(NOT cpp_httplib_POPULATED)
  FetchContent_Populate(cpp_httplib)
endif()

add_executable(cpp-safe-bank src/main.cpp)
target_include_directories(cpp-safe-bank PRIVATE ${cpp_httplib_SOURCE_DIR})

if(CMAKE_CXX_COMPILER_ID MATCHES "GNU|Clang")
  target_compile_options(cpp-safe-bank PRIVATE -Wall -Wextra -Wpedantic)
endif()
