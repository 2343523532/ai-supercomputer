cmake_minimum_required(VERSION 3.16)
project(cpp_safe_bank LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

add_executable(cpp-safe-bank main.cpp)
target_include_directories(cpp-safe-bank PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})

if(APPLE)
  target_link_libraries(cpp-safe-bank PRIVATE "-framework CoreFoundation" "-framework Security")
endif()
