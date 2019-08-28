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

