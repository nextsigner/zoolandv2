import QtQuick
import QtQuick.Effects


Rectangle{
    id: r
    width: parent.width
    height: width
    color: 'transparent'
    property int numBodie: -1
    Rectangle{
        id: ejeBodie
        width: parent.width*0.5
        height: 1
        color: 'transparent'
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.horizontalCenter
        Rectangle{
            width: zoolMap.bodieSize
            height: width
            radius: width*0.5
            color: 'transparent'
            anchors.verticalCenter: parent.verticalCenter
            rotation: 360-r.rotation-45-zoolMap.signCircleRot
            Image{
                id: img
                anchors.fill: parent
                source: 'assets:/imgs/imgs_v2/glifos/'+zoolMap.bodiesRes[r.numBodie]+'.svg'

                sourceSize: Qt.size(width, height)

                // En MultiEffect, la imagen fuente DEBE ser invisible
                visible: false
            }
            MultiEffect {
                anchors.fill: img
                source: img

                // 1. Convertimos el negro en algo "teñible" subiendo el brillo
                // Un brillo de 1.0 convierte el negro en blanco (valor 1.0)
                brightness: 1.0

                // 2. Aplicamos la colorización al 100%
                colorization: 1.0
                colorizationColor: zoolMap.bodieColor

                autoPaddingEnabled: true
            }
        }
    }

}