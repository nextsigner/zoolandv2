cmake_minimum_required(VERSION 3.16)
project(zoolandv2 VERSION 0.1 LANGUAGES CXX C)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# 1. Componentes necesarios
# He añadido 'Concurrent' por si lo necesitas en el futuro y aseguramos 'Core'
find_package(Qt6 REQUIRED COMPONENTS Quick Sql Core Gui)

qt_standard_project_setup(REQUIRES 6.10)

# 2. Definición del ejecutable
qt_add_executable(appzoolandv2
    main.cpp
    swissephmanager.h swissephmanager.cpp
)

set_target_properties(appzoolandv2 PROPERTIES
    QT_ANDROID_BUILD_ALL_ABIS OFF
    QT_ANDROID_ABIS "arm64-v8a"
    QT_CREATE_APK ON
)

# 3. Módulo QML
# Nota: Quité el duplicado de QML_FILES Form.qml, debe ir en la sección QML_FILES
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
        qmlclipboardadapter.h
        unikqprocess.h unikqprocess.cpp
        androidshare.h androidshare.cpp
)

# --- 4. SECCIÓN SWISSEPH ---
target_include_directories(appzoolandv2 PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/libs/swisseph)
file(GLOB SWISSEPH_SOURCES "${CMAKE_CURRENT_SOURCE_DIR}/libs/swisseph/*.c")
target_sources(appzoolandv2 PRIVATE ${SWISSEPH_SOURCES})

# --- 5. CONFIGURACIÓN DE PLATAFORMAS Y LIBRERÍAS ---
if(WIN32)
    target_compile_definitions(appzoolandv2 PRIVATE _CRT_SECURE_NO_WARNINGS)
endif()

# Vinculación consolidada de librerías Qt (Una sola vez es suficiente)
target_link_libraries(appzoolandv2 PRIVATE
    Qt6::Quick
    Qt6::Sql
    Qt6::Core
    Qt6::Gui
)

if(UNIX OR ANDROID)
    target_link_libraries(appzoolandv2 PRIVATE m)
endif()

# --- 6. ESPECÍFICO DE ANDROID ---
if(ANDROID)
    # IMPORTANTE: Esto ayuda a que el compilador encuentre headers específicos de Android
    target_link_libraries(appzoolandv2 PRIVATE Qt6::Core)

    # Si vas a usar QJniObject o interfaces nativas de Qt 6:
    # target_link_libraries(appzoolandv2 PRIVATE Qt6::GuiPrivate)

    set_target_properties(appzoolandv2 PROPERTIES
        QT_ANDROID_PACKAGE_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/android"
    )

    file(GLOB_RECURSE ASSETS_EPHE "${CMAKE_CURRENT_SOURCE_DIR}/android/assets/ephe/*")
    file(GLOB_RECURSE ASSETS_JSONS "${CMAKE_CURRENT_SOURCE_DIR}/android/assets/jsons/*.json")
    target_sources(appzoolandv2 PRIVATE ${ASSETS_EPHE} ${ASSETS_JSONS})

    # OpenSSL Config
    set(OPEN_SSL_LIBS_PATH "/home/ns/nsp/android_openssl/ssl_3/arm64-v8a")
    set(MY_SSL_LIBS
        "${OPEN_SSL_LIBS_PATH}/libcrypto_3.so"
        "${OPEN_SSL_LIBS_PATH}/libssl_3.so"
    )
    set_target_properties(appzoolandv2 PROPERTIES
        QT_ANDROID_EXTRA_LIBS "${MY_SSL_LIBS}"
    )
    target_include_directories(appzoolandv2 PRIVATE "/home/ns/nsp/android_openssl/ssl_3/include")
endif()

# ... resto de tu configuración de MACOSX y install ...