import QtQuick

Rectangle{
    id: r
    width: zoolMap.fs*8
    height: width
    radius: width*0.5
    border.width: 1
    border.color: 'white'
    color: 'black'
    anchors.centerIn: parent
    MouseArea{
        anchors.fill: parent
        onClicked: {
            r.width=zoolMap.aspCircleWidth
        }
    }
}