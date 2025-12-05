# header-only library
vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO QTR-Modding/CLibUtilsQTR
    REF 17be2ca74f940bc1f6d1cc37040acc60f049cfdf
    SHA512 bf5b4e96f59d17dfc4f28e6a5fecf29ba469423fc3e0eee9d18789a27aa79b66548cf4ca8b4bb35fb8e4ddc116b0fa5ee90eaaf0ba30ec37e2d589de933873c5
    HEAD_REF main
)

# Install codes
set(CLibUtilsQTR_SOURCE	${SOURCE_PATH}/include/CLibUtilsQTR)
file(INSTALL ${CLibUtilsQTR_SOURCE} DESTINATION ${CURRENT_PACKAGES_DIR}/include)
vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")