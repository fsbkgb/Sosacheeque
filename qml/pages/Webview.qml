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


    DockedPanel {
        id: panel
        width: parent.width
        height: Theme.itemSizeExtraLarge
        dock: Dock.Bottom
        open: true
        Rectangle {
            anchors.centerIn: parent
            height: parent.height
            width: parent.width
            color: "black"
            Button {
                anchors.centerIn: parent
                Text {
                    text: qsTr("IM NOT A ROBOT")
                    color: Theme.primaryColor
                    anchors {
                        horizontalCenter: parent.horizontalCenter
                        verticalCenter: parent.verticalCenter
                    }
                }
                onClicked: webView.experimental.evaluateJavaScript("document.getElementById('g-recaptcha-response').value;", function(result) {
                    console.log(result)
                    var newpostPage = pageStack.find(function(page) { return page.state == "postform"; })
                    newpostPage.captcha = result
                    pageStack.navigateBack()
                })
            }
        }
    }

    Component.onCompleted: {
        webView.url = uri
    }

}
