include(FetchContent)

FetchContent_Declare(
    pybind11
    URL   https://github.com/pybind/pybind11/archive/v2.5.0.tar.gz
    URL_HASH SHA512=7f3a9c71916749436898d1844ef6b112baf0817a386308b5df8dec2a912ef4b6a932b94965e98f227c49fa77312f131972a6039f23b84a3daf6442a8ab0be7c2
    DOWNLOAD_DIR  ${CMAKE_SOURCE_DIR}/external/downloads/pybind11
)

FetchContent_MakeAvailable(pybind11)