import QtQuick 2.0
import QtWebKit 3.0
import Sailfish.Silica 1.0

Page {
    id: webViewPage
    allowedOrientations : Orientation.All
    property string uri: ""

    SilicaWebView {
        id: webView
        anchors.fill: parent
    }

    Component.onCompleted: {
        webView.url = uri
    }
}
