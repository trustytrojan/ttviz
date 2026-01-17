include(FetchContent)

# libaudioviz
# Option to allow using a local checkout of libaudioviz instead of fetching
# If empty, deps will be fetched from the git URL below. If set, the path
# must point at a directory containing libaudioviz's CMakeLists.txt.
set(TTVIZ_LOCAL_LIBAUDIOVIZ_PATH "" CACHE STRING "Path to local libaudioviz directory; if set, uses add_subdirectory")
set(TTVIZ_LIBAUDIOVIZ_GIT_TAG "main" CACHE STRING "Git tag/branch to checkout for libaudioviz when fetching")

set(AUDIOVIZ_BUILD_EXAMPLES OFF CACHE BOOL "" FORCE)
set(AUDIOVIZ_USE_IMGUI OFF CACHE BOOL "" FORCE)

# Make libaudioviz available either from a local path or by fetching the
# repository (default: ${TTVIZ_LIBAUDIOVIZ_GIT_URL} @ ${TTVIZ_LIBAUDIOVIZ_GIT_TAG}).
if(TTVIZ_LOCAL_LIBAUDIOVIZ_PATH)
	# Resolve to an absolute path so we can correctly determine whether the
	# source is outside the current tree and provide a dedicated binary-dir.
	get_filename_component(_audioviz_src "${TTVIZ_LOCAL_LIBAUDIOVIZ_PATH}" ABSOLUTE)
	if(EXISTS "${_audioviz_src}/CMakeLists.txt")
		set(_audioviz_bin "${_audioviz_src}/build")
		message(STATUS "Using local libaudioviz at ${_audioviz_src}; binary dir=${_audioviz_bin}")
		add_subdirectory(${_audioviz_src} ${_audioviz_bin} EXCLUDE_FROM_ALL)
	else()
		message(FATAL_ERROR "TTVIZ_LOCAL_LIBAUDIOVIZ_PATH is set but ${_audioviz_src}/CMakeLists.txt was not found")
	endif()
else()
	message(STATUS "Fetching libaudioviz from GitHub (tag: ${TTVIZ_LIBAUDIOVIZ_GIT_TAG})")
	FetchContent_Declare(audioviz URL "https://github.com/trustytrojan/audioviz/archive/${TTVIZ_LIBAUDIOVIZ_GIT_TAG}.tar.gz")
	FetchContent_MakeAvailable(audioviz)
endif()
target_link_libraries(ttviz PUBLIC audioviz)

# argparse
if(NOT EXISTS ${CMAKE_BINARY_DIR}/argparse.hpp)
	file(DOWNLOAD https://github.com/p-ranav/argparse/raw/master/include/argparse/argparse.hpp ${CMAKE_BINARY_DIR}/argparse.hpp)
endif()
target_include_directories(ttviz PUBLIC ${CMAKE_BINARY_DIR})
