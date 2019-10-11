import QtQuick 2.1
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.3
import "../js/db.js" as DB
import "../js/settings.js" as Settings
import "../js/favorites.js" as Favorites

Page {
    objectName: "settsPage"
    id: page
    PageHeader {
        title: qsTr("Settings")
    }

    SilicaFlickable {
        anchors{
            fill: parent
            topMargin: Theme.paddingLarge * 4
        }

        Column {
            id: column
            width: parent.width

            ComboBox {
                id: domain
                width: page.width
                label: qsTr("Domain")
                currentIndex: -1
                menu: ContextMenu {
                    MenuItem { text: "hk" }
                    MenuItem { text: "pm" }
                }
                onCurrentItemChanged: {
                    Settings.save("domain", currentItem.text)
                    domain.value = Settings.load("domain")
                }
            }
            ComboBox {
                id: captcha
                width: page.width
                label: qsTr("Captcha")
                currentIndex: -1
                menu: ContextMenu {
                    MenuItem { text: "2ch" }
                    MenuItem { text: "google" }
                }
                onCurrentItemChanged: {
                    Settings.save("captcha", currentItem.text)
                    captcha.value = Settings.load("captcha")
                }
            }
            ComboBox {
                id: historysize
                width: page.width
                label: qsTr("History size")
                currentIndex: -1
                menu: ContextMenu {
                    MenuItem { text: "0" }
                    MenuItem { text: "10" }
                    MenuItem { text: "20" }
                    MenuItem { text: "50" }
                }
                onCurrentItemChanged: {
                    Settings.save("histsize", currentItem.text)
                    historysize.value = Settings.load("histsize")
                    Favorites.checkhsize(currentItem.text)
                    var favsPage = pageStack.find(function(page) { return page.objectName === "favsPage"; })
                    favsPage.loadfavs()
                }
            }
            ListItem {
                Row {
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    Label {
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        verticalAlignment: Text.AlignVCenter
                        leftPadding: Theme.paddingLarge
                        text: qsTr("Cache size")
                    }
                    Label {
                        id: cachsize
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        verticalAlignment: Text.AlignVCenter
                        leftPadding: Theme.paddingMedium
                        color: Theme.highlightColor
                        text: ""
                    }
                }
                menu: ContextMenu {
                    MenuItem {
                        text: qsTr("Clear")
                        onClicked: py.call('savefile.clearcache', [], function() {calccache()})
                    }
                }
            }
            ListItem {
                Row {
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    Label {
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        verticalAlignment: Text.AlignVCenter
                        leftPadding: Theme.paddingLarge
                        text: qsTr("Cookies")
                    }
                    Label {
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        verticalAlignment: Text.AlignVCenter
                        leftPadding: Theme.paddingMedium
                        color: Theme.highlightColor
                        text: Settings.load("usercode") !== null ? qsTr("Ok") : qsTr("None")
                    }
                }
                /*menu: ContextMenu {
                    MenuItem {
                        text: Settings.load("usercode") !== null ? qsTr("Refresh") : qsTr("Get")
                        onClicked: pageStack.push(Qt.resolvedUrl("Webview.qml"), {uri: "https://2ch." + Settings.load("domain") + "/test"} )
                    }
                }*/
            }
            TextSwitch {
                id: userboards
                checked: false
                text: qsTr("Show user boards")
                onCheckedChanged: {
                    Settings.save("userboards", checked ? "show" : "hide" );
                }
            }
        }
    }
    Component.onCompleted: {
        if (Settings.load("userboards") === "show") {
            userboards.checked = true
        }
        domain.value = Settings.load("domain")
        captcha.value = Settings.load("captcha")
        historysize.value = Settings.load("histsize")
        calccache()
    }

    function savecooka (cooka) {
        Settings.save("usercode", cooka)
    }

    Python {
        id: py

        Component.onCompleted: {
            // Add the Python library directory to the import path
            var pythonpath = Qt.resolvedUrl('../py/').substr('file://'.length);
            //var pythonpath = Qt.resolvedUrl('.').substr('file://'.length);
            addImportPath(pythonpath);
            var requestspath = Qt.resolvedUrl('../py/requests').substr('file://'.length);
            addImportPath(requestspath);
            importModule('savefile', function() {});
        }
        onError: {
            // when an exception is raised, this error handler will be called
            console.log('python error: ' + traceback);
        }
        onReceived: {
            // asychronous messages from Python arrive here
            // in Python, this can be accomplished via pyotherside.send()
            console.log('got message from python: ' + data);
        }
    }

    function calccache() {
        py.call('savefile.calccache', [], function(response) {
            cachsize.text = response
        });
    }
}
