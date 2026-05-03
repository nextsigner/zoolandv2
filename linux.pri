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