cmake_minimum_required(VERSION 3.15)

add_executable(QHelloWorld)
target_sources(QHelloWorld
    PRIVATE QHelloWorld.cpp
)

find_package(Qt5 COMPONENTS Widgets REQUIRED)
target_link_libraries(QHelloWorld
    PRIVATE Qt5::Widgets
    PRIVATE spdlog::spdlog
)

#deploy_qt_runtime(TARGET QHelloWorld)
deploy_dependencies(TARGET QHelloWorld
    SEARCH_PATHS ${QT5_BINARIES_SEARCH_PATH}
)
