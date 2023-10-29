# returns all subdirectories in directory
FUNCTION(SUBDIRLIST result curdir)
  FILE(GLOB children RELATIVE ${curdir} ${curdir}/*)
  SET(dirlist "")
  FOREACH(child ${children})
    IF(IS_DIRECTORY ${curdir}/${child})
      LIST(APPEND dirlist ${child})
    ENDIF()
  ENDFOREACH()
  SET(${result} ${dirlist} PARENT_SCOPE)
ENDFUNCTION()

FUNCTION(INCLUDE_INNER_DEPENDENCIES _TARGET ACCESS DEPS_LIST)
  set(paths "")
  set( deps_list ${DEPS_LIST} ${ARGN} ) # Merge them together
  foreach (dependency ${deps_list})
    message(CHECK_START "Finding " ${dependency})
    if( EXISTS ${SOURCE_DIR}/${dependency})
      LIST(APPEND paths ${SOURCE_DIR}/${dependency})
      message(CHECK_PASS "Found " ${dependency})
    else()
      message(CHECK_FAIL "Couldn't find dependency " ${dependency})
    endif()
  endforeach()
  message(STATUS "include paths: " ${paths})
  target_include_directories(${_TARGET} ${ACCESS} ${paths})
ENDFUNCTION()

FUNCTION(INCLUDE_THIRD_PARTY _TARGET ACCESS THIRD_PARTY_DIR)
    SUBDIRLIST(DEPS_LIST ${THIRD_PARTY_DIR})
    set(deps_include_paths "")
  foreach (dependency ${DEPS_LIST})
      if( EXISTS ${THIRD_PARTY_DIR}/${dependency}/include)
        LIST(APPEND deps_include_paths ${${THIRD_PARTY_DIR}/${dependency}/include})
      else()
         LIST(APPEND deps_include_paths ${${THIRD_PARTY_DIR}/${dependency}})
      endif()
  endforeach()
  target_include_directories(${_TARGET} ${ACCESS} ${deps_include_paths})
ENDFUNCTION()

FUNCTION(BUILD_THIRD_PARTY THIRD_PARTY_DIR DEPS_LIST)
    SUBDIRLIST(ALL_DEPENDENCIES ${THIRD_PARTY_DIR})
    FOREACH(lib ${ALL_DEPENDENCIES})
      message(STATUS "    generate dependency ${lib}")
      ADD_SUBDIRECTORY(${THIRD_PARTY_DIR}/${lib})
    ENDFOREACH()
    set(${DEPS_LIST} ${ALL_DEPENDENCIES} PARENT_SCOPE)
ENDFUNCTION()