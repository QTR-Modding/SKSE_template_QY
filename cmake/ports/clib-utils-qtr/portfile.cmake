# header-only library
vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO QTR-Modding/CLibUtilsQTR
    REF 475b3f9f361938bb794d1a41ba3b6a853f31558d
    SHA512 43d853a496e832d2f790919a127bd1cff3097a8e29eca7f43826db038d06de06941f3bf64e12b0850b7a901a702ec24c071d8cac41d694fe652887e8eb435a2b
    HEAD_REF main
)

# Install codes
set(CLibUtilsQTR_SOURCE	${SOURCE_PATH}/include/CLibUtilsQTR)
file(INSTALL ${CLibUtilsQTR_SOURCE} DESTINATION ${CURRENT_PACKAGES_DIR}/include)
vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")