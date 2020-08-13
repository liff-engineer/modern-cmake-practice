include(FetchContent)

FetchContent_Declare(
    catch2
    URL   https://github.com/catchorg/Catch2/archive/v2.13.0.tar.gz
    URL_HASH SHA512=07786a9426d9696cd8f9cad14a3d5d00ad507ba6a63699f0cce567b4749d60a25eaf2e469902d8f867f282e2f635021ad6ea38648d69a6316b296b913f7c172d
    DOWNLOAD_DIR ${CMAKE_SOURCE_DIR}/external/downloads/catch2
)

FetchContent_MakeAvailable(catch2)