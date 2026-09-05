# header-only library
vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO QTR-Modding/CLibUtilsQTR
    REF f3589d610b1ce75c464a8099d8442206e61cdb54
    SHA512 f7443db498be9225bdc9477e5aeea86cf2da1d8c64ee381e6050ee1d5b18650c49d3ef24d94c721e6c7d03c23c8d5a47e61ab89c992ba6a3385b9cc364dfbe1e
    HEAD_REF main
)

# Install codes
set(CLibUtilsQTR_SOURCE	${SOURCE_PATH}/include/CLibUtilsQTR)
file(INSTALL ${CLibUtilsQTR_SOURCE} DESTINATION ${CURRENT_PACKAGES_DIR}/include)
vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
