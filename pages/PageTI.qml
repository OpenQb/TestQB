import Qb 1.0
import Qb.Core 1.0
import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.3

PageI{
    id: objPageTI
    title: "PageTI"
    property bool isRunningAction: false
    property var actionList: []

    topBar:Item{
            Label{
                anchors.fill: parent
                text: objPageTI.title
                font.bold: true
                verticalAlignment: Label.AlignVCenter
            }

            Item{
                anchors.right: parent.right
                height: parent.height
                width: parent.height

                Rectangle{
                    width: parent.width*0.60
                    height: width
                    anchors.centerIn: parent
                    color: objPageTI.appJS.theme.secondary
                    radius: width/2.0
                    property color textColor: objPageTI.appJS.theme.textColor(objPageTI.appJS.theme.secondary)
                    Text{
                        anchors.fill: parent
                        anchors.centerIn: parent
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        text: QbMF3.icon("mf-clear_all")
                        font.family: QbMF3.family
                        color: parent.textColor
                    }

                    MouseArea{
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: {
                            var c = objPageTI.appJS.theme.tetradicColor(objPageTI.appJS.theme.primary)[2]
                            parent.color = c;
                            parent.textColor = objPageTI.appJS.theme.textColor(c);
                        }
                        onExited: {
                            parent.color = objPageTI.appJS.theme.secondary;
                            parent.textColor = objPageTI.appJS.theme.textColor(objPageTI.appJS.theme.secondary);
                        }

                        onClicked: {
                            objPageTI.clearLog();
                        }
                    }
                }
            }
        }

    function addTask(name,callable){
        objPageTI.actionList.push(callable);
        objModel.append({"name":name});
    }

    function getTask(index){
        return objPageTI.actionList[index];
    }

    function addLog(t,c){
        if(c === undefined || c===null) c = "black";
        objLogBrowser.append("<font color=\""+c+"\">"+t+"</font><br/>");
    }

    function addGreenLog(t){
        addLog(t,"green");
    }
    function addRedLog(t){
        addLog(t,"red");
    }

    function clearLog(){
        objLogBrowser.clear();
    }

    function disableOtherTask(){
        objPageTI.isRunningAction = true;
    }

    function enableOtherTask(){
        objPageTI.isRunningAction = false;
    }


    ListModel{
        id: objModel;
    }

    Rectangle{
        id: objTestButtons
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: QbCoreOne.scale(160)
        color: "lightgrey"
        GridView{
            id: objButtonGrids
            anchors.fill: parent
            model: objModel
            cellWidth: objButtonGrids.width
            cellHeight: QbCoreOne.scale(50)
            delegate: Item{
                id: objDelegateButton
                width: objButtonGrids.width
                height: QbCoreOne.scale(50)
                Button{
                    anchors.centerIn: parent
                    width: parent.width
                    height: parent.height
                    text: name;
                    Material.background: appJS.theme.secondary
                    Material.foreground: appJS.theme.textColor(appJS.theme.secondary)
                    onClicked: {
                        if(!objPageTI.isRunningAction){
                            objPageTI.getTask(index)();
                        }
                    }
                }
            }
        }
    }

    Rectangle{
        id: objLogArea
        anchors.top: parent.top
        anchors.left: objTestButtons.right
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        color: "lightyellow"
        Flickable {
             id: objFlickArea
             anchors.fill: parent

             contentWidth: objLogBrowser.paintedWidth
             contentHeight: objLogBrowser.paintedHeight
             clip: true

             function ensureVisible(r)
             {
                 if (contentX >= r.x)
                     contentX = r.x;
                 else if (contentX+width <= r.x+r.width)
                     contentX = r.x+r.width-width;
                 if (contentY >= r.y)
                     contentY = r.y;
                 else if (contentY+height <= r.y+r.height)
                     contentY = r.y+r.height-height;
             }

             TextEdit {
                 id: objLogBrowser
                 width: objFlickArea.width
                 focus: true
                 wrapMode: TextEdit.Wrap
                 onCursorRectangleChanged: objFlickArea.ensureVisible(cursorRectangle)
                 readOnly: true
                 textFormat: TextEdit.RichText
             }
         }


        Item {
            id: objScrollBar
            width: QbCoreOne.scale(8)
            height: objFlickArea.height
            anchors.right: objFlickArea.right
            anchors.top: objFlickArea.top
            opacity: 1
            clip: true
            visible: objScrollBar.height!=objHandle.height
            property real position: objFlickArea.visibleArea.yPosition
            property real pageSize: objFlickArea.visibleArea.heightRatio

            Rectangle {
                id: objScrollBarBack
                anchors.fill: parent
                color: "white"
                opacity: 0.3
            }
            Rectangle {
                id: objHandle
                x: 0
                y: objScrollBar.position * (objScrollBar.height)
                width: (objScrollBar.width)
                height: (objScrollBar.pageSize * (objFlickArea.height))
                //radius: (width/2)
                color: "black"
                opacity: 0.7
            }
        }

    }

}
