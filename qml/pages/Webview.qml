import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page
    property string uri: ""
    SilicaWebView {
        id: webview
        url: uri
        anchors{
            fill: parent
            topMargin: Theme.paddingLarge * 4
        }
    }
}
