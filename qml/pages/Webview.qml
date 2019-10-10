import QtQuick 2.0
import QtWebKit 3.0
import Sailfish.Silica 1.0
import com.shortcut 0.1

Page {
    id: webViewPage
    allowedOrientations : Orientation.All
    property string uri: ""

    Shortcut {
        id: sendkeys
    }

    PageHeader {
        id: head
        height: Theme.itemSizeLarge
        title: uri.match("captcha") ? qsTr("Captcha") : qsTr("Cookie")
    }

    SilicaWebView {
        id: webView
        anchors {
            top: head.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        experimental.userAgent: "Mozilla/5.0 (Maemo; Linux; U; Sailfish; Mobile; rv:38.0) Gecko/38.0 Firefox/38.0"
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
            color: Theme.colorScheme === Theme.DarkOnLight ? "white" : "black"
            Button {
                anchors.centerIn: parent
                visible: uri.match("captcha")
                Text {
                    id: notarobot
                    text: qsTr("IM NOT A ROBOT")
                    color: Theme.primaryColor
                    anchors {
                        horizontalCenter: parent.horizontalCenter
                        verticalCenter: parent.verticalCenter
                    }
                }
                onClicked: {
                    webView.experimental.evaluateJavaScript("document.getElementById('g-recaptcha-response').value;", function(result) {
                        if (result === "") {
                            sendkeys.simulateKey(Qt.Key_C, Qt.ControlModifier,"c")
                            webView.experimental.evaluateJavaScript("document.getElementById('g-recaptcha-response').focus();", function() {
                                sendkeys.simulateKey(Qt.Key_V, Qt.ControlModifier,"v")
                            })
                            notarobot.text = qsTr("Tap me one more time")
                        } else {
                            Clipboard.text = ""
                            var newpostPage = pageStack.find(function(page) { return page.state === "postform"; })
                            newpostPage.captcha = result
                            pageStack.navigateBack()
                        }
                    })
                }
            }
            Button {
                anchors.centerIn: parent
                visible: !uri.match("captcha")
                Text {
                    text: qsTr("Save cookies")
                    color: Theme.primaryColor
                    anchors {
                        horizontalCenter: parent.horizontalCenter
                        verticalCenter: parent.verticalCenter
                    }
                }
                onClicked: webView.experimental.evaluateJavaScript("document.cookie;", function(result) {
                    var usercode = result.match(/usercode_auth=([a-z,0-9]{32})/)[1]
                    var settsPage = pageStack.find(function(page) { return page.objectName === "settsPage"; })
                    settsPage.savecooka(usercode)
                    pageStack.navigateBack()
                })
            }
        }
    }

    Component.onCompleted: {
        webView.url = uri
    }

}
