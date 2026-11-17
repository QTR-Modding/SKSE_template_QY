
if(NOT DEFINED ENV{COMMONLIB_SSE_FOLDER})
  message(FATAL_ERROR "Missing COMMONLIB_SSE_FOLDER environment variable")
endif()

include(cmake/lib/copyOutputs.cmake)
include(cmake/lib/automaticGameFolderOutput.cmake)
include(cmake/lib/autoCollectSources.cmake)

add_src_folder(src)
add_include_folder(include)

list(APPEND CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake")

# It's recommended to set a minimum CMake version.
# If you use CMake features from higher versions, update this to match.
cmake_minimum_required(VERSION 3.21)
# Set your project name. This will be the name of your SKSE .dll file.
set(AUTHOR_NAME "AUTHORNAME")
set(PRODUCT_NAME "ModName")
project(${PRODUCT_NAME} VERSION 0.1.0.0 LANGUAGES CXX)
set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_INTERPROCEDURAL_OPTIMIZATION ON)

configure_file(
        ${CMAKE_CURRENT_SOURCE_DIR}/cmake/version.rc.in
        ${CMAKE_CURRENT_BINARY_DIR}/version.rc
        @ONLY)

set(RESOURCE_FILE ${CMAKE_CURRENT_BINARY_DIR}/version.rc)
set(RESOURCE_OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/version.res)

add_custom_command(
    OUTPUT ${RESOURCE_OUTPUT}
    COMMAND rc /fo ${RESOURCE_OUTPUT} ${RESOURCE_FILE}
    DEPENDS ${RESOURCE_FILE}
)

# Add a custom target to ensure the resource file is generated
add_custom_target(Resource ALL DEPENDS ${RESOURCE_OUTPUT})

set(ENABLE_SKYRIM_SE ON CACHE BOOL " " FORCE)
set(ENABLE_SKYRIM_AE ON CACHE BOOL " " FORCE)
set(ENABLE_SKYRIM_VR ON CACHE BOOL " " FORCE)
set(BUILD_TESTS OFF CACHE BOOL " " FORCE)

if(CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
  set(path_roots "${PROJECT_BINARY_DIR}" "${PROJECT_SOURCE_DIR}" "$ENV{COMMONLIB_SSE_FOLDER}")
  if(VCPKG_INSTALLED_DIR)
    list(APPEND path_roots "${VCPKG_INSTALLED_DIR}")
  endif()
  list(REMOVE_DUPLICATES path_roots)
  foreach(path_root IN LISTS path_roots)
    cmake_path(CONVERT "${path_root}" TO_CMAKE_PATH_LIST path_root)
    cmake_path(ABSOLUTE_PATH path_root NORMALIZE OUTPUT_VARIABLE absolute_root)
    cmake_path(NATIVE_PATH absolute_root native_root)
    add_compile_options("$<$<COMPILE_LANGUAGE:CXX>:/d1trimfile:${native_root}\\>")
  endforeach()
  add_compile_options("$<$<AND:$<CONFIG:Release>,$<COMPILE_LANGUAGE:CXX>>:/Z7>")
endif()

add_subdirectory("$ENV{COMMONLIB_SSE_FOLDER}" ${CMAKE_CURRENT_BINARY_DIR}/_deps/clib-build)
get_target_property(COMMONLIB_SRC_DIR CommonLibSSE SOURCE_DIR)

find_path(CLIB_UTIL_INCLUDE_DIRS "ClibUtil/utils.hpp")
find_path(CLIB_UTILS_QTR_INCLUDE_DIRS "ClibUtilsQTR/utils.hpp")
find_library(DETOURS_LIBRARY detours REQUIRED)
find_path(SKSE_MCP_INCLUDE_DIRS "SKSEMCP/utils.hpp")


file(
  GLOB_RECURSE
  sources
  ${CMAKE_CURRENT_BINARY_DIR}/version.rc
  ${sources}
)

source_group(
  TREE ${CMAKE_CURRENT_SOURCE_DIR}
  FILES ${headers} ${sources}
)

set(BUILD_TESTS OFF)
include(${COMMONLIB_SRC_DIR}/cmake/CommonLibSSE.cmake)

add_commonlibsse_plugin(
  ${PROJECT_NAME}
  AUTHOR AUTHOR_NAME
  SOURCES ${headers} ${sources}
)
if(CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
  target_link_options(${PROJECT_NAME} PRIVATE
    "/PDBALTPATH:%_PDB%"
    "$<$<CONFIG:Release>:/DEBUG:FULL;/INCREMENTAL:NO;/OPT:REF;/OPT:ICF>"
  )
  add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
    COMMAND powershell.exe -NoProfile -NonInteractive -ExecutionPolicy RemoteSigned
      -File "${CMAKE_CURRENT_SOURCE_DIR}/cmake/lib/verifyDllPaths.ps1"
      -Dll "$<TARGET_FILE:${PROJECT_NAME}>"
      -Configuration "$<CONFIG>"
    VERBATIM
  )
  set_property(TARGET ${PROJECT_NAME} APPEND PROPERTY LINK_DEPENDS
    "${CMAKE_CURRENT_SOURCE_DIR}/cmake/lib/verifyDllPaths.ps1")
endif()
target_compile_features(${PROJECT_NAME} PRIVATE cxx_std_23) # <--- use C++23 standard
target_precompile_headers(${PROJECT_NAME} PRIVATE include/PCH.h) # <--- PCH.h is required!
target_include_directories(
	${PROJECT_NAME}
	PRIVATE
	${CLIB_UTIL_INCLUDE_DIRS}
	${CLIB_UTILS_QTR_INCLUDE_DIRS}
    ${SKSE_MCP_INCLUDE_DIRS}
	${CMAKE_CURRENT_SOURCE_DIR}/include
)

target_link_libraries(${PROJECT_NAME} PRIVATE ${DETOURS_LIBRARY})

target_compile_definitions(${PROJECT_NAME} PRIVATE IS_HOST_PLUGIN)

set(wildlander_output false)
set(steam_owrt_output false)
set(steam_mods_output true)
set(lorerim_mods_output false)
set(lorerim3_mods_output true)
automaticGameFolderOutput(wildlander_output, steam_owrt_output, steam_mods_output lorerim_mods_output lorerim3_mods_output)
