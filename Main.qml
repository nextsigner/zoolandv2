import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material

import swe 1.0
import unik.Unik 1.0
import Qt.labs.settings

import ZoolandMap 1.0

ApplicationWindow {
    id: r
    width: Screen.width
    height: Screen.height
    visible: true
    visibility: 'Maximized'
    title: 'ZoolAnd'
    color: 'black'
    property alias app: r
    //property var zoolMap
    property bool dev: false
    property int fs: Screen.width*0.05

    property int modo: 0
    property string uFilePathLoaded: ''
    property var currentJson

    property var aSigns: ['Aries', 'Tauro', 'Géminis', 'Cáncer', 'Leo', 'Virgo', 'Libra', 'Escorpio', 'Sagitario', 'Capricornio', 'Acuario', 'Piscis']
    property var aSignsEnergy: ['Ariana', 'Taurina', 'Geminiana', 'Canceriana', 'Leonina', 'Virginiana', 'Libriana', 'Escorpiana', 'Sagitariana', 'Capricorniana', 'Acuariana', 'Pisciana']
    property var aSignsLowerStyle: ['aries', 'tauro', 'geminis', 'cancer', 'leo', 'virgo', 'libra', 'escorpio', 'sagitario', 'capricornio', 'acuario', 'piscis']
    property var aBodies: ['Sol', 'Luna', 'Mercurio', 'Venus', 'Marte', 'Júpiter', 'Saturno', 'Urano', 'Neptuno', 'Plutón', 'N.Sur', 'N.Norte', 'Quirón', 'Selena', 'Lilith', 'Pholus', 'Ceres', 'Pallas', 'Juno', 'Vesta']
    property var aBodiesFiles: ['sol', 'luna', 'mercurio', 'venus', 'marte', 'jupiter', 'saturno', 'urano', 'neptuno', 'pluton', 'nodo_sur', 'nodo_norte', 'quiron', 'selena', 'lilith', 'pholus', 'ceres', 'pallas', 'juno', 'vesta']
    property var objSignsNames: ['ari', 'tau', 'gem', 'cnc', 'leo', 'vir', 'lib', 'sco', 'sgr', 'cap', 'aqr', 'psc']
    property var  aIndexSweBodies: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 11, 11, 15, 57, 12, 16, 17, 18, 19, 20]


    FontLoader {id: fontAwosome;source: "assets:/fonts/fontawesome-webfont.ttf";}
    Unik{id: u}
    Swe{id: swe}
    Settings{
        id: apps
        fileName: './'+r.title+'.cfg'
        property bool showZoolandMap: false
        property bool showAllDegreeData: false
    }
    onModoChanged: {
        if(modo===1){
            let fd = u.getFile(r.uFilePathLoaded)

            try {
                let j = JSON.parse(fd).params
                let a=['Seleccionar']
                for(var i=0;i<120;i++){
                    a.push('Año: '+parseInt(j.a+i+1)+' Edad: '+parseInt(i+1)+' años')
                }
                cbAniosRS.model=a
                //let jf = getSweJson(j.a, j.m, j.d, j.h, j.min, j.gmt, j.lon, j.lat, j.alt, 'T')
                //r.currentJson=jf
                s += getList(jf)
                txt.text = s
            } catch(e) {
                console.log("Error parseando JSON: ", e)
            }
        }
    }
    onCurrentJsonChanged: {
        if(zoolMap)zoolMap.zm.load(currentJson)
    }
    Rectangle{
        id: xApp
        width: parent.width
        height: parent.height
        color: 'transparent'
        border.width: 0
        border.color: 'blue'
        clip: true
        Flickable{
            anchors.fill: parent
            contentWidth: parent.width
            contentHeight: col.height+r.fs*10//txt.contentHeight+r.fs*3
            Column{
                id: col
                spacing: r.fs
                anchors.horizontalCenter: parent.horizontalCenter
                Rectangle{
                    id: xTop
                    width: xApp.width
                    height: col0.height+r.fs*0.5
                    color: 'transparent'
                    border.width: 1
                    border.color: 'white'
                    Column{
                        id: col0
                        spacing: r.fs//*0.25
                        anchors.centerIn: parent
                        Row{
                            spacing: r.fs*0.5
                            anchors.horizontalCenter: parent.horizontalCenter
                            Button{
                                text: '\uf015'
                                width: r.fs*3
                                font.pixelSize: r.fs
                                font.family: fontAwosome.name
                                onClicked: {
                                    r.modo=0
                                    let s='Inicio!'
                                    txt.text=s
                                }
                            }
                            Button{
                                text: 'Rev. Solar'
                                width: r.fs*6
                                font.pixelSize: r.fs
                                font.family: fontAwosome.name
                                visible: r.uFilePathLoaded!==''
                                onClicked: {
                                    r.modo=1
                                }
                            }
                            Button{
                                text: '\uf059'
                                width: r.fs*3
                                font.pixelSize: r.fs
                                font.family: fontAwosome.name
                                onClicked: {
                                    let s=getAyuda()
                                    txt.text=s
                                }
                            }
                        }
                        Row{
                            spacing: r.fs*0.5
                            anchors.horizontalCenter: parent.horizontalCenter
                            Button{
                                text: 'Crear Nuevo'
                                font.pixelSize: r.fs
                                onClicked: form.visible=true
                            }
                            Button{
                                text: 'Editar'
                                font.pixelSize: r.fs
                                visible: r.uFilePathLoaded!==''
                                onClicked: {
                                    form.loadForEdit(r.uFilePathLoaded)
                                }
                            }
                            Button{
                                text: 'Eliminar'
                                font.pixelSize: r.fs
                                visible: r.uFilePathLoaded!==''
                                onClicked: {
                                    u.deleteFile(r.uFilePathLoaded)
                                    if(!u.fileExist(r.uFilePathLoaded)){
                                        txt.text=''
                                        txtNot.text='Archivo '+cbArchivos.currentText+' eliminado.'
                                        r.uFilePathLoaded=''
                                        updateFileList()
                                    }else{
                                        txtNot.text='Error al eliminar el archivo.'
                                    }
                                }
                            }
                        }
                        Row{
                            spacing: r.fs*0.5
                            anchors.horizontalCenter: parent.horizontalCenter
                            Text{
                                id: tit1
                                text: 'Archivo:'
                                color: 'white'
                                anchors.verticalCenter: parent.verticalCenter
                            }
                            ComboBox {
                                id: cbArchivos
                                width: xApp.width - tit1.contentWidth - r.fs*2
                                height: r.fs * 2
                                currentIndex: 0

                                // 1. Texto del campo principal (lo que se ve cuando está cerrado)
                                contentItem: Rectangle {
                                    color: 'black'
                                    border.width: 1
                                    border.color: 'white'
                                    clip: true

                                    Text {
                                        anchors.centerIn: parent
                                        // Usamos el id del ComboBox para obtener el texto actual
                                        text: (''+cbArchivos.displayText.split('/')[cbArchivos.displayText.split('/').length-1]).replace(/_/g, ' ').replace('.json', '')
                                        // Ajustamos el tamaño de fuente; '100' era demasiado grande para la mayoría de pantallas
                                        font.pixelSize: r.fs * 1.2
                                        color: "white"
                                        verticalAlignment: Text.AlignVCenter
                                        //horizontalAlignment: Text.AlignHCenter
                                        Component.onCompleted: {
                                            /*let nom = cbArchivos.model[cbArchivos.currentIndex]
                                        let m0 = nom.split('/')
                                        let nom2 = m0[m0.length-1]
                                        nom2 = nom2.replace(/_/g, ' ').replace('.json', '')
                                        text=nom2*/
                                        }
                                    }
                                }

                                // 2. Elementos de la lista desplegable
                                delegate: ItemDelegate {
                                    width: cbArchivos.width
                                    height: cbArchivos.height // Aseguramos que el alto coincida para Android

                                    contentItem: Text {
                                        // Importante: modelData es la forma correcta de acceder al texto del modelo
                                        text: modelData
                                        color: cbArchivos.currentIndex === index ? "#00AAFF" : "white"
                                        font.pixelSize: r.fs
                                        elide: Text.ElideRight
                                        verticalAlignment: Text.AlignVCenter
                                        Component.onCompleted: {
                                            let nom = modelData
                                            let m0 = nom.split('/')
                                            let nom2 = m0[m0.length-1]
                                            nom2 = nom2.replace(/_/g, ' ').replace('.json', '')
                                            text=nom2
                                        }
                                    }

                                    background: Rectangle {
                                        color: highlighted ? "#333333" : "black"
                                    }

                                    highlighted: cbArchivos.highlightedIndex === index
                                }

                                // 3. Tu lógica de procesamiento de JSON (se mantiene igual)
                                onCurrentIndexChanged: {
                                    if (currentIndex <= 0 || !model) return;

                                    let nom = model[currentIndex]
                                    let m0 = nom.split('/')
                                    let nom2 = m0[m0.length-1]
                                    nom2 = nom2.replace(/_/g, ' ').replace('.json', '')
                                    getDataFromFile(model[currentIndex], nom2)
                                    return

                                    let s = '\nArchivo: ' + nom2 + '\n\n'
                                    let fd = u.getFile(model[currentIndex])

                                    try {
                                        let j = JSON.parse(fd).params
                                        let jf = getSweJson(j.a, j.m, j.d, j.h, j.min, j.gmt, j.lon, j.lat, j.alt, 'T')
                                        r.currentJson=jf
                                        s += getList(jf)
                                        txt.text = s
                                    } catch(e) {
                                        console.log("Error parseando JSON: ", e)
                                    }
                                }
                            }

                        }
                        Row{
                            spacing: r.fs*0.5
                            anchors.horizontalCenter: parent.horizontalCenter
                            visible: r.modo==1
                            Text{
                                id: tit2
                                text: 'Año de\nRev. Solar:'
                                color: 'white'
                                anchors.verticalCenter: parent.verticalCenter
                            }
                            ComboBox {
                                id: cbAniosRS
                                width: xApp.width - tit1.contentWidth - r.fs*2
                                height: r.fs * 2
                                currentIndex: 0

                                // 1. Texto del campo principal (lo que se ve cuando está cerrado)
                                contentItem: Rectangle {
                                    color: 'black'
                                    border.width: 1
                                    border.color: 'white'
                                    clip: true

                                    Text {
                                        anchors.centerIn: parent
                                        // Usamos el id del ComboBox para obtener el texto actual
                                        text: cbAniosRS.model[cbAniosRS.currentIndex]
                                        // Ajustamos el tamaño de fuente; '100' era demasiado grande para la mayoría de pantallas
                                        font.pixelSize: r.fs * 1.2
                                        color: "white"
                                        verticalAlignment: Text.AlignVCenter
                                        //horizontalAlignment: Text.AlignHCenter

                                    }
                                }

                                // 2. Elementos de la lista desplegable
                                delegate: ItemDelegate {
                                    width: cbAniosRS.width
                                    height: cbAniosRS.height // Aseguramos que el alto coincida para Android

                                    contentItem: Text {
                                        // Importante: modelData es la forma correcta de acceder al texto del modelo
                                        text: modelData
                                        color: cbAniosRS.currentIndex === index ? "#00AAFF" : "white"
                                        font.pixelSize: r.fs
                                        elide: Text.ElideRight
                                        verticalAlignment: Text.AlignVCenter
                                    }
                                    background: Rectangle {
                                        color: highlighted ? "#333333" : "black"
                                    }
                                    highlighted: cbArchivos.highlightedIndex === index
                                }

                                // 3. Tu lógica de procesamiento de JSON (se mantiene igual)
                                onCurrentIndexChanged: {
                                    if (currentIndex <= 0 || !model) return;
                                    let j=r.currentJson
                                    let a=j.params.a+currentIndex
                                    let arrayRetornoSolar=swe.getSolarReturn(j.pc.c0.gdec, a, j.params.m, j.params.d, j.params.gmt);

                                    let jsRS=getSweJson(arrayRetornoSolar[0], arrayRetornoSolar[1], arrayRetornoSolar[2], arrayRetornoSolar[3], arrayRetornoSolar[4], j.params.gmt, j.params.lon, j.params.lat, j.params.alt, j.params.hsys)
                                    txt.text='Revolución Solar del año'+a+'\n'
                                    txt.text+='\n\nAtención! Si ahora presionas el botón "Enviar a IA", la consulta se hará sobre la Revolución Solar, no sobre la lectura de la Carta Natal.\n\n'
                                    txt.text+=getList(jsRS)
                                    txt.text+='\nCarta Natal\n'
                                    txt.text+=getList(r.currentJson)
                                    botEnviarIA.anioRs=a
                                }
                            }

                        }
                    }
                }
                Item{
                    id: xZoolandMap
                    width: Screen.width
                    height: width
                    //visible: apps.showZoolandMap
                    ZoolandMap{
                        id: zoolMap
                        fs:r.fs
                        visible: r.uFilePathLoaded!==''
                    }
                }
                Text{
                    id: txt
                    text: 'Selecciona un archivo'
                    width: Screen.width-r.fs
                    font.pixelSize: r.fs
                    color: 'white'
                    wrapMode: Text.WordWrap
                    anchors.horizontalCenter: parent.horizontalCenter
                    //anchors.centerIn: parent
                }
                Row{
                    spacing: r.fs
                    anchors.horizontalCenter: parent.horizontalCenter
                    Button{
                        id: botEnviarIA
                        text: 'Enviar a IA'
                        property int anioRs: 0
                        //property var j: ({})
                        onClicked: {
                            //txtNot.text='Texto copiado.'
                            //clipboard.setText(getIACons())
                            let textoAEnviar = ''
                            if(r.modo===1){
                                let j=r.currentJson
                                let arrayRetornoSolar=swe.getSolarReturn(j.pc.c0.gdec, botEnviarIA.anioRs, j.params.m, j.params.d, j.params.gmt);

                                let jsRS=getSweJson(arrayRetornoSolar[0], arrayRetornoSolar[1], arrayRetornoSolar[2], arrayRetornoSolar[3], arrayRetornoSolar[4], j.params.gmt, j.params.lon, j.params.lat, j.params.alt, j.params.hsys)
                                //txt.text=JSON.stringify(jsRS, null, 2)
                                textoAEnviar = getIAConsRS(botEnviarIA.anioRs, jsRS)
                            }else{
                                textoAEnviar = getIACons()
                            }
                            AndroidShare.shareToGemini(textoAEnviar)
                            txtNot.text='Se envió la consulta hacia la IA'
                        }
                    }
                    Button{
                        id: botCopiarIA
                        text: 'Copiar para IA'
                        onClicked: {
                            if(r.modo===1){
                                let j=r.currentJson
                                let arrayRetornoSolar=swe.getSolarReturn(j.pc.c0.gdec, botEnviarIA.anioRs, j.params.m, j.params.d, j.params.gmt);

                                let jsRS=getSweJson(arrayRetornoSolar[0], arrayRetornoSolar[1], arrayRetornoSolar[2], arrayRetornoSolar[3], arrayRetornoSolar[4], j.params.gmt, j.params.lon, j.params.lat, j.params.alt, j.params.hsys)
                                //txt.text=JSON.stringify(jsRS, null, 2)
                                let textACopiar = getIAConsRS(botEnviarIA.anioRs, jsRS)
                                clipboard.setText(textACopiar)
                            }else{
                                clipboard.setText(getIACons())
                            }
                            txtNot.text='Texto copiado.'

                        }
                    }
                }
                Rectangle{
                    width: r.width
                    height: r.fs*8
                    color: 'transparent'
                    Rectangle{
                        id: fondoToque
                        anchors.fill: parent
                        opacity: 0.0
                        Behavior on opacity{NumberAnimation{duration: 150}}
                        onOpacityChanged: {
                            if(opacity===1.0)opacity=0.0
                        }
                    }
                    MouseArea{
                        anchors.fill: parent
                        property int toques: 0
                        onClicked: {
                            toques++
                            fondoToque.opacity=1.0
                            if(toques>=3){
                                r.dev=true
                                toques=-1
                            }
                            if(toques===0){
                                r.dev=false
                            }
                        }
                    }
                    Column{
                        id: colDev
                        anchors.centerIn: parent
                        visible: r.dev
                        Text{
                            text:'<b>Modo Desarrollador</b>'
                            font.pixelSize: r.fs*1.2
                            color: 'white'
                        }
                        Row{
                            Button{
                                text: 'Ver Json'
                                font.pixelSize: r.fs
                                onClicked: {
                                    let fd=u.getFile(r.uFilePathLoaded)
                                    txt.text=JSON.stringify(JSON.parse(fd), null, 2)
                                }
                            }
                        }
                        Button{
                            text: 'Probar'
                            font.pixelSize: r.fs*0.5
                            onClicked: {
                                apps.showZoolandMap=true
                                let c='import QtQuick\n'
                                c+='import ZoolandMap 1.0\n'
                                c+='ZoolandMap{fs:'+r.fs+';}\n'
                                app.zoolMap=Qt.createQmlObject(c, xZoolandMap, 'zoolandmap-code')
                            }
                        }
                        Button{
                            text: 'Salir de Modo Desarrollador'
                            font.pixelSize: r.fs*0.5
                            onClicked: {
                                r.dev=false
                            }
                        }
                    }
                }
            }


        }


        /*Button{
            id: bot1
            text: 'Cargar'
            visible: false
            onClicked: {


                s+='Archivos: '+lista+'\n'
                txt.text=s
                txt.text+=getList()
            }
        }*/
        Form{id: form}
        Rectangle{
            id: xNot
            width: r.fs*10
            height: txtNot.contentHeight+r.fs*2
            color: 'black'
            border.width: 1
            border.color: 'white'
            opacity: txtNot.text===''?0.0:1.0
            anchors.centerIn: parent
            Timer{
                running: parent.visible
                repeat: false
                interval: 5000
                onTriggered: parent.visible=false
            }
            MouseArea{
                anchors.fill: parent
                onClicked: txtNot.text=''
            }
            Text{
                id: txtNot
                font.pixelSize: r.fs
                color: 'white'
                width: parent.width-r.fs
                wrapMode: Text.WordWrap
                anchors.centerIn: parent
            }
        }
    }

    Component.onCompleted: {

        let cp=u.currentFolderPath()
        let s=''
        //s+='Carpeta actual: '+cp+'\n'
        let appDataPath=u.getPath(4)
        s+='Carpeta de Datos: '+appDataPath+'\n'
        let fd=u.getFile(appDataPath+"/jsons/Ricardo.json")
        s+='Datos: '+fd+'\n'
        let listaAppFiles = u.getFileList(appDataPath, ["*"])
        s+='Lista de Archivos en Raiz: '+listaAppFiles+'\n'
        updateFileList()
    }
    function updateFileList(){
        let appDataPath=u.getPath(4)
        let lista = u.getFileList(appDataPath+"/jsons", ["*.json"])
        //txt.text=s
        let a=[]
        a.push('Seleccionar')
        for(var i=0;i<lista.length;i++){
            a.push(lista[i])
        }
        cbArchivos.model=a
    }
    function getSweJson(a, m, d, h, min, gmt, lon, lat, alt, hsys){
        if(Qt.platform.os==='linux'){
            swe.setSwePath(app.sweFolder)
        }if(Qt.platform.os==='android'){
            let appDataPath=u.getPath(4)
            swe.setSwePath(appDataPath+"/ephe")
            //swe.setSwePath("assets:/ephe")
        }else{
            swe.setSwePath(u.getPath(1)+'\\swe')
        }
        let jNN={}
        let j=JSON.parse(swe.getHousesPos(a, m, d, h, min, gmt, lon, lat, alt, hsys))
        //j.ph=
        j.pc={}
        let aHousesPos=getJsonPhToArray(j.ph)
        //log.lv('aHousesPos: '+aHousesPos)
        for(var i=0;i<r.aIndexSweBodies.length;i++){
            let jb=JSON.parse(swe.getBodiePosJson(r.aIndexSweBodies[i], a, m, d, h, min, gmt, lon, lat, alt))
            jb['nom']=r.aBodies[i]
            jb.ih=getHouseIndexFromArrayDegs(jb.gdec-j.ph.h1.gdec, aHousesPos)
            //jb['ih']=1
            jb.dh=jb.ih

            if(i===11){
                jNN=jb
            }
            j.pc['c'+i]=jb
        }
        j.pc.c10.gdec=j.pc.c11.gdec+180.00
        if(j.pc.c10.gdec>=360.00){
            j.pc.c10.gdec=j.pc.c10.gdec-360.00
        }
        j.pc.c10.gdeg=j.pc.c10.gdec
        j.pc.c10.ih=j.pc.c11.ih-6
        if(j.pc.c10.ih<=0){
            j.pc.c10.ih=j.pc.c10.ih+12
        }
        j.pc.c10.is=getIndexSign(j.pc.c10.gdec)
        j.params={}
        j.params.sd=''+d+'/'+m+'/'+a+' '+h+':'+min
        j.params.d=d
        j.params.m=m
        j.params.a=a
        j.params.h=h
        j.params.min=min
        j.params.gmt=gmt
        j.params.lat=lat
        j.params.lon=lon
        j.params.alt=alt
        j.params.hsys=hsys
        //log.lv('json: '+JSON.stringify(j, null, 2))
        //console.log('apps.url: '+apps.url)
        return j
    }
    function getJsonPhToArray(jsonPh){
        let a=[]
        for(var i=1;i<13;i++){
            //log.lv('--->:'+JSON.stringify(jsonPh['h'+i], null, 2))
            a.push(jsonPh['h'+i].gdec)
        }
        return a
    }
    function getHouseIndexFromArrayDegs(planetDegree, cusps_degrees) {
        const numCusps = cusps_degrees.length;

        // Aseguramos que el grado esté normalizado en el rango [0, 360)
        let degree = planetDegree % 360;
        if (degree < 0) {
            degree += 360;
        }

        // Iteramos a través de las 12 casas (el índice i representa la Casa i+1)
        for (let i = 0; i < numCusps; i++) {
            // La cúspide de inicio de la casa actual (Casa i+1)
            const startCusp = cusps_degrees[i];

            // La cúspide de fin de la casa actual, que es la cúspide de la siguiente casa (C i+2).
            // Usamos el operador % para envolver de C12 a C1.
            const endCusp = cusps_degrees[(i + 1) % numCusps];

            // La casa actual es el rango [startCusp, endCusp)

            if (startCusp <= endCusp) {
                // Caso 1: Rango normal que no cruza el punto 0/360.
                // Ej: C3 (19.74°) a C4 (52.47°)
                if (degree >= startCusp && degree < endCusp) {
                    return i;
                }
            } else {
                // Caso 2: Rango que cruza el punto 0/360 (envoltura).
                // Ej: C2 (351.03°) a C3 (19.74°).
                // Esto incluye grados mayores que C2 O menores que C3.
                if (degree >= startCusp || degree < endCusp) {
                    return i;
                }
            }
        }

        // En teoría, este código nunca debería ser alcanzado si las cúspides cubren 360 grados.
        // Devolvemos 0 como un valor predeterminado para el índice de la Casa 1.
        return 0;
    }
    function getIndexSign(gdec){
        let index=0
        let g=0.0
        for(var i=0;i<12+5;i++){
            g = g + 30.00
            if (g > parseFloat(gdec)){
                break
            }
            index = index + 1
        }
        return index
    }
    function getDDToDMS(D) {
        return {
            deg: 0 | (D < 0 ? (D = -D) : D),
            min: 0 | (((D += 1e-9) % 1) * 60),
            sec: (0 | (((D * 60) % 1) * 6000)) / 100,
        };
    }
    function getList(j){
        //let j=getSweJson(1975, 6, 20, 23, 4, -3, -69.25, -36.25, 0, 'T')
        let s=''//'Carpeta: '+swe.getSwePath()+'\n'
        //s+='cant pc: '+Object.keys(j.pc).length+'\n'
        //let ascIS=parseInt(j.asc/30)


        let strDegreeData=''
        //Ascendente
        let gms=getDDToDMS(j.ph['h1'].gdec)
        let is=getIndexSign(j.ph['h1'].gdec)
        let rsdeg=gms.deg-(30*is)
        strDegreeData='°'+rsdeg
        if(apps.strDegreeData){
            strDegreeData+=' \''+gms.min+' \'\''+gms.sec
        }
        s+='Ascendente (Casa 1): '+r.aSigns[is]+' '+strDegreeData+'\n'

        //Medio Cielo
        gms=getDDToDMS(j.ph['h10'].gdec)
        is=getIndexSign(j.ph['h10'].gdec)
        rsdeg=gms.deg-(30*is)
        strDegreeData='°'+rsdeg
        if(apps.strDegreeData){
            strDegreeData+=' \''+gms.min+' \'\''+gms.sec
        }
        s+='Medio Cielo (Casa 10): '+r.aSigns[is]+' '+strDegreeData+'\n'

        //Cuerpos
        for(var i=0;i<Object.keys(j.pc).length;i++){
            let ih=getHouseIndexFromArrayDegs(j.pc['c'+i].gdec, getJsonPhToArray(j.ph))+1
            gms=getDDToDMS(j.pc['c'+i].gdec)
            rsdeg=gms.deg-(30*j.pc['c'+i].is)
            strDegreeData='°'+rsdeg
            if(apps.strDegreeData){
                strDegreeData+=' \''+gms.min+' \'\''+gms.sec
            }
            s+=''+r.aBodies[i]+' en '+r.aSigns[j.pc['c'+i].is]+' '+strDegreeData+' en Casa '+ih+'\n'
        }
        s+='\nCuspides de las Casas: \n'
        for(i=0;i<12;i++){
            gms=getDDToDMS(j.ph['h'+parseInt(i+1)].gdec)
            is=getIndexSign(j.ph['h'+parseInt(i+1)].gdec)
            rsdeg=gms.deg-(30*is)
            s+='Casa '+parseInt(i+1)+' en '+r.aSigns[is]+' °'+rsdeg+'\n'
        }
        s+='\n'

        //s+='\n\n'+JSON.stringify(j, null, 2)
        return s
    }
    function getDataFromFile(filePath, nom){
        if(nom==='Seleccionar')return
        let s = '\n\nArchivo: ' + nom + '\n\n'
        let fd = u.getFile(filePath)

        try {
            let j = JSON.parse(fd).params
            let jf = getSweJson(j.a, j.m, j.d, j.h, j.min, j.gmt, j.lon, j.lat, j.alt, 'T')
            r.currentJson=jf
            s += getList(jf)
            txt.text = s
            r.uFilePathLoaded=filePath
        } catch(e) {
            txt.text="Ocurrió un error al cargar el archivo de "+nom+"! :("
        }
    }
    function getAyuda(){
        let s='Aplicación ZoolAnd para cálculo y creación de mapas y datos astrológicos.'+'\n\n'
        s+='Esta aplicación fué creada por Ricardo Martín Pizarro'+'\n'
        s+='Con el Framework Qt OpenSource 6.11.0'+'\n'
        s+='SwissEph (Tablas astronómicas JPL proveidas por la NASA)'+'\n\n'
        s+='Código Fuente: http://github.com/nextsigner/zooland'+'\n\n'
        s+='Para más información, contactar con el programador por las siguientes vías:'+'\n'
        s+='Whatsapp: +54 9 11 38024370'+'\n'
        s+='E-Mail: qtpizarro@gmail.com'+'\n'
        s+='YouTube: AstrólogoRicardoMartín'+'\n'
        s+='Instagram: RicardoMartínPizarro'+'\n'
        s+='Facebook: Ricardo Martín Pizarro'+'\n\n'
        s+='Buenos Aires Argentina - 2026'+'\n'
        return s
    }
    function getIACons(){
        let s=''
        s+='Consulta Astrológica. Dime cómo se manifiesta las siguientes influencias astrológicas de una persona nacida con la siguiente carta natal. De momento solo dime sobre el sol y al final recuerdame que debo escribir siguiente o s para ir interpretando las manifestaciones de los demás cuerpos astrológicos listados. Sobre cada cuerpo debes decirme 10 manifestaciones positivas y 10 negativas. Enfócate en interpretarlo desde el siguiente punto de vista,  Psicología, Autoconocimiento, útil para el ámbito de ralación de pareja, entorno cercan, familiar, laboral y social. Lista: '
        s+=getList(r.currentJson)+'\n'
        s+='\nTe en cuenta si hay algún cuerpo astrológico cerca o encima de alguna de las cúspides de las casas para interpretarlo correctamente con mayor precisión.\n'
        s+='Responde de forma puramente narrativa y con lenguaje fluido. Estoy trabajando con manos libres y escucharé tu respuesta por el auricular, así que evita por completo las listas, tablas, asteriscos o códigos. Organiza la información en párrafos continuos que sean fáciles de seguir auditivamente mientras realizo otras tareas. Debes estar atento a que yo pueda realizar consultas por medio tambien de audio por el micrófono. No cominences con la lectura hasta que yo no te haga mensión de que ya te estoy escuchando. Para avisarte te diré -te escucho-, -comineza- o algo similar.'
        return s
    }
    function getIAConsRS(a, j){
        let s=''
        s+='Consulta Astrológica para una lectura e interpretación de una Revolución Solar. Te aportaré los datos listados de los cuerpos de la carta natal y luego los cuerpos del mapa correspondienta al año '+a+'. No interpretes la carta natal, enfócate en interpretar la revolución solar correspondiente con esta carta natal. Dime cómo se manifiesta las siguientes influencias astrológicas de una persona, ya sea en si mismo, en su vida, en su entorno, con la siguente revolucion solar. . En este contexto de interpretación de retorno solar, dime principalmente la incidencia o impacto del Ascendente, Sol y Luna, luego, si hay otros cuerpos que estén generando una mayor influencia, con la relevancia que amerita ser mencionada, menciónalo. Sobre cada factor, Ascendente, Sol, Luna y otros debes decirme 10 manifestaciones positivas y 10 negativas. Enfócate en interpretarlo desde el siguiente punto de vista,  Psicología, eventos que o contextos pueden presentarse, útil para el ámbito de ralación de pareja, entorno cercan, familiar, laboral y social.\nLista de cuerpos de la Carta Natal: '
        s+=getList(r.currentJson)+'\n'
        s+='Lista de cuerpos de la Revolución Solar del año '+a+': '
        s+=getList(j)+'\n'
        s+='\nTe en cuenta si hay algún cuerpo astrológico cerca o encima de alguna de las cúspides de las casas para interpretarlo correctamente con mayor precisión.\n'
        s+='Responde de forma puramente narrativa y con lenguaje fluido. Estoy trabajando con manos libres y escucharé tu respuesta por el auricular, así que evita por completo las listas, tablas, asteriscos o códigos. Organiza la información en párrafos continuos que sean fáciles de seguir auditivamente mientras realizo otras tareas. Debes estar atento a que yo pueda realizar consultas por medio tambien de audio por el micrófono. No cominences con la lectura hasta que yo no te haga mensión de que ya te estoy escuchando. Para avisarte te diré -te escucho-, -comineza- o algo similar.'
        return s
    }
}
