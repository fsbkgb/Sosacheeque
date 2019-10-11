import QtQuick 2.0
import QtWebKit 3.0
import Sailfish.Silica 1.0
import com.shortcut 0.1
import "../js/db.js" as DB
import "../js/settings.js" as Settings

Page {
    id: webViewPage
    allowedOrientations : Orientation.All
    property string uri: ""
    property string thread: ""
    property string board: ""
    property string captcha: ""
    property string captcha_type: ""
    property string domain: ""
    property string comment: ""

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
        onLoadingChanged: {
            webView.experimental.evaluateJavaScript("
                        (function(){
                            var viewport = document.querySelector('meta[name=\"viewport\"]');
                            if (viewport) {
                                viewport.content = 'initial-scale=1.5';
                            } else {
                                document.getElementsByTagName('head')[0].appendChild('<meta name=\"viewport\" content=\"initial-scale=1.5\">');
                            }
                        })()",
                        function(result) {
                        });
        }
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
            Row{
                visible: !uri.match("captcha")
                anchors.centerIn: parent
                spacing: Theme.paddingMedium
                Button {
                    Text {
                        text: qsTr("Post")
                        color: Theme.primaryColor
                        anchors {
                            horizontalCenter: parent.horizontalCenter
                            verticalCenter: parent.verticalCenter
                        }
                    }
                    onClicked: {
                        visible = false
                        savecookies.visible = true
                        if (captcha_type === "google") {captcha_type = "recaptcha"}
                        webView.experimental.evaluateJavaScript("
                        var xhr = new XMLHttpRequest();
                        xhr.open('POST', 'https://2ch."+domain+"/makaba/posting.fcgi?json=1', true);

                        xhr.send('task=post&board="+board+"&thread="+thread+"&comment="+comment+"&g-recaptcha-response="+captcha+"&captcha_type="+captcha_type+"');

                        xhr.onreadystatechange = function () {
                          if(xhr.readyState === 4 && xhr.status === 200) {
                            location.reload();
                          }
                        };")
                    }
                }
                Button {
                    id: savecookies
                    visible: false
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
                        savecooka(usercode)
                        var threadPage = pageStack.find(function(page) { return page.state === "thread"; })
                        threadPage.comment = ""
                        pageStack.replaceAbove(threadPage, Qt.resolvedUrl("KostylPage.qml"), null, PageStackAction.Immediate)
                        threadPage.refreshthread()
                        pageStack.navigateBack()
                    })
                }
            }
        }
    }

    function savecooka (cooka) {
        Settings.save("usercode", cooka)
    }

    Component.onCompleted: {
        webView.url = uri
    }

}
