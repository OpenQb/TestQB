import Qb 1.0
import Qb.Core 1.0
import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.3

PageTI{
    id: pageFileIO
    title: "FileIO"
    QbFileIO{
        id: objFileIO
    }

    onPageCreated: {
        /** Fill up the actionList with task **/
        pageFileIO.addTask("Test",function(){
            pageFileIO.addLog("Test");
        });

        pageFileIO.addTask("Test2",function(){
            pageFileIO.addGreenLog("Test 2");
        });
    }
}
