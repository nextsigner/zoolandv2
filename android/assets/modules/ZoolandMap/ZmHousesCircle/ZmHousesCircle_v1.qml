import QtQuick
import ZoolandMap.ZmHousesCircle.ZmHouseArc 1.0
Rectangle{
    id: r
    width: parent.width
    height: width
    color: 'transparent'
    border.width: 0//10
    border.color: 'blue'
    radius: width*0.5
    anchors.centerIn: parent

    Item{
        id: xHouses
        anchors.fill: parent
        Repeater{
            model: 12
            ZmHouseArc{
                width: r.width
                height: width
                rotation: (360-(30*index))//+180
                ih: index
                anchors.centerIn: parent
            }
        }
    }
    function load(j){
        for(var i=0;i<12;i++){
            xHousess.children[i].rotation=360-(360-j.ph['h1'].gdec)-j.pc['c'+i].gdec
        }
    }
}