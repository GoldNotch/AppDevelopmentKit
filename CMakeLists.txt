cmake_minimum_required(VERSION 3.12)
include(Utils.cmake)

set(this_target "Engine")
project(${this_target})

# ------------------ options and settings --------------

option(BUILD_EXAMPLES "Build example programs" ON)
option(BUILD_WITH_VULKAN "build with vulkan" OFF)
option(BUILD_WITH_GL "build with OpenGL" OFF)

set(SOURCE_DIR ${PROJECT_SOURCE_DIR}/Source)
set(APP_DIR ${PROJECT_SOURCE_DIR}/Build/${CONFIGURATION_NAME})
set(DATA_DIR ${APP_DIR}/Data)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${APP_DIR}/Obj)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${APP_DIR})
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${APP_DIR})
set(GLOBAL_C_STANDARD 17)
set(GLOBAL_CXX_STANDARD 20)
set (CMAKE_CXX_STANDARD ${GLOBAL_CXX_STANDARD})
set (CMAKE_C_STANDATD ${GLOBAL_C_STANDARD})
cmake_policy(SET CMP0060 NEW)


# -------------------- Install conan packages ----------------------
if(NOT EXISTS "${CMAKE_BINARY_DIR}/conanfile.txt")
    message(STATUS "Copy conanfile.txt into CMake cache")
    configure_file("${PROJECT_SOURCE_DIR}/conanfile.txt" "${CMAKE_BINARY_DIR}/conanfile.txt" COPYONLY)
endif()

include(${SOURCE_DIR}/conan.cmake)

conan_cmake_autodetect(settings RUNTIME static)
message(status ${settings})
conan_cmake_install(PATH_OR_REFERENCE .
                    BUILD missing
                    REMOTE conancenter
                    SETTINGS ${settings})

list(APPEND CMAKE_MODULE_PATH ${CMAKE_BINARY_DIR}/build/generators)
list(APPEND CMAKE_PREFIX_PATH ${CMAKE_BINARY_DIR}/build/generators)

# ------------------------- Build projects ------------------------------
find_package(Catch2 REQUIRED)

ADD_SUBDIRECTORY(${SOURCE_DIR}/Core)
ADD_SUBDIRECTORY(${SOURCE_DIR}/Rendering)
ADD_SUBDIRECTORY(${SOURCE_DIR}/App)
ADD_SUBDIRECTORY(${SOURCE_DIR}/Launcher)
