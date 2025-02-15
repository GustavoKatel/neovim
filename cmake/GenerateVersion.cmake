if(NVIM_VERSION_MEDIUM)
  message(STATUS "USING NVIM_VERSION_MEDIUM: ${NVIM_VERSION_MEDIUM}")
  return()
endif()

set(NVIM_VERSION_MEDIUM
    "v${NVIM_VERSION_MAJOR}.${NVIM_VERSION_MINOR}.${NVIM_VERSION_PATCH}${NVIM_VERSION_PRERELEASE}")

execute_process(
  COMMAND git describe --first-parent --tags --always --dirty
  OUTPUT_VARIABLE GIT_TAG
  ERROR_VARIABLE ERR
  RESULT_VARIABLE RES
)

if(NOT RES EQUAL 0)
  message(STATUS "Git tag extraction failed:\n"  "   ${GIT_TAG}${ERR}" )
  # This will only be executed once since the file will get generated afterwards.
  message(STATUS "Using NVIM_VERSION_MEDIUM: ${NVIM_VERSION_MEDIUM}")
  file(WRITE "${OUTPUT}" "${NVIM_VERSION_STRING}")
  return()
endif()

string(STRIP "${GIT_TAG}" GIT_TAG)
string(REGEX REPLACE "^v[0-9]+.[0-9]+.[0-9]+-" "" NVIM_VERSION_GIT "${GIT_TAG}")
set(NVIM_VERSION_MEDIUM "${NVIM_VERSION_MEDIUM}-${NVIM_VERSION_GIT}")
set(NVIM_VERSION_STRING "#define NVIM_VERSION_MEDIUM \"${NVIM_VERSION_MEDIUM}\"\n")

string(SHA1 CURRENT_VERSION_HASH "${NVIM_VERSION_STRING}")
if(EXISTS ${OUTPUT})
  file(SHA1 "${OUTPUT}" NVIM_VERSION_HASH)
endif()

if(NOT "${NVIM_VERSION_HASH}" STREQUAL "${CURRENT_VERSION_HASH}")
  message(STATUS "Using NVIM_VERSION_MEDIUM: ${NVIM_VERSION_MEDIUM}")
  file(WRITE "${OUTPUT}" "${NVIM_VERSION_STRING}")
endif()
