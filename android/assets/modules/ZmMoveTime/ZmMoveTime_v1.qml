import QtQuick

Rectangle {
    id: r
    width: parent.width
    height: 60
    color: "transparent"

    // --- Propiedades de Control de Fecha ---
    property date targetDate: new Date()
    property int mode: 0 // 0:Año, 1:Mes, 2:Día, 3:Hora, 4:Min
    readonly property var modeLabels: ["AÑO", "MES", "DÍA", "HORA", "MIN"]

    // Sensibilidad: define cuánto desplazamiento se necesita para cambiar 1 unidad.
    // Modo 0 (Año): 5% del límite. Resto (1,2,3,4): 1% del límite.
    readonly property real sensitivity: mode === 0 ? 0.05 : 0.01

    readonly property int limit: width * 0.4
    property int lastStep: 0 // Para trackear el cambio relativo

    property bool onlySetDate: false
    // Riel de guía
    Rectangle {
        width: parent.width * 0.9
        height: 2
        color: "white"
        opacity: 0.3
        anchors.centerIn: parent
    }

    Rectangle {
        id: handle
        width: parent.height * 0.7
        height: width
        color: dragHandler.active ? "red" : "white"
        radius: width * 0.1
        anchors.verticalCenter: parent.verticalCenter

        property real centerX: (r.width / 2) - (width / 2)
        x: centerX

        Text {
            id: txtLabel
            text: r.modeLabels[r.mode] + ": " + r.formatDisplay()
            color: apps.fontColor
            font.pixelSize: 12
            anchors.centerIn: parent
            //z: 2
            Rectangle{
                width: parent.contentWidth + 10 // app.fs*0.1
                height: parent.contentHeight + 5
                color: apps.backgroundColor
                radius: 3
                border.width: 1
                border.color: "black"
                anchors.centerIn: parent
                z: parent.z-1
            }
        }

        TapHandler {
            onTapped: {
                r.mode = (r.mode + 1) % 5
            }
        }

        Behavior on x {
            enabled: !dragHandler.active
            NumberAnimation { duration: 250; easing.type: Easing.OutBack }
        }

        DragHandler {
            id: dragHandler
            target: handle
            xAxis.minimum: handle.centerX - r.limit
            xAxis.maximum: handle.centerX + r.limit
            yAxis.enabled: false

            onActiveChanged: {
                if (!active) {
                    r.lastStep = 0
                    handle.x = handle.centerX
                }
            }

            onTranslationChanged: {
                if (active) {
                    let relativeX = handle.x - handle.centerX

                    // Calculamos el step basado en la sensibilidad dinámica
                    // Pixeles por paso = limit * sensibilidad (ej: 100px * 0.05 = cada 5px cambia 1 año)
                    let pixelsPerStep = r.limit * r.sensitivity
                    let currentStep = Math.trunc(relativeX / pixelsPerStep)

                    if (currentStep !== r.lastStep) {
                        let diff = currentStep - r.lastStep
                        updateDate(diff)
                        r.lastStep = currentStep
                    }
                }
            }
        }
    }

    function updateDate(delta) {
        let d = new Date(r.targetDate)

        if (r.mode === 0) d.setFullYear(d.getFullYear() + delta)
        else if (r.mode === 1) d.setMonth(d.getMonth() + delta)
        else if (r.mode === 2) d.setDate(d.getDate() + delta)
        else if (r.mode === 3) d.setHours(d.getHours() + delta)
        else if (r.mode === 4) d.setMinutes(d.getMinutes() + delta)

        r.targetDate = d
    }

    function formatDisplay() {
        let d = r.targetDate
        if (r.mode === 0) return d.getFullYear()
        if (r.mode === 1) return (d.getMonth() + 1)
        if (r.mode === 2) return d.getDate()
        if (r.mode === 3) return d.getHours().toString().padStart(2, '0') + "hs"
        if (r.mode === 4) return d.getMinutes().toString().padStart(2, '0') + "m"
        return ""
    }
}