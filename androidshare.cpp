#include "androidshare.h"
#include <QGuiApplication>

#ifdef Q_OS_ANDROID
#include <QJniObject>
#include <QJniEnvironment>
#endif

void AndroidShare::shareToGemini(const QString &text) {
#ifdef Q_OS_ANDROID
    QJniObject jText = QJniObject::fromString(text);

    // 1. Crear el Intent: Intent intent = new Intent(Intent.ACTION_SEND);
    QJniObject intent("android/content/Intent");
    QJniObject actionSend = QJniObject::getStaticObjectField("android/content/Intent", "ACTION_SEND", "Ljava/lang/String;");
    intent.callObjectMethod("setAction", "(Ljava/lang/String;)Landroid/content/Intent;", actionSend.object());

    // 2. Añadir el texto: intent.putExtra(Intent.EXTRA_TEXT, text);
    QJniObject extraText = QJniObject::getStaticObjectField("android/content/Intent", "EXTRA_TEXT", "Ljava/lang/String;");
    intent.callObjectMethod("putExtra", "(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;",
                            extraText.object(), jText.object());

    // 3. Definir el tipo MIME: intent.setType("text/plain");
    QJniObject mimeType = QJniObject::fromString("text/plain");
    intent.callObjectMethod("setType", "(Ljava/lang/String;)Landroid/content/Intent;", mimeType.object());

    // 4. (Opcional) Intentar forzar la App de Gemini si conoces su nombre de paquete
    // intent.setPackage("com.google.android.apps.bard");

    // 5. Iniciar la actividad
    QJniObject activity = QNativeInterface::QAndroidApplication::context();
    activity.callMethod<void>("startActivity", "(Landroid/content/Intent;)V", intent.object());
#else
    qDebug() << "Compartir solo funciona en Android: " << text;
#endif
}