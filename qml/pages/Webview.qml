import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page
    property string uri: ""
    property string tred: ""
    property string borda: ""
    SilicaWebView {
        id: webview
        url: uri
        anchors{
            fill: parent
            topMargin: Theme.paddingLarge * 4
            bottomMargin: Theme.paddingLarge * 4
        }
    }
    Button {
       text: "Продолжить"
       onClicked: pageStack.replace(Qt.resolvedUrl("Newpost.qml"), {borda: borda, tred: tred} )
       anchors {
           bottom: parent.bottom
       }
    }
}
