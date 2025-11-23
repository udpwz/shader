cmake_minimum_required(VERSION 3.24...3.30)
project("gradient-line")

include(FetchContent)

# Generate compile_commands.json
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# Dependencies
set(RAYLIB_VERSION 5.0)

FetchContent_Declare(
    raylib
    DOWNLOAD_EXTRACT_TIMESTAMP OFF
    URL https://github.com/raysan5/raylib/archive/refs/tags/${RAYLIB_VERSION}.tar.gz
    FIND_PACKAGE_ARGS
)

FetchContent_MakeAvailable(raylib)

# Our Project
add_executable(${PROJECT_NAME} main.c)

set_target_properties(${PROJECT_NAME} PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${PROJECT_NAME})

set_property(TARGET ${PROJECT_NAME} PROPERTY VS_DEBUGGER_WORKING_DIRECTORY $<TARGET_FILE_DIR:${PROJECT_NAME}>)


#set(raylib_VERBOSE 1)
target_link_libraries(${PROJECT_NAME} raylib)

# Copy shader files to build directory
# Create a custom target that always runs to copy shaders
add_custom_target(copy_shaders ALL
    # Delete existing shader files first
    COMMAND ${CMAKE_COMMAND} -E rm -f
        $<TARGET_FILE_DIR:${PROJECT_NAME}>/shader.vert
        $<TARGET_FILE_DIR:${PROJECT_NAME}>/shader.frag

    # Copy shader files
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
        ${CMAKE_SOURCE_DIR}/shader.vert
        $<TARGET_FILE_DIR:${PROJECT_NAME}>/shader.vert

    COMMAND ${CMAKE_COMMAND} -E copy_if_different
        ${CMAKE_SOURCE_DIR}/shader.frag
        $<TARGET_FILE_DIR:${PROJECT_NAME}>/shader.frag

    COMMENT "Deleting and copying shader files to build directory"
    VERBATIM
)

# Make sure shaders are copied after the executable directory is created
add_dependencies(copy_shaders ${PROJECT_NAME})

# Add shader files as dependencies so they trigger rebuild/copy when modified
set_property(
    TARGET ${PROJECT_NAME}
    APPEND
    PROPERTY ADDITIONAL_CLEAN_FILES
        $<TARGET_FILE_DIR:${PROJECT_NAME}>/shader.vert
        $<TARGET_FILE_DIR:${PROJECT_NAME}>/shader.frag
)

# Web Configurations
if ("${PLATFORM}" STREQUAL "Web")
    # Tell Emscripten to build an example.html file.
    set_target_properties(${PROJECT_NAME} PROPERTIES SUFFIX ".html")
    target_link_options(${PROJECT_NAME} PUBLIC -sUSE_GLFW=3 PUBLIC --preload-file resources)
endif()


