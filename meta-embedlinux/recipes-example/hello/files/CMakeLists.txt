cmake_minimum_required(VERSION 3.16)
project(hello LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

add_executable(hello hello.cpp)

include(GNUInstallDirs)
install(TARGETS hello RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
