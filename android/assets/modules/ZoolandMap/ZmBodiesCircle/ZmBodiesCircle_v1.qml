import QtQuick
import ZoolandMap.ZmBodiesCircle.ZmBodie 1.0

Item{
    id: r
    height: width
    anchors.centerIn: parent

    Item{
        id: xBodies
        anchors.fill: parent
        Repeater{
            model: zoolMap.aBodies
            ZmBodie{
                numBodie: index
                rotation: 10*index
            }
        }
    }
    function load(j){
      for(var i=0;i<zoolMap.aBodies.length;i++){
        xBodies.children[i].rotation=360-(360-j.ph['h1'].gdec)-j.pc['c'+i].gdec
      }
    }
}