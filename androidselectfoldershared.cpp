#include "androidselectfoldershared.h"

// Request code para identificar nuestra petición
const int PICK_FOLDER_REQUEST = 42;

AndroidSelectFolderShared::AndroidSelectFolderShared(QObject *parent) : QObject(parent) {}

void AndroidSelectFolderShared::openFolderPicker() {
#ifdef Q_OS_ANDROID
    QJniObject intent("android/content/Intent");
    QJniObject action = QJniObject::getStaticObjectField("android/content/Intent", "ACTION_OPEN_DOCUMENT_TREE", "Ljava/lang/String;");
    intent.callObjectMethod("setAction", "(Ljava/lang/String;)Landroid/content/Intent;", action.object());

    // Lanzar con el receptor (this)
    QJniObject activity = QNativeInterface::QAndroidApplication::context();
    activity.callMethod<void>("startActivityForResult", "(Landroid/content/Intent;I)V",
                              intent.object(), PICK_FOLDER_REQUEST);
#endif
}

// Se ejecuta automáticamente cuando el usuario cierra el selector de Android
void AndroidSelectFolderShared::handleActivityResult(int receiverRequestCode, int resultCode, const QJniObject &data) {
    if (receiverRequestCode == PICK_FOLDER_REQUEST && resultCode == -1) { // -1 es RESULT_OK
        // Extraer el URI de la carpeta
        QJniObject uri = data.callObjectMethod("getData", "()Landroid/net/Uri;");
        if (uri.isValid()) {
            QString uriString = uri.callObjectMethod("toString", "()Ljava/lang/String;").toString();

            // Emitir la señal hacia QML
            emit folderSelected(uriString);
        }
    }
}