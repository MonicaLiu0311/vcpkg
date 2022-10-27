vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO vinniefalco/LuaBridge
    REF ad32549288433eacfb0dc64cc3a8e4873de31553 # 2.8
    SHA512 28cd7a44413925be9c3d949fdc136d37da44e9ce9d35d2c8cf9b35dd2f960a6cf5f55a1841011e5d434512adc502d79b585a2fcc7f74268a70c984c3c71f7d77
    HEAD_REF master
)

file(
    COPY "${SOURCE_PATH}/Source/LuaBridge"
    DESTINATION "${CURRENT_PACKAGES_DIR}/include"
)

# Handle copyright
configure_file(
    "${SOURCE_PATH}/README.md"
    "${CURRENT_PACKAGES_DIR}/share/luabridge/copyright"
    COPYONLY
)
