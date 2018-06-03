import Qb 1.0
import Qb.Core 1.0
import QtQuick 2.10

import "../UiUno" as UiUno
import "../appc.js" as AppJSC


UiUno.UiUnoPage{
    id: pageI
    title: "PageI"
    property var appJSC: AppJSC
    property string pageID: "PageI.qml"

    onPageClosing: {
        appJSC.removePage(pageID);
    }

    onPageCreated: {
        appJS.hideLoadingScreen();
    }
}
