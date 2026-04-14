#ifndef ANDROIDSHARE_H
#define ANDROIDSHARE_H

#include <QObject>

class AndroidShare : public QObject {
    Q_OBJECT
public:
    explicit AndroidShare(QObject *parent = nullptr) : QObject(parent) {}

    // Esta es la función que llamaremos desde QML
    Q_INVOKABLE void shareToGemini(const QString &text);
};

#endif