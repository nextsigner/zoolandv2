# --- Configuración de Swiss Ephemeris para Android ---

# 1. Ruta de los encabezados (donde están los .h)
INCLUDEPATH += $$PWD/libs/swisseph

# 2. Agregar todos los archivos fuente (.c) de la librería
# Usamos $$files para no tener que escribir uno por uno
SOURCES += $$files($$PWD/libs/swisseph/*.c)

# 3. Definiciones recomendadas para Swiss Ephemeris en entornos Unix/Android
DEFINES += USE_QUICK_SORT

# Opcional: Si necesitas que el compilador ignore ciertos warnings de la librería .c
QMAKE_CFLAGS += -w

# --- Inclusión de Assets y Archivos en el APK ---

# Lista de carpetas que quieres incluir
DEPLOYMENT_FOLDERS = $$PWD/android/assets/modules \
                     $$PWD/android/assets/ephe \
                     $$PWD/android/assets/imgs \
                     $$PWD/android/jsons

# Agregarlos a DISTFILES para que sean visibles en el árbol del proyecto (Qt Creator)
for(folder, DEPLOYMENT_FOLDERS): DISTFILES += $$files($$folder/*)

# Configuración para que se copien al sistema de archivos del APK
# Esto asegura que los archivos se incluyan en el paquete de activos
assets.path = /assets
assets.files = $$PWD/android/assets/modules \
               $$PWD/android/assets/ephe \
               $$PWD/android/assets/imgs

json_files.path = /assets/jsons
json_files.files = $$PWD/android/jsons/*

INSTALLS += assets json_files