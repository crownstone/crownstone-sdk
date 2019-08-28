cmake_minimum_required(VERSION 3.10)

#######################################################################################################################
# Set board target 
#######################################################################################################################

set(board_target default CACHE STRING "Board target to compile for")

set(WORKSPACE_PATH ${CMAKE_CURRENT_LIST_DIR})

set(DEFAULT_CONF_CMAKE_PATH ${WORKSPACE_PATH}/source/conf/cmake)
set(DEFAULT_MODULES_PATH ${DEFAULT_CONF_CMAKE_PATH}/modules)

#######################################################################################################################
# Load modules
#######################################################################################################################

include(ExternalProject)

include(${DEFAULT_MODULES_PATH}/load_configuration.cmake)
include(${DEFAULT_MODULES_PATH}/git_info.cmake)
include(${DEFAULT_MODULES_PATH}/compilation_info.cmake)

#######################################################################################################################
# Load configuration values from multiple files
#######################################################################################################################

#set(CMAKE_ARGS "")

set(DEFAULT_CONFIGURATION_FILE ${DEFAULT_CONF_CMAKE_PATH}/CMakeBuild.config.default)
set(VARIANT_CONFIGURATION_FILE ${WORKSPACE_PATH}/config/${board_target}/CMakeBuild.config)

load_configuration("${DEFAULT_CONFIGURATION_FILE}" CMAKE_ARGS)
load_configuration("${VARIANT_CONFIGURATION_FILE}" CMAKE_ARGS)

# For now only cross-compilation
list(APPEND CMAKE_ARGS "-DCMAKE_TOOLCHAIN_FILE:FILEPATH=${WORKSPACE_PATH}/source/arm.toolchain.cmake")
#list(APPEND CMAKE_ARGS "-DCMAKE_TOOLCHAIN_FILE:FILEPATH=${CMAKE_CONF_CMAKE_PATH}/arm.toolchain.cmake")

# Setting INSTALL_DIR is not sufficient, also CMAKE_INSTALL_PREFIX is required
list(APPEND CMAKE_ARGS "-DCMAKE_INSTALL_PREFIX:FILEPATH=${WORKSPACE_PATH}/bin/${board_target}")

if(VERBOSITY GREATER 5)
  message(STATUS "list: ${CMAKE_ARGS}")
endif()

git_info("${WORKSPACE_PATH}/source" GIT_BRANCH GIT_HASH)

if(NOT GIT_BRANCH STREQUAL "")
  list(APPEND CMAKE_ARGS "-DGIT_BRANCH:STRING=${GIT_BRANCH}")
endif()

if(NOT GIT_HASH STREQUAL "")
  list(APPEND CMAKE_ARGS "-DGIT_HASH:STRING=${GIT_HASH}")
endif()

compilation_info(COMPILATION_DAY)

if(VERBOSITY GREATER 4)
  message(STATUS "git branch: ${GIT_BRANCH}")
  message(STATUS "git hash: ${GIT_HASH}")
  message(STATUS "compilation day: ${COMPILATION_DAY}")
endif()

if(NOT COMPILATION_DAY STREQUAL "")
  list(APPEND CMAKE_ARGS "-DCOMPILATION_DAY:STRING=${COMPILATION_DAY}")
endif()

set_directory_properties(PROPERTIES ADDITIONAL_MAKE_CLEAN_FILES ${WORKSPACE_PATH}/stamp/${board_target})
set_directory_properties(PROPERTIES ADDITIONAL_MAKE_CLEAN_FILES ${WORKSPACE_PATH}/tmp/${board_target})

#######################################################################################################################
# Build bluenet as external project
#######################################################################################################################

ExternalProject_Add(Crownstone
  SOURCE_DIR ${WORKSPACE_PATH}/source
  BINARY_DIR ${WORKSPACE_PATH}/build/${board_target}
  INSTALL_DIR ${WORKSPACE_PATH}/bin/${board_target}
  STAMP_DIR ${WORKSPACE_PATH}/stamp/${board_target}
  TMP_DIR ${WORKSPACE_PATH}/tmp/${board_target}
  CMAKE_CACHE_ARGS "${CMAKE_ARGS}"
  BUILD_ALWAYS 1
  )

