import Qb 1.0
import QbEx 1.0
import Qb.Core 1.0
import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.3


PageTI{
    id: pageFileIO
    title: "FileIO"

    QbFileIO{
        id: objFileIO
        onStatus: {
            var t = "STATUS  {Number:"+n+"} {Context: "+context+"} {Message: "+message+"}";
            addLog(t,"lightblue");
        }
    }

    function test_write_local_file(){
        pageFileIO.disableOtherTask();
        var fileHost = pageFileIO.appJS.resolveDataPath("");
        var fileName = "/TestFile.txt";

        if(Qt.platform.os === "windows"){
            fileHost = "file:///"+fileHost;
        }
        else{
            fileHost = "file://"+fileHost;
        }


        addLog("== WRITE LOCAL FILE ==","blue");
        addLog("FilePath: "+fileHost+fileName);

        var p1 = new QbPromise.Promise(function(res,rej){
            objFileIO.setHost(fileHost);
            objFileIO.setPath(fileName);
            objFileIO.setOpenMode("w+");
            objFileIO.remove();

            var savedMethod = function(b){
                pageFileIO.addLog("Bytes written:"+b);
                objFileIO.onSaved.disconnect(savedMethod);
                objFileIO.load(0,b);
            };

            var statusMethod = function(n,c,m){
                objFileIO.onStatus.disconnect(statusMethod);
                rej();
            }

            var loadMethod = function(data,pos){
                pageFileIO.addLog("Reading: "+data);
                if( String(data) === "1234567890") pageFileIO.addGreenLog("Success");
                else pageFileIO.addRedLog("Failure");
                objFileIO.onLoaded.disconnect(loadMethod);
                res();
            }

            objFileIO.onLoaded.connect(loadMethod);
            objFileIO.onSaved.connect(savedMethod);
            objFileIO.onStatus.connect(statusMethod);

            pageFileIO.addLog("Writing: 1234567890")
            objFileIO.save("1234567890");
        }).finally(function(){
            objFileIO.remove();
            pageFileIO.enableOtherTask();
            pageFileIO.done();
        });

    }
}
