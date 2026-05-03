# --- Configuración Específica para Android ---
message(STATUS "Aplicando configuración de ANDROID...")

#QT+= androidextras

# Directorio de fuentes de Android (donde está el Manifest)
set_target_properties(appzoolandv2 PROPERTIES
    QT_ANDROID_PACKAGE_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/android"
)

# Inclusión de Assets (Ephemeris y JSONs)
file(GLOB_RECURSE ASSETS_EPHE "${CMAKE_CURRENT_SOURCE_DIR}/android/assets/ephe/*")
file(GLOB_RECURSE ASSETS_JSONS "${CMAKE_CURRENT_SOURCE_DIR}/android/assets/jsons/*.json")
target_sources(appzoolandv2 PRIVATE ${ASSETS_EPHE} ${ASSETS_JSONS})

# Configuración de OpenSSL (Asegúrate de que estas rutas existen en tu Lubuntu)
set(OPEN_SSL_LIBS_PATH "/home/ns/nsp/android_openssl/ssl_3/arm64-v8a")
set(MY_SSL_LIBS
    "${OPEN_SSL_LIBS_PATH}/libcrypto_3.so"
    "${OPEN_SSL_LIBS_PATH}/libssl_3.so"
)

set_target_properties(appzoolandv2 PROPERTIES
    QT_ANDROID_EXTRA_LIBS "${MY_SSL_LIBS}"
)

target_include_directories(appzoolandv2 PRIVATE "/home/ns/nsp/android_openssl/ssl_3/include")

# Librerías matemáticas para Android
target_link_libraries(appzoolandv2 PRIVATE m)