include(FetchContent)
include(CMakePrintHelpers)

#如果在环境变量中找不到QTDIR则下载
if(NOT DEFINED ENV{QTDIR})
    message(STATUS "PATH = $ENV{PATH}")    
    FetchContent_Declare(
        qt 
        URL "ftp://yourhost/qt5.12.9.zip"
        URL_HASH SHA512=2a5655420c7b5a9300a2d973029abada7654ccc9de77e31adfd2670d2818e006bf85ccb619231aa392061162869c70e29df6c0a32fc2815944eb10ce5fde0664
        DOWNLOAD_NAME "qt5.12.9.zip"
        DOWNLOAD_DIR ${CMAKE_SOURCE_DIR}/external/downloads/qt  
    )
    FetchContent_GetProperties(qt)
    if(NOT qt_POPULATED)
        #下载并解压Qt二进制包
        FetchContent_Populate(qt)

        #确定当前使用的QT路径
        if(CMAKE_SIZEOF_VOID_P EQUAL 8)
            set(__QTDIR ${qt_SOURCE_DIR}/msvc2017_64)
        else()
            set(__QTDIR ${qt_SOURCE_DIR}/msvc2017)
        endif()
    endif()
else()
    message(STATUS "QTDIR = $ENV{QTDIR}")
    set(__QTDIR  $ENV{QTDIR})
endif()

#设置QTDIR为全局变量
set(QTDIR ${__QTDIR} CACHE INTERNAL "Qt Install Directory")

#追加到CMAKE_PREFIX_PATH确保find_package能够找到
list(APPEND CMAKE_PREFIX_PATH ${QTDIR}) 

include(deploy_qt_runtime.cmake)
#如果是通过这种方式添加到project中,则需要首先find_package一下,
#否则可能无法正常使用
find_package(Qt5 COMPONENTS Core REQUIRED)
find_package(Qt5LinguistTools)