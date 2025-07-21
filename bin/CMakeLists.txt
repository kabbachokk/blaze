#TODO: add files manually for each arch
file(GLOB BIN_SOURCES *.cc *.c *.h *.S *.s)

include(CMakeDependentOption)
option(DUMMY_OPTION "DUMMY OPTION"  ON)

configure_file(config.h.in  config.h)
configure_file(config_arm64.h.in  config_arm64.h)

set(LINKER_SCRIPT "blaze_arm64.ld")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -T ${CMAKE_CURRENT_SOURCE_DIR}/${LINKER_SCRIPT}")

#add_library(blaze_objects OBJECT ${BIN_SOURCES})

add_executable(blaze
    start_arm64.S
    main.cc
    main_arm64.cc
)
set_target_properties(blaze PROPERTIES LINK_DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/${LINKER_SCRIPT})
#target_link_options(blaze PRIVATE "-T${CMAKE_CURRENT_SOURCE_DIR}/${LINKER_SCRIPT}")

target_include_directories(blaze PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})
target_include_directories(blaze PRIVATE ${CMAKE_CURRENT_BINARY_DIR})