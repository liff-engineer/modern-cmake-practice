include(FetchContent)

FetchContent_Declare(
   spdlog
   URL  https://github.com/gabime/spdlog/archive/v1.7.0.tar.gz
   URL_HASH SHA512=e15d461ac7a6d3d3186fe4283e4fbaf56b2ce3011babf892e3b2d3dbdd7e999a861f1f6f67a9d88a5cf488a440add087ea78e96131f49b52ed6c7815a972799a
   DOWNLOAD_DIR ${CMAKE_SOURCE_DIR}/external/downloads/spdlog
)

FetchContent_MakeAvailable(spdlog)
set_target_properties(spdlog PROPERTIES
    FOLDER  "external"  
)