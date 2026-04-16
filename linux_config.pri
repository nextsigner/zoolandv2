cmake_minimum_required(VERSION 3.20)

project(zoolandvfake VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.11 REQUIRED COMPONENTS Quick Sql)

qt_standard_project_setup(REQUIRES 6.11)

qt_add_executable(appzoolandv2
    main.cpp
)

qt_add_qml_module(appzoolandv2
    URI zoolandv2
    VERSION 1.0
    QML_FILES
        Main.qml
        Form.qml
    SOURCES
        ul.h ul.cpp
        row.h row.cpp
        qmlerrorlogger.h qmlerrorlogger.cpp
        qmlclipboardadapter.h qmlclipboardadapter.cpp
        unikqprocess.h unikqprocess.cpp
        androidshare.h androidshare.cpp
)

# Swiss Ephemeris
set(SWISSEPH_DIR "${CMAKE_CURRENT_SOURCE_DIR}/libs/swisseph")

target_include_directories(appzoolandv2 PRIVATE ${SWISSEPH_DIR})

find_library(SWISSEPH_LIB
    NAMES swe swisseph
    PATHS ${SWISSEPH_DIR}
    NO_DEFAULT_PATH
    REQUIRED
)

if(NOT SWISSEPH_LIB)
    message(FATAL_ERROR "Swiss Ephemeris library not found in: ${SWISSEPH_DIR}")
endif()

target_link_libraries(appzoolandv2
    PRIVATE
        Qt6::Quick
        Qt6::Sql
        ${SWISSEPH_LIB}
)

set_target_properties(appzoolandv2 PROPERTIES
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

install(TARGETS appzoolandv2
    BUNDLE  DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)