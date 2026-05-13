import QtQuick

Rectangle {
    id: r
    width: parent.width
    height: app.fs
    color: "transparent"

    signal positionChanged(int pos)
    signal release(int pos)

    readonly property int limit: width * 0.4
    property int currentValue: 0

    // Riel de guía
    Rectangle {
        width: parent.width * 0.9
        height: 2
        color: apps.fontColor
        opacity: 0.3
        anchors.centerIn: parent
    }

    Rectangle {
        id: handle
        width: parent.height * 0.9
        height: width
        color: dragHandler.active ? "red" : apps.fontColor
        radius: width * 0.1
        anchors.verticalCenter: parent.verticalCenter

        // Posición horizontal inicial centrada
        property real centerX: (r.width / 2) - (width / 2)
        x: centerX

        // Animación de retorno
        Behavior on x {
            // Solo se activa la animación cuando el usuario SUELTA el control
            enabled: !dragHandler.active
            NumberAnimation {
                duration: 250
                easing.type: Easing.OutBack
            }
        }

        DragHandler {
            id: dragHandler
            target: handle
            xAxis.minimum: handle.centerX - r.limit
            xAxis.maximum: handle.centerX + r.limit
            yAxis.enabled: false

            onActiveChanged: {
                if (!active) {
                    // Al soltar, reseteamos el valor interno a 0
                    // pero NO enviamos señal (porque currentValue no cambia vía onTranslationChanged)
                    r.release(r.currentValue)
                    r.currentValue = 0
                    handle.x = handle.centerX
                }
            }

            onTranslationChanged: {
                // Solo calculamos y enviamos señal mientras el usuario arrastra
                if (active) {
                    let relativeX = handle.x - handle.centerX
                    let newValue = Math.round((relativeX / r.limit) * 100)

                    if (newValue !== r.currentValue) {
                        r.currentValue = newValue
                        r.positionChanged(r.currentValue)
                    }
                }
            }
        }
    }
}