import QtQuick
import QtQuick.Controls
import ZoolandMap.Zm 1.0
import ZmButton 1.0

Rectangle {
    id: r
    width: parent ? parent.width : 400
    height: parent===xApp?xApp.height:width
    color: apps.backgroundColor
    border.width: 1
    border.color: apps.fontColor
    clip: !app.appRotated
    anchors.horizontalCenter: parent.horizontalCenter
    property alias zm: zm
    property int fs: 50
    property int wrz: r.fs*0.75
    property bool zoomingOrPaning: false

    //Bodies
    property int bodieSize: r.fs*0.75
    property color bodieColor: 'white'
    property int aspCircleWidth: -1
    property int posMaxInt: 0
    property int posMaxExt: 0

    //Houses
    property int wl: !app.appRotated?app.fs*0.1:2//app.fs*0.02
    property color cl: 'white'

    //Status
    property real signCircleRot: 0.0

    property int currentIndexBodie: -1
    property int currentIndexSign: -1
    property int currentIndexHouse: -1
    property string currentStrDdMmSs: '°0 \'0 \'\'0'
    property string currentStrDdMmSsExt: '°0 \'0 \'\'0'


    property int currentIndexBodieExt: -1
    property int currentIndexSignExt: -1
    property int currentIndexHouseExt: -1

    //Astrología
    property var aBodies: ['Sol', 'Luna', 'Mercurio', 'Venus', 'Marte', 'Júpiter', 'Saturno', 'Urano', 'Neptuno', 'Plutón', 'N.Sur', 'N.Norte', 'Quirón', 'Selena', 'Lilith', 'Pholus', 'Ceres', 'Pallas', 'Juno', 'Vesta']
    property var bodiesRes: ['sun', 'moon', 'mercury', 'venus', 'mars', 'jupiter', 'saturn', 'uranus', 'neptune', 'pluto', 's', 'n', 'hiron', 'selena', 'lilith', 'pholus', 'ceres', 'pallas', 'juno', 'vesta']



    onCurrentIndexBodieExtChanged: {
        let t=txt.text
        //txt.text='CurrentIndexBodieExt:'+currentIndexBodieExt+'\n'+t
    }
    MouseArea {
        acceptedButtons: Qt.LeftButton
        onDoubleClicked: r.resetView()
    }
    Timer{
        running: r.zoomingOrPaning
        repeat: false
        interval: 2500
        onTriggered: r.zoomingOrPaning=false
    }

    Flickable {
        id: flick
        anchors.fill: parent
        contentWidth: container.width * container.scale
        contentHeight: container.height * container.scale
        boundsBehavior: Flickable.StopAtBounds

        // Desactivamos el arrastre interactivo del Flickable para que
        // no entre en conflicto con nuestro DragHandler en Desktop
        interactive: false

        ScrollBar.vertical: ScrollBar { active: true }
        ScrollBar.horizontal: ScrollBar { active: true }
        TapHandler {
            acceptedButtons: Qt.LeftButton
            onDoubleTapped: r.resetView()
        }
        // Rectangle {
        //     id: container
        //     width: r.width
        //     height: r.height
        //     color: "transparent"
        //     transformOrigin: Item.Center
        Rectangle {
            id: container
            width: r.width
            height: r.height
            color: "transparent"
            x: (parent.width-width)*0.5
            y: (parent.height-height)*0.5
            // CAMBIO: El origen arriba a la izquierda facilita el cálculo del desplazamiento
            transformOrigin: Item.TopLeft

            // --- SOLUCIÓN PARA DESKTOP ---
            DragHandler {
                id: dragHandler
                target: container
                // Al no definir acceptedModifiers, funciona con clic simple
                onActiveChanged: if (active) r.zoomingOrPaning = true
            }

            Zm {
                id: zm
                width: parent.width * 0.6
                height: parent.height * 0.6
                x: parent.width * 0.2
                y: parent.height * 0.2
                wrz: r.wrz
            }
        }

        PinchHandler {
            id: pinchHandler
            target: container
            // SE ELIMINÓ: property: "scale" (No existe en esta versión)

            minimumScale: 0.5
            maximumScale: 12.0

            // Bloqueamos la rotación si solo quieres zoom,
            // ya que el PinchHandler intenta rotar por defecto.
            minimumRotation: 0
            maximumRotation: 0

            onActiveChanged: {
                if (active) {
                    r.zoomingOrPaning = true
                }
            }
        }
        /*PinchHandler {
            id: pinchHandler
            target: container
            minimumScale: 0.5
            maximumScale: 12.0
            minimumRotation: 0
            maximumRotation: 0
            onScaleChanged: {
                r.zoomingOrPaning = true
            }
        }*/

        WheelHandler {
            id: wheelHandler
            target: container
            property: "scale" // Asegúrate de que NO tenga errores de ortografía
            acceptedModifiers: Qt.NoModifier
        }
        /*WheelHandler {
            id: wheelHandler
            target: container
            // Eliminamos la restricción de Qt.ControlModifier si quieres zoom libre
            // o lo dejamos si prefieres que el zoom solo sea con Control.
            acceptedModifiers: Qt.NoModifier
            onWheel: (event)=> {
                let scaleStep = 0.1
                let delta = event.angleDelta.y > 0 ? (1 + scaleStep) : (1 - scaleStep);
                let newScale = container.scale * delta;
                if (newScale >= 0.5 && newScale <= 12.0) {
                    container.scale = newScale;
                }
            }
        }*/
    }



    Rectangle{
        id: xTxtBodieSelected
        width: txtBodieSelected.contentWidth+app.fs*0.25
        height: txtBodieSelected.contentHeight+app.fs*0.25
        color: 'transparent'
        anchors.left: parent.left
        anchors.leftMargin: !app.appRotated?0:0-((xApp.width-r.width)*0.5)
        visible: r.currentIndexBodie>-1 && r.currentIndexSign>-1 && r.currentIndexHouse>-1
        Rectangle{
            anchors.fill: parent
            color: apps.backgroundColor
            border.width: 1
            border.color: apps.fontColor
            radius: app.fs*0.25
            opacity: 0.75
        }
        Text{
            id: txtBodieSelected
            text: '<b>'+r.aBodies[r.currentIndexBodie]+' '+app.aSigns[r.currentIndexSign]+' Casa '+parseInt(r.currentIndexHouse+1)+'</b><br>'+r.currentStrDdMmSs
            font.pixelSize: app.appRotated?app.fs*0.5:app.fs
            color: apps.fontColor
            anchors.centerIn: parent
        }
    }
    Rectangle{
        id: xTxtBodieSelectedExt
        width: txtBodieSelectedExt.contentWidth+app.fs*0.25
        height: txtBodieSelected.contentHeight+app.fs*0.25
        color: 'transparent'
        anchors.right: parent.right
        anchors.rightMargin: !app.appRotated?0:0-((xApp.width-r.width)*0.5)
        visible: r.currentIndexBodieExt>-1 && r.currentIndexSignExt>-1 && r.currentIndexHouseExt>-1
        Rectangle{
            anchors.fill: parent
            color: 'red'//apps.backgroundColor
            border.width: 1
            border.color: apps.fontColor
            radius: app.fs*0.25
            opacity: 0.75
        }
        Text{
            id: txtBodieSelectedExt
            text: '<b>'+r.aBodies[r.currentIndexBodieExt]+' '+app.aSigns[r.currentIndexSignExt]+' Casa '+parseInt(r.currentIndexHouseExt+1)+'</b><br>'+r.currentStrDdMmSsExt
            font.pixelSize: app.appRotated?app.fs*0.5:app.fs
            color: 'white'//apps.fontColor
            anchors.centerIn: parent
        }
    }
    Row{
        //parent: !app.appRotated?r:xApp
        //z:10000
        //z:!app.appRotated?xTxtBodieSelected.z+1:r.z+1
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.leftMargin: !app.appRotated?0:0-((xApp.width-r.width)*0.5)
        //Expandir Mapa
        ZmButton{
            text: '\uf07d'
            fs: !app.appRotated?app.fs*0.75:app.fs*0.35
            width:!app.appRotated?app.fs*1.5:app.fs*0.75
            isCuad: true
            onClicked:{
                if(zoolMap.parent===xApp){
                    zoolMap.parent=xZoolandMap
                }else{
                    zoolMap.parent=xApp
                }
            }
        }
        //Ver Elementos
        ZmButton{
            text: '\uf03a'
            fs: !app.appRotated?app.fs*0.75:app.fs*0.35
            width:!app.appRotated?app.fs*1.5:app.fs*0.75
            isCuad: true
            visible: app.uFilePathLoaded!==''
            anchors.verticalCenter: parent.verticalCenter
                onClicked: {
                //zoolElementsView.visible=!zoolElementsView.visible
                    xZEV.visible=!xZEV.visible
            }
        }
        //Ver MoveTime
        ZmButton{
            text: '\uf017'
            fs: !app.appRotated?app.fs*0.75:app.fs*0.35
            width:!app.appRotated?app.fs*1.5:app.fs*0.75
            isCuad: true
            opacity: zmt.visible?1.0:0.5
            onClicked:{
                zmt.visible=!zmt.visible
            }
        }
    }

    function resetView() {
        container.scale = 0.75
        //container.x = 0//+((container.parent.width-container.width)*0.5)
        //container.y = 0//+((container.parent.height-container.height)*0.5)
        container.x = 0-(container.parent.width-container.width)*0.5
        container.y = 0-(container.parent.height-container.height)*0.5
        // Si usas el Flickable para moverte, también podrías resetear su contenido
        flick.contentX = 0
        flick.contentY = 0
        //zm.x= zm.parent.width * 0.2
        //zm.y= zm.   parent.height * 0.2
    }
}