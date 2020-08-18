cmake_minimum_required(VERSION 3.15)

set(PROJECT_NAME  {{prj.name}})
{% if prj.withMasterCheck %}
##判断工程是否以subproject(add_subdirectory)的方式使用,还是作为主工程使用
set(${PROJECT_NAME}_MASTER_PROJECT OFF)

if(CMAKE_CURRENT_SOURCE_DIR STREQUAL CMAKE_SOURCE_DIR)
    set(${PROJECT_NAME}_MASTER_PROJECT ON)
    message(STATUS "Master Project,CMake:${CMAKE_VERSION}")
endif()
{% endif %}

{% if prj.withMasterCheck and prj.withNinjaSupport %}
##配置默认构建类型(ninja需要)
if(${PROJECT_NAME}_MASTER_PROJECT AND NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE "RelWithDebInfo" CACHE STRING "默认构建类型")
endif()
{% elif prj.withNinjaSupport  %}
##配置默认构建类型(ninja需要)
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE "RelWithDebInfo" CACHE STRING "默认构建类型")
endif()
{% endif %}

{% if prj.withPCHSupport %}
##构建优化选项(开启预编译头等)
option(${PROJECT_NAME}_BUILD_FASTER "使能可选构建优化,默认关闭" OFF)
set(${PROJECT_NAME}_PCH ${${PROJECT_NAME}_BUILD_FASTER})
if(${CMAKE_VERSION} VERSION_LESS "3.16.0" AND ${PROJECT_NAME}_PCH)
    message(WARNING "Unsupport Precompiled headers CMake version(${CMAKE_VERSION}),please upgrade to 3.16+")    
    set(${PROJECT_NAME}_PCH OFF)
endif()
message(STATUS "Precompiled headers enable?:${${PROJECT_NAME}_PCH}") 
{% endif %}

{% if prj.withInstall or prj.withExamples or prj.withExtras  %}
##构建控制选项
{% if prj.withInstall and prj.withMasterCheck %}
option(${PROJECT_NAME}_INSTALL  "生成install支持,构建SDK及install使用" ${${PROJECT_NAME}_MASTER_PROJECT})
{% elif prj.withInstall %}
option(${PROJECT_NAME}_INSTALL  "生成install支持,构建SDK及install使用" OFF)
{% endif %}
{% if prj.withExamples %}
option(${PROJECT_NAME}_EXAMPLES "生成示例" OFF)
{% endif %}
{% if prj.withExtras %}
option(${PROJECT_NAME}_EXTRAS   "生成python扩展" OFF)
{% endif %}
{% endif %}

{% if prj.withVersion %}
set(PROJECT_VERSION "1.0.0.0" CACHE STRING "默认工程版本号")

project(${PROJECT_NAME}
    VERSION ${PROJECT_VERSION}
)
{% else %}
project(${PROJECT_NAME})
{% endif %}

##配置本地cmake脚本路径
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)
include(deploy_dependencies) ##依赖动态库自动部署脚本

##开启并行编译
if(MSVC)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /MP")
endif()

##使能C++11
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS)

##控制Visual Studio生成使用“文件夹组织结构”
set_property(GLOBAL PROPERTY USE_FOLDERS ON)

{% if prj.withInstall %}
##非安装模式下结果输出到统一位置
if(NOT ${PROJECT_NAME}_INSTALL)
    if(NOT DEFINED CMAKE_RUNTIME_OUTPUT_DIRECTORY)
        set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/$<CONFIG>")
    endif()   
    ##注意生成的python模块属于module,因而要调整该位置
    if(${PROJECT_NAME}_EXTRAS AND NOT DEFINED CMAKE_LIBRARY_OUTPUT_DIRECTORY)
        set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/$<CONFIG>")        
    endif()
endif()
{% else %}
##结果输出到统一位置
if(NOT DEFINED CMAKE_RUNTIME_OUTPUT_DIRECTORY)
    set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/$<CONFIG>")
endif()
{% if prj.withExtras %}
##注意生成的python模块属于module,因而要调整该位置
if(${PROJECT_NAME}_EXTRAS AND NOT DEFINED CMAKE_LIBRARY_OUTPUT_DIRECTORY)
    set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/$<CONFIG>")        
endif()
{% endif %}
{% endif %}

##添加第三方库
#add_subdirectory(external)

##设置Visual Studio启动项
#set_property(DIRECTORY PROPERTY VS_STARTUP_PROJECT XXX)

{% if prj.withInstall %}
if(${PROJECT_NAME}_INSTALL)
    include(CMakePackageConfigHelpers)

    ##生成包配置文件
    configure_package_config_file(
        cmake/package_config.cmake.in
        ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}_config.cmake
        INSTALL_DESTINATION lib/cmake/${PROJECT_NAME}
    )

    ##生成包版本文件
    write_basic_package_version_file(
        ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}_config_version.cmake
        VERSION ${CMAKE_PROJECT_VERSION}
        COMPATIBILITY SameMajorVersion
    )

    ##安装find_package支持文件
    install(FILES
        ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}_config.cmake
        ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}_config_version.cmake
        DESTINATION lib/cmake/${PROJECT_NAME}
    )

    ##安装导出目标
    install(EXPORT ${PROJECT_NAME}_targets
        NAMESPACE   ${PROJECT_NAME}::
        FILE        ${PROJECT_NAME}_targets.cmake
        DESTINATION lib/cmake/${PROJECT_NAME}
    )
endif()
{% endif %}