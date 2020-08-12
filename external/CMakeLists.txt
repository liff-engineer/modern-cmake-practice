include(CMakePrintHelpers)

#设置FetchContent模块根目录
set(FETCHCONTENT_BASE_DIR ${CMAKE_SOURCE_DIR}/external/deps)

cmake_print_variables(CMAKE_GENERATOR)

add_subdirectory(qt)
