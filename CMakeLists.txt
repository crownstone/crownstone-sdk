cmake_minimum_required(VERSION 3.10)

set(board_target default CACHE STRING "Board target to compile for")

set(WORKSPACE_PATH ${CMAKE_CURRENT_LIST_DIR}/..)

set(DEFAULT_CONF_CMAKE_PATH ${WORKSPACE_PATH}/source/conf/cmake)
set(VARIANT_CONFIGURATION_PATH ${WORKSPACE_PATH}/config/${board_target})
set(VARIANT_CONFIGURATION_FILE ${VARIANT_CONFIGURATION_PATH}/CMakeBuild.config)

#list(APPEND ADDITIONAL_CLEAN_FILES ${WORKSPACE_PATH}/build/${board_target}/CMakeCache.txt)
#list(APPEND ADDITIONAL_CLEAN_DIRECTORY ${WORKSPACE_PATH}/build/${board_target})

set_directory_properties(PROPERTIES ADDITIONAL_MAKE_CLEAN_FILES ${WORKSPACE_PATH}/build/${board_target})
set_directory_properties(PROPERTIES ADDITIONAL_MAKE_CLEAN_FILES ${WORKSPACE_PATH}/stamp/${board_target})
set_directory_properties(PROPERTIES ADDITIONAL_MAKE_CLEAN_FILES ${WORKSPACE_PATH}/tmp/${board_target})

include(ExternalProject)

find_package(Git REQUIRED)

# This only downloads the bluenet repository

ExternalProject_Add(bluenet
	GIT_REPOSITORY https://github.com/crownstone/bluenet
	GIT_PROGRESS 1
	GIT_TAG cmake
	SOURCE_DIR ${WORKSPACE_PATH}/source
	CONFIGURE_COMMAND cmake -E echo "Skipping configure step."
	BUILD_COMMAND cmake -E echo "Skipping build step."
	INSTALL_COMMAND cmake -E echo "Skipping install step."
)

# This copies the CMakeLists.txt from the bootstrap folder and uses it to compile everything

ExternalProject_Add(bootstrap
	SOURCE_DIR ${WORKSPACE_PATH}
	DOWNLOAD_COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/bootstrap/CMakeLists.txt ${WORKSPACE_PATH}
	INSTALL_COMMAND cmake -E echo "Skipping install step."
)

set(NORDIC_DOWNLOAD_URL https://www.nordicsemi.com/-/media/Software-and-other-downloads/SDKs)

# If files are updated... Also update the md5 hash, e.g. through `md5sum downloads/*`
set(NORDIC_NRF5_SDK_DOWNLOAD_URL ${NORDIC_DOWNLOAD_URL}/nRF5/Binaries/nRF5SDK153059ac345.zip)
set(NORDIC_NRF5_SDK_MD5 46a8c9cd4b5d7ee4c5142e8fae3444c4)
set(NORDIC_MESH_SDK_DOWNLOAD_URL ${NORDIC_DOWNLOAD_URL}/nRF5-SDK-for-Mesh/nrf5SDKforMeshv320src.zip)
set(NORDIC_MESH_SDK_MD5 29e813a85e209fd07837c4fd3c616178)

ExternalProject_Add(nordic_sdk
	DOWNLOAD_DIR ${WORKSPACE_PATH}/downloads
	SOURCE_DIR ${WORKSPACE_PATH}/tools/nrf5_sdk
	URL ${NORDIC_NRF5_SDK_DOWNLOAD_URL}
	URL_MD5 ${NORDIC_NRF5_SDK_MD5}
	CONFIGURE_COMMAND ${CMAKE_COMMAND} -E echo "Skipping configure step."
	BUILD_COMMAND ${CMAKE_COMMAND} -E echo "Skipping build step."
	INSTALL_COMMAND ${CMAKE_COMMAND} -E echo "Skipping install step."
)

ExternalProject_Add(nordic_mesh_sdk
	DOWNLOAD_DIR ${WORKSPACE_PATH}/downloads
	SOURCE_DIR ${WORKSPACE_PATH}/tools/mesh_sdk
	URL ${NORDIC_MESH_SDK_DOWNLOAD_URL}
	URL_MD5 ${NORDIC_MESH_SDK_MD5}
	CONFIGURE_COMMAND ${CMAKE_COMMAND} -E echo "Skipping configure step."
	BUILD_COMMAND ${CMAKE_COMMAND} -E echo "Skipping build step."
	INSTALL_COMMAND ${CMAKE_COMMAND} -E echo "Skipping install step."
)

set(JLINK_DOWNLOAD_URL https://www.segger.com/downloads/jlink)
set(JLINK_DEB_FILE JLink_Linux_V650_x86_64.deb)
set(JLINK_LINUX_DOWNLOAD_URL ${JLINK_DOWNLOAD_URL}/${JLINK_DEB_FILE})
set(JLINK_MD5 bdf926715a45dfd930d4516e6a5027c1)

ExternalProject_Add(jlink
	DOWNLOAD_COMMAND wget  --post-data "accept_license_agreement=accepted" ${JLINK_LINUX_DOWNLOAD_URL} -O ${WORKSPACE_PATH}/downloads/${JLINK_DEB_FILE} 
	DOWNLOAD_DIR ${WORKSPACE_PATH}/downloads
	URL ${JLINK_LINUX_DOWNLOAD_URL}
	URL_MD5 ${JLINK_MD5}
	DOWNLOAD_NO_EXTRACT 1
	CONFIGURE_COMMAND ${CMAKE_COMMAND} -E echo "Skipping configure step."
	BUILD_COMMAND ${CMAKE_COMMAND} -E echo "Skipping build step."
	INSTALL_COMMAND sudo dpkg -i ${WORKSPACE_PATH}/downloads/${JLINK_DEB_FILE} 
)

set(GCC_ARM_NONE_EABI_DOWNLOAD_URL https://developer.arm.com/-/media/Files/downloads/gnu-rm/8-2019q3/RC1.1/gcc-arm-none-eabi-8-2019-q3-update-linux.tar.bz2?revision=c34d758a-be0c-476e-a2de-af8c6e16a8a2?product=GNU%20Arm%20Embedded%20Toolchain,64-bit,,Linux,8-2019-q3-update)

ExternalProject_Add(arm-gnue
	DOWNLOAD_DIR ${WORKSPACE_PATH}/downloads
	URL ${GCC_ARM_NONE_EABI_DOWNLOAD_URL}
	SOURCE_DIR ${WORKSPACE_PATH}/tools/gcc_arm_none_eabi
	CONFIGURE_COMMAND ${CMAKE_COMMAND} -E echo "Skipping configure step."
	BUILD_COMMAND ${CMAKE_COMMAND} -E echo "Skipping build step."
	INSTALL_COMMAND ${CMAKE_COMMAND} -E echo "Skipping install step."
)

