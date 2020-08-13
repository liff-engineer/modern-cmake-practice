cmake_minimum_required(VERSION 3.15)

project(cmakeuser
    LANGUAGES CXX 
)

#配置cmake脚本模块路径
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)
include(deploy_dependencies)

#生成Visual Studio工程时使用文件夹组织结构
set_property(GLOBAL PROPERTY USE_FOLDERS ON)

#MSVC情况下开启并行构建
if(MSVC)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /MP")
endif()

#设置C++标准为C++17
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)


#设置动态链接库输出目录
if(NOT DEFINED CMAKE_RUNTIME_OUTPUT_DIRECTORY)
    set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>)
endif()

#第三方库
add_subdirectory(external)

#示例
add_subdirectory(examples)
