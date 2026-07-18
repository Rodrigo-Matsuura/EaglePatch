cmake_minimum_required(VERSION 3.15)
project(EaglePatch LANGUAGES CXX)

# Enforce 32-bit x86 architecture on Windows MSVC, as these ASI plugins are built for 32-bit games.
if(MSVC)
  if(NOT CMAKE_SIZEOF_VOID_P EQUAL 4)
    message(FATAL_ERROR "EaglePatch must be compiled as a 32-bit (x86) target. Please configure CMake with -A Win32.")
  endif()
endif()

# Set output directories matching the original layout (EaglePatch/bin/Debug or bin/Release)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/EaglePatch/bin")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/EaglePatch/bin")
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/EaglePatch/bin")

# Set MSVC runtime library selection to static (corresponds to staticruntime "on" -> /MT or /MTd)
set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")

# Common compile options
add_compile_options(
    $<$<CXX_COMPILER_ID:MSVC>:/Zc:sizedDealloc->
    $<$<CXX_COMPILER_ID:MSVC>:/fp:fast>
)

# Common sources and headers
set(SHARED_SOURCES
    patcher/patcher.cpp
    patcher/patcher.h
    EaglePatch/shared/console.h
    EaglePatch/shared/ini_reader.h
    EaglePatch/shared/console.cpp
    EaglePatch/shared/ini_reader.cpp
)

# Common include directories
set(SHARED_INCLUDE_DIRS
    patcher
)

# ------------------------------------------------------------------------------
# Target: EaglePatchAC1
# ------------------------------------------------------------------------------
add_library(EaglePatchAC1 SHARED
    ${SHARED_SOURCES}
    EaglePatch/src/ac1.cpp
)

target_include_directories(EaglePatchAC1 PRIVATE ${SHARED_INCLUDE_DIRS})

target_compile_definitions(EaglePatchAC1 PRIVATE
    WIN32_LEAN_AND_MEAN
    _CRT_SECURE_NO_WARNINGS
    _CRT_NONSTDC_NO_DEPRECATE
    _USE_32BIT_TIME_T
    NOMINMAX
    _MBCS
    DLL_NAME="EaglePatchAC1"
)

# MSVC-specific link requirements and settings
target_link_libraries(EaglePatchAC1 PRIVATE
    $<$<CXX_COMPILER_ID:MSVC>:legacy_stdio_definitions>
)

target_link_options(EaglePatchAC1 PRIVATE
    $<$<CXX_COMPILER_ID:MSVC>:/SAFESEH:NO>
    $<$<CXX_COMPILER_ID:MSVC>:/IGNORE:4222>
)

target_compile_options(EaglePatchAC1 PRIVATE
    $<$<AND:$<CXX_COMPILER_ID:MSVC>,$<CONFIG:Release>>:/O2>
    $<$<AND:$<CXX_COMPILER_ID:MSVC>,$<CONFIG:Debug>>:/Od>
)

# Enable Link Time Optimization (LTCG) for Release, and change output suffix to .asi
set_target_properties(EaglePatchAC1 PROPERTIES
    INTERPROCEDURAL_OPTIMIZATION_RELEASE ON
    SUFFIX ".asi"
)

target_link_options(EaglePatchAC1 PRIVATE
    $<$<AND:$<CXX_COMPILER_ID:MSVC>,$<CONFIG:Release>>:/OPT:NOICF>
    $<$<AND:$<CXX_COMPILER_ID:MSVC>,$<CONFIG:Debug>>:/INCREMENTAL:NO>
)

# ------------------------------------------------------------------------------
# Target: EaglePatchAC2
# ------------------------------------------------------------------------------
add_library(EaglePatchAC2 SHARED
    ${SHARED_SOURCES}
    EaglePatch/src/ac2.cpp
)

target_include_directories(EaglePatchAC2 PRIVATE ${SHARED_INCLUDE_DIRS})

target_compile_definitions(EaglePatchAC2 PRIVATE
    WIN32_LEAN_AND_MEAN
    _CRT_SECURE_NO_WARNINGS
    _CRT_NONSTDC_NO_DEPRECATE
    _USE_32BIT_TIME_T
    NOMINMAX
    _MBCS
    DLL_NAME="EaglePatchAC2"
)

# MSVC-specific link requirements and settings
target_link_libraries(EaglePatchAC2 PRIVATE
    $<$<CXX_COMPILER_ID:MSVC>:legacy_stdio_definitions>
)

target_link_options(EaglePatchAC2 PRIVATE
    $<$<CXX_COMPILER_ID:MSVC>:/SAFESEH:NO>
    $<$<CXX_COMPILER_ID:MSVC>:/IGNORE:4222>
)

target_compile_options(EaglePatchAC2 PRIVATE
    $<$<AND:$<CXX_COMPILER_ID:MSVC>,$<CONFIG:Release>>:/O2>
    $<$<AND:$<CXX_COMPILER_ID:MSVC>,$<CONFIG:Debug>>:/Od>
)

# Enable Link Time Optimization (LTCG) for Release, and change output suffix to .asi
set_target_properties(EaglePatchAC2 PROPERTIES
    INTERPROCEDURAL_OPTIMIZATION_RELEASE ON
    SUFFIX ".asi"
)

target_link_options(EaglePatchAC2 PRIVATE
    $<$<AND:$<CXX_COMPILER_ID:MSVC>,$<CONFIG:Release>>:/OPT:NOICF>
    $<$<AND:$<CXX_COMPILER_ID:MSVC>,$<CONFIG:Debug>>:/INCREMENTAL:NO>
)
