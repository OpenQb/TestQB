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
        onProcessingChanged: {
            addLog("Processing changed: "+processing,"lightblue");
        }
    }

    function test_read_from_net(){
        pageFileIO.disableOtherTask();
        addLog("");
        addLog("== READ FROM NET ==","blue");
        var p1 = new QbPromise.Promise(function(res,rej){
            var statusMethod = function(n,c,m){
                objFileIO.onLoaded.disconnect(loadMethod);
                objFileIO.onStatus.disconnect(statusMethod);
                rej();
            }

            var loadMethod = function(data,pos){
                pageFileIO.addLog("JSON DATA","grey");
                pageFileIO.addGreenLog(data);
                objFileIO.onLoaded.disconnect(loadMethod);
                objFileIO.onStatus.disconnect(statusMethod);
                res();
            }
            objFileIO.setHost("http://ip-api.com");
            objFileIO.setTimeout(30);
            objFileIO.setPath("/json");
            objFileIO.onLoaded.connect(loadMethod);
            objFileIO.onStatus.connect(statusMethod);
            objFileIO.loadAll();

        }).finally(function(){
            pageFileIO.done();
            pageFileIO.enableOtherTask();
        });
    }

    function test_read_from_pack(){
        pageFileIO.disableOtherTask();
        addLog("");
        addLog("== READ FROM PACK ==","blue");
        var p1 = new QbPromise.Promise(function(res,rej){
            var statusMethod = function(n,c,m){
                objFileIO.onLoaded.disconnect(loadMethod);
                objFileIO.onStatus.disconnect(statusMethod);
                rej();
            }

            var loadMethod = function(data,pos){
                pageFileIO.addLog("JSON DATA","grey");
                pageFileIO.addGreenLog(data);
                objFileIO.onLoaded.disconnect(loadMethod);
                objFileIO.onStatus.disconnect(statusMethod);
                res();
            }
            objFileIO.setHost("appid://"+pageFileIO.appId);
            objFileIO.setPath("/app.json");
            objFileIO.onLoaded.connect(loadMethod);
            objFileIO.onStatus.connect(statusMethod);
            objFileIO.loadAll();

        }).finally(function(){
            pageFileIO.done();
            pageFileIO.enableOtherTask();
        });
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

        addLog("");
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
                objFileIO.onLoaded.disconnect(loadMethod);
                objFileIO.onStatus.disconnect(statusMethod);
                objFileIO.onSaved.disconnect(savedMethod);
                rej();
            }

            var loadMethod = function(data,pos){
                pageFileIO.addLog("Reading: "+data);
                if( String(data) === "1234567890") pageFileIO.addGreenLog("Success");
                else pageFileIO.addRedLog("Failure");
                objFileIO.onLoaded.disconnect(loadMethod);
                objFileIO.onStatus.disconnect(statusMethod);
                objFileIO.onSaved.disconnect(savedMethod);
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
