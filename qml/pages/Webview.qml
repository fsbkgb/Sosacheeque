import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page
    property string path: ""
    property string borda: ""
    SilicaWebView {
        id: webview
        url: "https://2ch.hk/"+borda+"/"+path
        anchors{
            fill: parent
            topMargin: Theme.paddingLarge * 4
        }
    }
}
