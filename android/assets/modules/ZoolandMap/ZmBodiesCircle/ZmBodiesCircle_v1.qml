import QtQuick
import ZoolandMap.ZmBodiesCircle.ZmBodie 1.0

Item{
    id: r
    height: width
    anchors.centerIn: parent
    property bool isBack: false
    property var aGdecsInt: []
    property var aGdecsExt: []

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
        r.aGdecsInt=[]
        r.aGdecsExt=[]
        if(!r.isBack){
            zoolMap.posMaxInt=0
        }else{
            zoolMap.posMaxExt=0
        }
        for(var i=0;i<zoolMap.aBodies.length;i++){
            xBodies.children[i].rotation=360-(360-j.ph['h1'].gdec)-j.pc['c'+i].gdec
            if(!r.isBack){
                r.aGdecsInt.push(j.pc['c'+i].gdec)
            }else{
                r.aGdecsExt.push(j.pc['c'+i].gdec)
            }
        }
        ordenarPosiciones()
    }
    function ordenarPosiciones(){
        let aGdecs
        if(!r.isBack){
            aGdecs=r.aGdecsInt
        }else{
            aGdecs=r.aGdecsExt
        }
        let maxPos=0
        let aBodiesPos=[]
        for(var i=0;i<aGdecs.length;i++){
            aBodiesPos.push(1)
            let objAs=xBodies.children[i]//getAs(i)
            objAs.pos=0
        }
        for(i=1;i<aGdecs.length;i++){
            for(var i2=i-1;i2<aGdecs.length;i2++){
                let haa=hayAlgoAhi(aGdecs[i], aGdecs[i2])
                if(haa && i!==i2){
                    //zpn.log('ordenando: '+aGdecs[i])
                    //zpn.log('haa '+zm.aBodies[i]+' '+zm.aBodies[i2])
                    aBodiesPos[i2]++
                    if(aBodiesPos[i2]>maxPos){
                        maxPos++
                    }
                }
            }
        }
        //zpn.log('aBodiesPos: '+aBodiesPos.join('\n'))
        for(i=0;i<aGdecs.length;i++){
            let objAs=xBodies.children[i]//getAs(i)
            objAs.pos=aBodiesPos[i]-1
        }
        for(i=1;i<aGdecs.length;i++){
            let objAs=xBodies.children[i]//getAs(i)
            for(i2=0;i2<aGdecs.length;i2++){
                let objAs2=xBodies.children[i2]//getAs(i2)
                //objAs.pos=aBodiesPos[i]-1
                let haa=hayAlgoAhi(aGdecs[i], aGdecs[i2])
                if(haa && i!==i2 && objAs.pos === objAs2.pos){
                    objAs.pos++
                }
            }
            if(objAs.pos>maxPos){
                maxPos=objAs.pos
            }
        }
        for(i=0;i<aGdecs.length;i++){
            objAs=xBodies.children[i]//getAs(i)
            if(objAs.pos+1>maxPos){
                maxPos++
            }
        }
        //maxPos++
        //zpn.log('maxPos: '+maxPos)
        if(!r.isBack){
            zoolMap.posMaxInt=maxPos
            //zm.currentMinPlanetsWidth=zm.objAI.width-(zm.planetSizeInt*zm.posMaxInt*2)-zm.objSignsCircle.w*2-zm.planetSizeInt
            //zm.setAreasWidth(true)
        }else{
            zoolMap.posMaxExt=maxPos
            //zm.setAreasWidth(false)
        }
    }
    function hayAlgoAhi(startDegree, secondStartDegree){
        const margen=10.00
        // Normalize degrees to be within the 0-360 range
        const normalize = (deg) => ((deg % 360) + 360) % 360;

        const normalizedStart = normalize(startDegree);
        const normalizedSecondStart = normalize(secondStartDegree);

        // Define the arcs
        const endDegree = normalize(normalizedStart + margen);
        const secondEndDegree = normalize(normalizedSecondStart + margen);

        // Check for overlap, handling the wrap-around case (end < start)
        const isOverlapping = (start1, end1, start2, end2) => {
            // Standard overlap check
            if (end1 >= start1 && end2 >= start2) {
                return (
                    (start1 >= start2 && start1 <= end2) ||
                    (end1 >= start2 && end1 <= end2) ||
                    (start2 >= start1 && start2 <= end1) ||
                    (end2 >= start1 && end2 <= end1)
                    );
            }

            // Overlap where the first arc wraps around (end1 < start1)
            if (end1 < start1) {
                return (
                    (start2 >= start1 || end2 <= end1) || // Second arc spans the wrap-around
                    (start2 >= start1 && start2 <= 360) || // Second arc starts in the first part
                    (end2 >= 0 && end2 <= end1) // Second arc ends in the second part
                    );
            }

            // Overlap where the second arc wraps around (end2 < start2)
            if (end2 < start2) {
                return (
                    (start1 >= start2 || end1 <= end2) || // First arc spans the wrap-around
                    (start1 >= start2 && start1 <= 360) || // First arc starts in the first part
                    (end1 >= 0 && end1 <= end2) // First arc ends in the second part
                    );
            }
        };

        return isOverlapping(normalizedStart, endDegree, normalizedSecondStart, secondEndDegree);
    }
}