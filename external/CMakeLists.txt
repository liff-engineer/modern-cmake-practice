include(CMakePrintHelpers)
include(FetchContent)

#设置FetchContent模块根目录
set(FETCHCONTENT_BASE_DIR ${CMAKE_SOURCE_DIR}/external/deps)

cmake_print_variables(CMAKE_GENERATOR)

add_subdirectory(catch2)
add_subdirectory(fmt)
add_subdirectory(pybind11)
add_subdirectory(qt)
add_subdirectory(spdlog)

