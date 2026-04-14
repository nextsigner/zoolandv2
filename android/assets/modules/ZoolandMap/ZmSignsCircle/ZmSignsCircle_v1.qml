import QtQuick
import ZoolandMap.ZmSignsCircle.ZmSignArc 1.0

Rectangle{
    id: r
    width: 500
    height: 500
    color: 'green'
    property int wrz: 0
    Repeater{
        model: 12
        ZmSignArc{
            wrz: r.wrz
            is: index
            width: r.width
            height: width
            anchors.centerIn: parent
        }
    }
}