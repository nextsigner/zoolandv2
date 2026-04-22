cmake_minimum_required(VERSION 3.16)

project(zoolandv2 VERSION 0.1 LANGUAGES CXX C)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# 1. Componentes necesarios
find_package(Qt6 REQUIRED COMPONENTS Quick Sql Core Gui)

qt_standard_project_setup(REQUIRES 6.10)

# 2. Definición del ejecutable
qt_add_executable(appzoolandv2
    main.cpp
    swissephmanager.h swissephmanager.cpp
)

# Asegúrate de que esto esté después de qt_add_executable
set_target_properties(appzoolandv2 PROPERTIES
    QT_ANDROID_BUILD_ALL_ABIS OFF
    QT_ANDROID_ABIS "arm64-v8a"
    QT_CREATE_APK ON
)

# 3. Módulo QML con todas tus clases integradas como SOURCES
# He añadido androidshare.h y androidshare.cpp al final de la lista
qt_add_qml_module(appzoolandv2
    URI zoolandv2
    VERSION 1.0
    QML_FILES
        Main.qml
    SOURCES
        ul.h ul.cpp
        row.h row.cpp
        qmlerrorlogger.h qmlerrorlogger.cpp
        qmlclipboardadapter.h
        unikqprocess.h unikqprocess.cpp
        androidshare.h androidshare.cpp
        QML_FILES Form.qml
)

# --- 4. SECCIÓN SWISSEPH ---
target_include_directories(appzoolandv2 PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/libs/swisseph)
file(GLOB SWISSEPH_SOURCES "${CMAKE_CURRENT_SOURCE_DIR}/libs/swisseph/*.c")
target_sources(appzoolandv2 PRIVATE ${SWISSEPH_SOURCES})

# --- 5. CONFIGURACIÓN DE PLATAFORMAS ---
if(WIN32)
    target_compile_definitions(appzoolandv2 PRIVATE _CRT_SECURE_NO_WARNINGS)
endif()

if(UNIX OR ANDROID)
    target_link_libraries(appzoolandv2 PRIVATE m)
endif()

# Vinculación de librerías Qt
target_link_libraries(appzoolandv2 PRIVATE
    Qt6::Quick
    Qt6::Sql
    Qt6::Core
    Qt6::Gui
)

target_link_libraries(appzoolandv2 PRIVATE
    Qt6::Quick
    Qt6::Sql
    Qt6::Core
    Qt6::Gui
)

if(ANDROID)
    # Esto es vital para que las APIs de Android se activen en el compilador
    target_link_libraries(appzoolandv2 PRIVATE Qt6::Core)
endif()

# --- 6. PROPIEDADES DE ANDROID Y ASSETS ---
if(ANDROID)
    # Vinculación necesaria para JNI y APIs nativas en Qt 6
    target_link_libraries(appzoolandv2 PRIVATE Qt6::Core)

    set_target_properties(appzoolandv2 PROPERTIES
        QT_ANDROID_PACKAGE_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/android"
    )

    # Inclusión de assets (Ephe y Jsons)
    file(GLOB_RECURSE ASSETS_EPHE "${CMAKE_CURRENT_SOURCE_DIR}/android/assets/ephe/*")
    file(GLOB_RECURSE ASSETS_JSONS "${CMAKE_CURRENT_SOURCE_DIR}/android/assets/jsons/*.json")

    target_sources(appzoolandv2 PRIVATE ${ASSETS_EPHE} ${ASSETS_JSONS})
endif()

set_target_properties(appzoolandv2 PROPERTIES
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

# --- 7. INSTALACIÓN ---
install(TARGETS appzoolandv2
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

if(ANDROID)
    # 1. Definimos la ruta
    set(OPEN_SSL_LIBS_PATH "/home/ns/nsp/android_openssl/ssl_3/arm64-v8a")

    # 2. Creamos una lista con las librerías
    set(MY_SSL_LIBS
        "${OPEN_SSL_LIBS_PATH}/libcrypto_3.so"
        "${OPEN_SSL_LIBS_PATH}/libssl_3.so"
    )

    # 3. Aplicamos la propiedad usando la lista
    set_target_properties(appzoolandv2 PROPERTIES
        QT_ANDROID_EXTRA_LIBS "${MY_SSL_LIBS}"
    )

    # 4. Headers (por si los necesitas en C++)
    target_include_directories(appzoolandv2 PRIVATE "/home/ns/nsp/android_openssl/ssl_3/include")
endif()