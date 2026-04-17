import QtQuick
import ZoolandMap.ZmSignsCircle 1.0
import ZoolandMap.ZmHousesCircle 1.0
import ZoolandMap.ZmBodiesCircle 1.0
import ZoolandMap.ZmAspsCircle 1.0

Rectangle{
    id: r
    width: parent.width
    height: parent.height
    color: 'transparent'
    border.width: 1
    border.color: 'blue'
    property real signRot: 0
    property int wrz: 0
    ZmSignsCircle{
        id: signCircle
        wrz: r.wrz
        wbrz: r.wrz*0.2
        width: parent.width-r.wrz
        height: parent.height
        anchors.centerIn: parent
    }
    ZmHousesCircle{
        width: parent.width
        height: parent.height
        anchors.centerIn: parent
    }
    ZmAspsCircle{
        id: zmAspsCircle
    }
    ZmBodiesCircle{
        id: zmBodiesCircle
        width: parent.width-(r.wrz*2)
    }
    function load(j){
        let signCircleRot=j.ph.h1.gdec
        signCircle.rotation=signCircleRot
        zoolMap.signCircleRot=signCircleRot
        zmBodiesCircle.load(j)
        zmHousessCircle.load(j)
    }

}
