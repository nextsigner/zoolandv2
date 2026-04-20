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
    property alias objBodiesCircle: zmBodiesCircle
    property alias tsaw: tsaw



    ZmSignsCircle{
        id: signCircle
        wrz: r.wrz
        wbrz: r.wrz*0.2
        width: parent.width-r.wrz
        height: parent.height
        anchors.centerIn: parent
    }
    ZmHousesCircle{
        id: zmHousesCircle
        width: parent.width
        height: parent.height
        anchors.centerIn: parent
    }
    ZmAspsCircle{
        id: zmAspsCircle
        width: zoolMap.aspCircleWidth//parent.width-(signCircle.wrz*2)-(zoolMap.bodieSize*posMaxInt*2)
    }
    ZmBodiesCircle{
        id: zmBodiesCircle
        width: parent.width-(r.wrz*2)
    }
    Rectangle{
        id: centro
        width: app.fs*0.5
        height: width
        color: 'yellow'
        radius: width*0.5
        anchors.centerIn: parent
        visible: false
    }
    Text{
        id: txtCentral
        text: 'MW:'+zoolMap.aspCircleWidth
        font.pixelSize: zoolMap.fs*2
        color: 'red'
        anchors.centerIn: parent
        visible: false
    }
    property int currentBodieForAspsWidth: 0
    Timer{
        id: tsaw
        running: true
        repeat: false//true
        interval: 250
        onTriggered: {
            let nCurrentBodieForAspsWidth=-1
            let widthMenor=r.width
            for(var i=0;i<zoolMap.aBodies.length;i++){
                let bw=parseInt(zmBodiesCircle.getBodieWidth(i))
                if(bw<=widthMenor){
                    widthMenor=bw
                    txtCentral.text=zoolMap.aBodies[i]+':|'+zoolMap.posMaxInt+'\n'+bw
                    //currentBodieForAspsWidth=i
                    nCurrentBodieForAspsWidth=i
                }
                zoolMap.zm.currentBodieForAspsWidth=nCurrentBodieForAspsWidth
            }
        }
    }
    Timer{
        running: false//true
        repeat: true
        interval: 3000
        onTriggered: {
            //zoolMap.aspCircleWidth=parseInt(zmBodiesCircle.getBodieWidth(zoolMap.zm.currentBodieForAspsWidth))-parseInt(zoolMap.bodieSize*0.5*(zoolMap.posMaxInt-1))-zoolMap.bodieSize*2
        }
    }
    function load(j){
        let signCircleRot=j.ph.h1.gdec
        signCircle.rotation=signCircleRot
        zoolMap.signCircleRot=signCircleRot
        zmBodiesCircle.load(j)
        zmHousesCircle.load(j)
    }

}
