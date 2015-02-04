import QtQuick 2.1
import Sailfish.Silica 1.0

Page {
    id: page
    property string uri: ""
    property string thread: ""
    property string board: ""

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
       text: qsTr("Forward")
       onClicked: pageStack.replace(Qt.resolvedUrl("Newpost.qml"), {board: board, thread: thread} )
       anchors {
           bottom: parent.bottom
       }
    }
}
