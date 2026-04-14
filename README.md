# zoolandv2

### ¿En qué contexto compilar este proyecto?
Este proyecto está siendo compilado con Qt Open Source 6.11.0 en el Sistema Operativo Ubuntu 22.04.

### Configuración del proyecto
Este proyecto está configurado solo arm64-v8a.
Si quieres compilar para todas las ABIS debes modificar lo siguiente en el archiv CMakeLists.txt:

QT_ANDROID_BUILD_ALL_ABIS OFF
QT_ANDROID_ABIS "arm64-v8a"

por 

QT_ANDROID_BUILD_ALL_ABIS ON
Borrar esta línea o comentarla #QT_ANDROID_ABIS "arm64-v8a"
