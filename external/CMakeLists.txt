include(CMakePrintHelpers)
include(FetchContent)

#设置FetchContent模块根目录
# set(FETCHCONTENT_BASE_DIR ${CMAKE_SOURCE_DIR}/external/deps)

# set(CACHE_DIR "msvc")
# if(CMAKE_GENERATOR STREQUAL "Ninja")
#     set(CACHE_DIR "ninja")
# endif()

# ##根据platform调整根目录
# if(CMAKE_SIZEOF_VOID_P EQUAL 8)
#     set(CACHE_DIR "${CACHE_DIR}_x64")
# else()
#     set(CACHE_DIR "${CACHE_DIR}_Win32")
# endif()

# ##如果是MSVC则追加工具集版本
# if(MSVC)
#     set(CACHE_DIR "${CACHE_DIR}_${MSVC_TOOLSET_VERSION}")
# endif()
# set(FETCHCONTENT_BASE_DIR "${FETCHCONTENT_BASE_DIR}/${CACHE_DIR}")

cmake_print_variables(CMAKE_GENERATOR)

add_subdirectory(catch2)
add_subdirectory(fmt)
add_subdirectory(pybind11)
add_subdirectory(qt)
add_subdirectory(spdlog)

