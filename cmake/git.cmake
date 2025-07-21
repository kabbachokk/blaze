find_package(Git QUIET)
if(NOT Git_FOUND)
    message(WARNING "Git not found. Version information may be incomplete.")
endif()

if(Git_FOUND)
    execute_process(
        COMMAND ${GIT_EXECUTABLE} rev-parse --short HEAD
        OUTPUT_VARIABLE GIT_COMMIT_HASH_SHORT
        OUTPUT_STRIP_TRAILING_WHITESPACE
         RESULT_VARIABLE GIT_REV_PARSE_RESULT
    )
    if(GIT_REV_PARSE_RESULT EQUAL 0)
        message(STATUS "Current git commit: ${GIT_COMMIT_HASH_SHORT}")
    else()
        message(WARNING "Failed to get Git commit hash.")
        #TODO: GIT_COMMIT_HASH_SHORT = 0
    endif()
endif()