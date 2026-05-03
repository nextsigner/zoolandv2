# --- Configuración Específica para Linux Desktop ---
message(STATUS "Aplicando configuración de LINUX DESKTOP...")

# Definiciones de compilación (Equivalente a DEFINES += ...)
target_compile_definitions(appzoolandv2 PRIVATE
    IS_LINUX_DESKTOP
    QT_DISABLE_DEPRECATED_BEFORE=0x060000
)

# Rutas para el modelo de código de Qt Creator (Equivalente a QML_IMPORT_PATH)
set(QML_IMPORT_PATH "${CMAKE_CURRENT_SOURCE_DIR}" CACHE STRING "" FORCE)

# Reglas de Instalación (Equivalente a target.path)
# Instala el binario en /opt/zoolandv2/bin
set(INSTALL_BINDIR "/opt/zoolandv2/bin")
install(TARGETS appzoolandv2
    RUNTIME DESTINATION "${INSTALL_BINDIR}"
    BUNDLE  DESTINATION "${INSTALL_BINDIR}"
    LIBRARY DESTINATION "${INSTALL_BINDIR}"
)

# Librerías matemáticas para Linux
target_link_libraries(appzoolandv2 PRIVATE m)

message(STATUS "Entorno Desktop configurado correctamente.")