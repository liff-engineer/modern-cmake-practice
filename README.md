[TOC]

## 现代CMake实践



### 环境要求

- CMake 3.15
- Visual Studio 2017及以上



### 目录结构

| 目录     | 说明                                                       |
| -------- | ---------------------------------------------------------- |
| external | 第三方库,采用cmake的FetchContent模块处理第三方库下载及配置 |
| examples | 示例程序                                                   |

### 第三方库

#### 提供CMake配置的二进制包(以Qt为例)

Qt虽然目前不是以CMake构建的,但是提供了CMake使用支持,在`lib\cmake`目录下,由此可以通过`find_package`使用.这里需要处理以下两种情况:

1. 使用安装包安装Qt并配置好环境变量`QTDIR`
2. Qt二进制包打包成`zip`存储于服务器某位置

这里采用的方式是首先判断环境变量中是否有`QTDIR`,如果有则直接配置,如果没有则使用`FetchContent`模块下载解压二进制包,配置好`QTDIR`:

```cmake
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
```

通过在`CMakeLists.txt`中通使用`add_subdirectory`加载`external\qt`下的`CMakeLists.txt`即可使用`Qt`,例如`examples`中的`QHelloWorld`示例:

```cmake
add_executable(QHelloWorld)
target_sources(QHelloWorld
    PRIVATE QHelloWorld.cpp
)

##找到Qt库并链接
find_package(Qt5 COMPONENTS Widgets REQUIRED)
target_link_libraries(QHelloWorld
    PRIVATE Qt5::Widgets
)
```



