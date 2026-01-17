cmake_minimum_required(VERSION 3.18)
project(audioviz LANGUAGES CXX)

if(${CMAKE_VERSION} VERSION_GREATER_EQUAL 3.24)
	cmake_policy(SET CMP0135 NEW)
endif()

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

if(APPLE)
	# for homebrew setups
	link_directories(/opt/homebrew/lib)
	include_directories(/opt/homebrew/include)
endif()

if(CMAKE_BUILD_TYPE MATCHES Rel)
	add_compile_options(-march=native)
endif()

include_directories(include)

file(GLOB TTVIZ_SOURCES src/*.cpp)
add_executable(ttviz ${TTVIZ_SOURCES})

include(deps.cmake)
