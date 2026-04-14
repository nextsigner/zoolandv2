# zoolandv2

## ¿Para qué sirve esta aplicación?
Esta es una aplicación para realizar consultas astrológicas. En principio obtiene datos desde la librería SwisEph, crea una lista de los estados de los cuerpos astrológicos y cuenta con unos botones para compartir una consulta personalizada hacia otras apps android para realizar la interpretación. Por ejemplo Google Gemini o Grok entre otras.

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

## Contacto
Si tenés alguna duda me podes contactar por las siguientes vías de comunicación:
Whatsapp: +54 9 11 3802 4370
E-Mail: qtpizarro@gmail.com
Instagram: RicardoMartinPizarro
Twitch: RicardoMartinPizarro
YouTube: Astrologo Ricardo Martin
Facebook: Ricardo Martín Pizarro Astrólogo Argentina.