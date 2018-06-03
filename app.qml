import QtQuick 2.10

import Qb 1.0
import Qb.Core 1.0

import "./UiUno" as UiUno
import "./appc.js" as AppJSC


UiUno.UiUno{
    id: objAppUi
    appLogo: objAppUi.absoluteURL("/app.svg")
    dockColor: "black"
    dockLogoColor: "black"
    property var appJSC: AppJSC

    Component.onCompleted: {
        objAppUi.appJSC.addPage("HomePage.qml");
    }
}
