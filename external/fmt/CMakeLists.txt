include(FetchContent)

FetchContent_Declare(
    fmt 
    URL  "https://github.com/fmtlib/fmt/releases/download/7.0.3/fmt-7.0.3.zip"
    URL_HASH SHA512=377efc454d902d925c2f889107ceb2dc7ed1c813f0035f91448f388558a732fd3df101161c679c23a950d3687cc5bf69eedee2bd90f41edd0b220e466759d62b
    DOWNLOAD_DIR ${CMAKE_SOURCE_DIR}/external/downloads/fmt 
)

FetchContent_MakeAvailable(fmt)

set_target_properties(fmt PROPERTIES
    FOLDER "external" ##Visual Studio Folder Filter
)