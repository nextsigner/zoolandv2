import QtQuick

Rectangle{
    id: r
    color: 'transparent'
    anchors.centerIn: parent
    property int ih: 0
    property color cl: zoolMap.cl
    SequentialAnimation on cl{
        running: zoolMap.currentIndexHouse===r.ih
        loops: Animation.Infinite
        onRunningChanged: {
            if(!running)r.cl=zoolMap.cl
        }

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
        height: zoolMap.wl
        color: 'transparent'
        anchors.centerIn: parent
        Rectangle{
            width: (parent.width*0.5)-zoolMap.bodieSize*0.5
            height: parent.height
            color: r.cl
            anchors.right: parent.horizontalCenter
            Rectangle{
                width: zoolMap.bodieSize
                height: width
                radius: width*0.5
                color: 'transparent'
                border.width: zoolMap.wl
                border.color: r.cl
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.left
                MouseArea{
                    anchors.fill: parent
                    onClicked: zoolMap.currentIndexHouse=r.ih
                }
                Text{
                    text: '<b>'+parseInt(r.ih+1)+'</b>'
                    font.pixelSize: zoolMap.bodieSize*0.85
                    color: r.cl
                    rotation: 360-r.rotation
                    horizontalAlignment: Text.AlignHCenter
                    anchors.centerIn: parent
                }
            }
        }
    }
}