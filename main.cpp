#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include "ul.h"
#include "qmlclipboardadapter.h"
#include "qmlerrorlogger.h"
#include "swissephmanager.h"
#include "androidshare.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    UL u;
    u.setEngine(&engine);
    u.checkPermissions();

    //-->Preset App Name
    QByteArray presetFilePath="";
    presetFilePath.append(qApp->applicationDirPath().toUtf8());
    presetFilePath.append("/preset");

    QString presetAppName="";
    if(u.fileExist(presetFilePath)){
        presetAppName.append(u.getFile(presetFilePath));
        presetAppName=presetAppName.replace("\n", "");
    }else{
        presetAppName.append("UniKey");    }

    qDebug()<<"Runing "<<presetAppName<<"...";
    //<--Preset App Name

    //Clipboard function for GNU/Linux, Windows and Macos
//#ifndef Q_OS_ANDROID
    QmlClipboardAdapter clipboard;
    AndroidShare androidShare;
//#endif

    qmlRegisterType<UL>("unik.Unik", 1, 0, "Unik");
    //<--Register Types
    qmlRegisterType<UnikQProcess>("unik.UnikQProcess", 1, 0, "UnikQProcess");
    qmlRegisterType<SwissEphManager>("swe", 1, 0, "Swe");
    engine.rootContext()->setContextProperty("clipboard", &clipboard);
    engine.rootContext()->setContextProperty("AndroidShare", &androidShare);
    engine.addImportPath("assets:/modules");
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("zoolandv2", "Main");

    return QCoreApplication::exec();
}
