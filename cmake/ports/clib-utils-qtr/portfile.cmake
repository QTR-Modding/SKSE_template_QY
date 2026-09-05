# header-only library
vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO QTR-Modding/CLibUtilsQTR
    REF 8772ebde59ddd0905e5d14affa7334d19a0a8cf1
    SHA512 019abbb1876fd1c56b21d896f246edec8cfad7366b2cce4e7295f06fe65c9c77d12c7df4e8a55145d25e08113da23bc670c2abf668813209e52c86f5ca3189bd
    HEAD_REF main
)

# Install codes
set(CLibUtilsQTR_SOURCE	${SOURCE_PATH}/include/CLibUtilsQTR)
file(INSTALL ${CLibUtilsQTR_SOURCE} DESTINATION ${CURRENT_PACKAGES_DIR}/include)
vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
