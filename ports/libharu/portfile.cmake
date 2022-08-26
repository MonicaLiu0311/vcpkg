vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO libharu/libharu
    REF fdd021c79afaea8b2ae1a1141978ef7265869bed #2.4.0
    SHA512 6d462bb004e5b7cb181729811ca9810202f071cb6e57117c37fd96f38471e52113532eced367261581aa99a5083e3bedca5c5673f5d7374fea0d6035d4926a41
    HEAD_REF master
    PATCHES
        fix-include-path.patch
        export-targets.patch
)

string(COMPARE EQUAL "${VCPKG_LIBRARY_LINKAGE}" "static" VCPKG_BUILD_STATIC_LIBS)
string(COMPARE EQUAL "${VCPKG_LIBRARY_LINKAGE}" "dynamic" VCPKG_BUILD_SHARED_LIBS)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DLIBHPDF_STATIC=${VCPKG_BUILD_STATIC_LIBS}
        -DLIBHPDF_SHARED=${VCPKG_BUILD_SHARED_LIBS}
)

vcpkg_cmake_install()

vcpkg_cmake_config_fixup(PACKAGE_NAME unofficial-libharu)

file(REMOVE_RECURSE
    "${CURRENT_PACKAGES_DIR}/debug/include"
    "${CURRENT_PACKAGES_DIR}/debug/README.md"
    "${CURRENT_PACKAGES_DIR}/debug/CHANGES"
    "${CURRENT_PACKAGES_DIR}/debug/INSTALL"
    "${CURRENT_PACKAGES_DIR}/README.md"
    "${CURRENT_PACKAGES_DIR}/CHANGES"
    "${CURRENT_PACKAGES_DIR}/INSTALL"
)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
file(READ "${CURRENT_PACKAGES_DIR}/include/hpdf.h" _contents)
if(VCPKG_LIBRARY_LINKAGE STREQUAL "dynamic")
    string(REPLACE "#ifdef HPDF_DLL\n" "#if 1\n" _contents "${_contents}")
else()
    string(REPLACE "#ifdef HPDF_DLL\n" "#if 0\n" _contents "${_contents}")
endif()
file(WRITE "${CURRENT_PACKAGES_DIR}/include/hpdf.h" "${_contents}")

file(READ "${CURRENT_PACKAGES_DIR}/include/hpdf_types.h" _contents)
if(VCPKG_LIBRARY_LINKAGE STREQUAL "dynamic")
    string(REPLACE "#ifdef HPDF_DLL\n" "#if 1\n" _contents "${_contents}")
else()
    string(REPLACE "#ifdef HPDF_DLL\n" "#if 0\n" _contents "${_contents}")
endif()
file(WRITE "${CURRENT_PACKAGES_DIR}/include/hpdf_types.h" "${_contents}")

vcpkg_copy_pdbs()
file(INSTALL "${SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
