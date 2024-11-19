cmake_minimum_required(VERSION 3.15)

# Environment and build settings
################################

project(lib.cpp.base.exception-framework LANGUAGES CXX)

add_definitions(-DUNICODE)
add_definitions(-D_UNICODE)

# Build script
##############
include_directories(
	${CMAKE_SOURCE_DIR}/include
)

file(GLOB SOURCE *.cpp *.hpp exf1.def)

add_library(libEXF SHARED ${SOURCE})

target_compile_features(libEXF PUBLIC cxx_std_20)

target_link_libraries(libEXF
	${CMAKE_BINARY_DIR}/pbvm.lib
	${CMAKE_BINARY_DIR}/pbshr.lib
	Shlwapi
)

set_target_properties(libEXF PROPERTIES
	LINK_FLAGS "/MACHINE:${BITNESS}"
	OUTPUT_NAME "exf1"
)

install(TARGETS libEXF
	RUNTIME DESTINATION "."
)