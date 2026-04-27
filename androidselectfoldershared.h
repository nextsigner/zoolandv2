#ifndef ANDROIDSELECTFOLDERSHARED_H
#define ANDROIDSELECTFOLDERSHARED_H

#include <QObject>
#include <QJniObject>

#ifdef Q_OS_ANDROID
#include <QGuiApplication>
#include <QtCore/qnativeinterface.h>
#endif

class AndroidSelectFolderShared : public QObject
#ifdef Q_OS_ANDROID
    , public QNativeInterface::QAndroidActivityResultReceiver
#endif
{
    Q_OBJECT
public:
    explicit AndroidSelectFolderShared(QObject *parent = nullptr);

    Q_INVOKABLE void openFolderPicker();

#ifdef Q_OS_ANDROID
    // La firma debe usar QJniObject
    void handleActivityResult(int receiverRequestCode, int resultCode, const QJniObject &data) override;
#endif

signals:
    void folderSelected(QString uri);
};

#endif