cmake_minimum_required(VERSION 3.19)
# Set to the lowest version that supports needed features: in lower versions
# qt_finalize_target needs to be called manually, instead of being a part of
# qt_add_executable

project(WareLog VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
# The support for C++20 is experimental for Qt6, so only use the newer version
# if needed later on.
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6
    REQUIRED COMPONENTS
        Quick
        Core
)

set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOMOC ON)

qt_standard_project_setup(
    REQUIRES 6.7
    # I want to build for a device with Android 8, which is not supported
    # anymore starting Qt6.8
)

add_subdirectory(src/app)
