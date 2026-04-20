import QtQuick
import QtQuick.Effects


Rectangle{
    id: r
    width: parent.width-(zoolMap.bodieSize*pos)
    height: 1//parent.width-(zoolMap.bodieSize*pos)
    color: 'transparent'
    anchors.centerIn: parent
    property int numBodie: -1
    property int pos: 0
    onWidthChanged: {
        if(pos<0)return
        //tSetAspsWidth.restart()
    }
    //Behavior on width{NumberAnimation{duration: 0}}
    Timer{
        id: tSetAspsWidth
        running: r.numBodie===zoolMap.zm.currentBodieForAspsWidth && (zoolMap.aspCircleWidth!==r.width-(zoolMap.bodieSize*2))
        repeat: false
        interval: 200
        onTriggered: {
            zoolMap.aspCircleWidth=r.width-(zoolMap.bodieSize*2)
            zoolMap.zm.tsaw.restart()
        }

    }

    Rectangle{
        id: xBodie
        width: app.fs
        height: width
        radius: width*0.5
        color: 'transparent'
        border.width: 0
        border.color: 'white'
        rotation: 360-r.rotation
        anchors.verticalCenter: parent.verticalCenter
        Image{
            id: img
            //anchors.fill: parent
            width: parent.width
            height: parent.height
            anchors.centerIn: parent
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
    Rectangle{
        id: ejeBodie
        width: parent.width*0.5
        height: 20//1
        color: r.numBodie===zoolMap.zm.currentBodieForAspsWidth?'red':'transparent'
        //anchors
        //anchors.verticalCenter: parent.verticalCenter
        //anchors.right: parent.horizontalCenter
        visible: false
        Rectangle{
            width: zoolMap.bodieSize
            height: width
            radius: width*0.5
            color: 'transparent'
            border.width: 0
            border.color: 'red'
            anchors.verticalCenter: parent.verticalCenter
            rotation: 360-r.rotation//+zoolMap.signCircleRot
            //rotation: 360-r.rotation-zoolMap.signCircleRot
            Text{
                text: 'i:'+zoolMap.zm.currentBodieForAspsWidth
                font.pixelSize: 20
                color: 'green'
                anchors.centerIn: parent
            }
        }
    }

}