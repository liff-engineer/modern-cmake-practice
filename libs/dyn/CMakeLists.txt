cmake_minimum_required(VERSION 3.15)

##设置目标名称
set(TARGET_NAME dyn)

##设置源代码路径
set(${TARGET_NAME}_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR})

##提取所有的源文件(include和src分开)
file(GLOB_RECURSE ${TARGET_NAME}_HEADER_FILES
    LIST_DIRECTORIES False  CONFIGURE_DEPENDS
    "${${TARGET_NAME}_SOURCE_DIR}/include/*.h*"
)

file(GLOB_RECURSE ${TARGET_NAME}_SRC_FILES
    LIST_DIRECTORIES False  CONFIGURE_DEPENDS
    "${${TARGET_NAME}_SOURCE_DIR}/src/*.h*"
    "${${TARGET_NAME}_SOURCE_DIR}/src/*.c*"
    "${${TARGET_NAME}_SOURCE_DIR}/src/*.rc"
    "${${TARGET_NAME}_SOURCE_DIR}/src/*.qrc"
)

##为Visual Studio设置源代码文件夹 
source_group(
    TREE "${${TARGET_NAME}_SOURCE_DIR}/include"
    PREFIX "Header Files"
    FILES ${${TARGET_NAME}_HEADER_FILES}
)

source_group(
    TREE "${${TARGET_NAME}_SOURCE_DIR}/src"
    PREFIX "Source Files"
    FILES ${${TARGET_NAME}_SRC_FILES}
)

##添加目标及别名
add_library(${TARGET_NAME} SHARED)
add_library(${PROJECT_NAME}::${TARGET_NAME} ALIAS ${TARGET_NAME})

##查找Qt翻译家
find_package(Qt5LinguistTools)
##创建ts文件并提供qm生成路径
qt5_create_translation(${TARGET_NAME}_QM_FILE 
    ${${TARGET_NAME}_HEADER_FILES}
    ${${TARGET_NAME}_SRC_FILES}
    ${CMAKE_CURRENT_BINARY_DIR}/${TARGET_NAME}_zh.ts 
)

##为目标指定源文件 
target_sources(${TARGET_NAME}
    PRIVATE  ${${TARGET_NAME}_HEADER_FILES}
    PRIVATE  ${${TARGET_NAME}_SRC_FILES}
    PRIVATE  ${${TARGET_NAME}_QM_FILE}
)

##设置目标属性
set_target_properties(${TARGET_NAME} PROPERTIES 
    WINDOWS_EXPORT_ALL_SYMBOLS True ##自动导出符号 
    AUTOMOC ON
    FOLDER "libs"
)

##设置预处理器定义
if(MSVC)
    target_compile_definitions(${TARGET_NAME}
        PRIVATE UNICODE NOMINMAX 
    )
endif()

##配置构建/使用时的头文件路径 
target_include_directories(${TARGET_NAME}
    PUBLIC 
        "$<BUILD_INTERFACE:${${TARGET_NAME}_SOURCE_DIR}/include>"
        "$<BUILD_INTERFACE:${${TARGET_NAME}_SOURCE_DIR}/include/${TARGET_NAME}>"
        "$<INSTALL_INTERFACE:include>"
    PRIVATE  
        "$<BUILD_INTERFACE:${${TARGET_NAME}_SOURCE_DIR}/src>"
)

##根据选项使能预编译头
if(${PROJECT_NAME}_PCH AND ON)
    target_precompile_headers(${TARGET_NAME}
        PRIVATE 
            <functional>
            <vector>
            <string>
            <map>
            <set>
        PRIVATE 
            [["dyn/dyn.hpp"]]
    )
endif()

##配置库依赖
find_package(Qt5 COMPONENTS Core REQUIRED)
target_link_libraries(${TARGET_NAME}
    PRIVATE Qt5::Core 
)

##依赖自动部署
if(${PROJECT_NAME}_DEPLOY AND ON)
    ##部署资源文件 
    add_custom_command(TARGET ${TARGET_NAME} POST_BUILD 
        ##复制数据
        COMMAND ${CMAKE_COMMAND} -E copy_directory ${${TARGET_NAME}_SOURCE_DIR}/data/  $<TARGET_FILE_DIR:${TARGET_NAME}>
        ##创建翻译文件目录
        COMMAND ${CMAKE_COMMAND} -E make_directory $<TARGET_FILE_DIR:${TARGET_NAME}>/translations/
        ##部署翻译文件 
        COMMAND ${CMAKE_COMMAND} -E copy_if_different ${${TARGET_NAME}_QM_FILE} $<TARGET_FILE_DIR:${TARGET_NAME}>/translations/
    )
endif()

##构建示例
if(${PROJECT_NAME}_EXAMPLES AND ON)
    add_subdirectory(examples)
endif()

##构建python模块
if(${PROJECT_NAME}_EXTRAS AND ON)
    add_subdirectory(py)

    ##部署运行时
    deploy_dependencies(TARGET ${TARGET_NAME}
        SEARCH_PATHS ${QT5_BINARIES_SEARCH_PATH}
    )
endif()

##安装/构建SDK
if(${PROJECT_NAME}_INSTALL)
    ##安装头文件
    install(DIRECTORY 
        ${${TARGET_NAME}_SOURCE_DIR}/include  
        DESTINATION include 
        FILES_MATCHING PATTERN "*.h*"
    )

    ##安装库/应用程序文件
    install(TARGETS ${TARGET_NAME}
        EXPORT ${PROJECT_NAME}_targets  
        RUNTIME DESTINATION bin/$<CONFIG>
        LIBRARY DESTINATION lib/$<CONFIG>
        ARCHIVE DESTINATION lib/$<CONFIG>
    )

    ##安装数据文件 
    install(DIRECTORY 
        ${${TARGET_NAME}_SOURCE_DIR}/data 
        DESTINATION data
    )
    ##安装翻译文件 
    install(FILES 
        ${${TARGET_NAME}_QM_FILE}
        DESTINATION data/translations 
    )

    ##安装pdb(可选)
    get_target_property(${TARGET_NAME}_target_type ${TARGET_NAME} TYPE)
    if(NOT ${TARGET_NAME}_target_type STREQUAL "STATIC_LIBRARY")
        install(FILES $<TARGET_PDB_FILE:${TARGET_NAME}>
            DESTINATION bin/$<CONFIG> OPTIONAL
        )
    endif()
endif()
