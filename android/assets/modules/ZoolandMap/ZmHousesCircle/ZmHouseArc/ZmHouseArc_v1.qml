import QtQuick

Rectangle{
    id: r
    color: 'transparent'
    anchors.centerIn: parent
    property int ih: 0
    property color cl: 'red'
    property int wl: app.fs*0.25
    SequentialAnimation on cl{
        running: zoolMap.currentIndexHouse===r.ih
        loops: Animation.Infinite

        ColorAnimation {
            from: "red"
            to: "yellow"
            duration: 200
        }
        ColorAnimation {
            from: "yellow"
            to: "red"
            duration: 200
        }
    }
    Rectangle{
        width: parent.width+zoolMap.bodieSize*2
        height: r.wl
        color: 'transparent'
        anchors.centerIn: parent
        Rectangle{
            width: (parent.width*0.5)-zoolMap.bodieSize*0.5
            height: parent.height
            color: r.cl
            //anchors.left: parent.left
            //anchors.leftMargin: 0-width
            anchors.right: parent.horizontalCenter
            //anchors.rightMargin: 0-zoolMap.bodiSize
            Rectangle{
                width: zoolMap.bodieSize*2
                height: width
                radius: width*0.5
                color: 'transparent'
                border.width: r.wl
                border.color: r.cl
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.left
                MouseArea{
                    anchors.fill: parent
                    onClicked: zoolMap.currentIndexHouse=r.ih
                }
                Text{
                    text: ''+parseInt(r.ih+1)
                    font.pixelSize: zoolMap.bodieSize*0.65
                    color: r.cl
                    rotation: 360-r.rotation
                    horizontalAlignment: Text.AlignHCenter
                    anchors.centerIn: parent
                }
            }
        }
    }
}