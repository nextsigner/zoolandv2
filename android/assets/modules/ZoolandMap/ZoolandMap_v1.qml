import QtQuick
import QtQuick.Controls
import ZoolandMap.Zm 1.0
Rectangle {
    id: r
    width: parent ? parent.width : 400
    height: width
    color: '#333'
    border.width: 4
    border.color: 'yellow'
    clip: true
    property alias zm: zm
    property int fs: 50
    property int wrz: r.fs*2

    //Status
    property int currentIndexSign: -1



    Flickable {
        id: flick
        anchors.fill: parent
        contentWidth: container.width * container.scale
        contentHeight: container.height * container.scale
        boundsBehavior: Flickable.StopAtBounds

        // Si el error persiste, podemos comentar estas dos líneas
        // para probar si el resto del zoom funciona.
        ScrollBar.vertical: ScrollBar { active: true }
        ScrollBar.horizontal: ScrollBar { active: true }

        Rectangle {
            id: container
            width: r.width
            height: r.height
            color: "transparent"
            transformOrigin: Item.Center

            // --- TU CONTENIDO ---
            Rectangle {
                anchors.centerIn: parent
                width: parent.width * 0.7
                height: width
                color: "black"
                border.width: 1
                border.color: 'red'
                radius: 10
                Text {
                    anchors.centerIn: parent
                    text: "Zooland Map\nQt 6.11.0"
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                }
            }
            Zm{
                id: zm
                width: parent.width
                height: parent.height
                wrz: r.wrz
            }
        }

        PinchHandler {
            id: pinchHandler
            target: container
            minimumScale: 0.5
            maximumScale: 8.0
        }

        WheelHandler {
            id: wheelHandler
            target: container
            acceptedModifiers: Qt.ControlModifier
            onWheel: (event)=> {
                let scaleStep = 0.1
                let delta = event.angleDelta.y > 0 ? (1 + scaleStep) : (1 - scaleStep);
                let newScale = container.scale * delta;
                if (newScale >= 0.5 && newScale <= 8.0) {
                    container.scale = newScale;
                }
            }
        }
    }
}