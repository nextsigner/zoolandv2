import QtQuick 2.0
import ZoolElementsView.ZoolGroupElementItems 1.0
import ZoolElementsView.ZoolGroupElementItemsPlanets 1.0
import QtCore

Rectangle{
    id: r
    width: parent.width//colZoolGroupElementItems.width+colZoolGroupElementItemsPlanets.width//+app.fs
    height: parent.height   //colZoolGroupElementItems.height+app.fs
    anchors.right: parent.right
    anchors.rightMargin: 0-width*0.75
    border.width: 10
    border.color:'yellow'
    color: 'transparent'
    anchors.centerIn: parent
    property int fs: app.fs*10//2*s.zoom
    property alias settings: s
    property bool showBack: false
    property url uItemGrabber
    property real zoom: s.zoom
    transform: Scale {
        id: tform2
        xScale: 0.25
        yScale: 0.25
    }
    Settings{
        id: s
        property real zoom: 1.0
    }

    Row{
        anchors.centerIn: parent
        Column{
            id: colZoolGroupElementItemsPlanets
            spacing: app.fs*0.5
            anchors.top: parent.top
            //opacity: !zm.capturing?0.0:1.0
            //Behavior on opacity{NumberAnimation{duration:!zm.capturing?250:0}}
            ZoolGroupElementItemsPlanets{id: groupFrontPlanets; fs: r.fs; showTitle: r.showBack}
            ZoolGroupElementItemsPlanets{id: groupBackPlanets; fs: r.fs; isBack: true; showTitle: r.showBack; visible: r.showBack}
        }
        Column{
            id: colZoolGroupElementItems
            spacing: app.fs*0.5
            anchors.verticalCenter: parent.verticalCenter
            ZoolGroupElementItems{id: groupFront; fs: r.fs; showTitle: r.showBack}
            //ZoolGroupElementItems{id: groupBack; fs: r.fs; isBack: true; visible: r.showBack; showTitle: r.showBack}
        }
    }
    function load(json){
            groupFront.load(json)
            //groupFrontPlanets.load(json)

    }
    function tooglePlanetsOpacity(){
        if(colZoolGroupElementItemsPlanets.opacity===0.0){
           colZoolGroupElementItemsPlanets.opacity=1.0
        }else{
            colZoolGroupElementItemsPlanets.opacity=0.0
        }
    }
}
