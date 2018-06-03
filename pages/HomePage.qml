import Qb 1.0
import Qb.Core 1.0
import QtQuick 2.10


PageI{
    id: pageHome
    title: "Home"

    function refreshDataModel(){
        objDataModel.clear();
        var pages = objPackReader.getList("/pages");
        //console.log(pages)
        if(pages){
            for(var i=0;i<pages.length;++i){
                var page = pages[i];
                if(page.indexOf(".qmlc") ===-1 && page.indexOf(".jsc")===-1){
                    if(page !== "HomePage.qml" && page !== "PageI.qml" && page !== "PageTI.qml"){
                        objDataModel.append({"name":page})
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        refreshDataModel();
    }

    ListModel{
        id: objDataModel
    }

    QbAppPackageReader{
        id: objPackReader
        Component.onCompleted: {
            objPackReader.setAppId(pageHome.appId)
        }
    }

    ListView{
        id: objDataView
        anchors.fill: parent
        model: objDataModel

        delegate: Rectangle{
            id: objDataRect
            property color textColor: "black"
            width: objDataView.width
            height: QbCoreOne.scale(50)
            color: index%2==0?"lightblue":"lightyellow"

            Text{
                anchors.leftMargin: QbCoreOne.scale(10)
                anchors.fill: parent
                verticalAlignment: Text.AlignVCenter
                text: name
                color: objDataRect.textColor
            }

            MouseArea{
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    //pageHome.appJS.addPage(name);
                    pageHome.appJSC.addPage(name);
                }
                onEntered: {
                    objDataRect.textColor = "red";
                }
                onExited: {
                    objDataRect.textColor = "black";
                }
            }
        }
    }
}
