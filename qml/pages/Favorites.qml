import QtQuick 2.1
import Sailfish.Silica 1.0
import "../js/db.js" as DB
import "../js/settings.js" as Settings
import "../js/favorites.js" as Favorites
import "../js/threads.js" as Threads
import "../js/boards.js" as Boards
import io.thp.pyotherside 1.3

Page {
    id: page

    allowedOrientations : Orientation.All
    objectName: "favsPage"
    property string board: ""
    property string notification: ""
    property string domain: page.option[2].value
    property string cooka: page.option[0].value !== null ? page.option[0].value : ""
    property string state: ""
    property int pc
    property var favs
    property var option
    property var parsedthreads: []
    property bool somethingloading: false
    property bool someerror: false

    SilicaFlickable {
        anchors.fill: parent
        PullDownMenu {
            MenuItem {
                text: qsTr("Settings")
                onClicked: pageStack.push(Qt.resolvedUrl("Settings.qml") )
            }
            MenuItem {
                text: qsTr("Load board list")
                onClicked: pageStack.push(Qt.resolvedUrl("Boardlist.qml") )
            }
            MenuItem {
                text: qsTr("History")
                visible: page.state !== "history"
                onClicked: pageStack.replace(Qt.resolvedUrl("Favorites.qml"), {state: "history"} )
            }
            MenuItem {
                text: qsTr("Favorites")
                visible: page.state === "history"
                onClicked: pageStack.replace(Qt.resolvedUrl("Favorites.qml"), {state: ""} )
            }
        }

        SilicaListView {
            anchors.fill: parent
            id: listView
            model: page.favs
            header: PageHeader {
                title: page.state === "history" ? qsTr("History") : qsTr("Favorites")
            }
            delegate: ListItem {
                id: delegate
                Row {
                    IconButton {
                        id: delbutton
                        visible: false
                        icon.source: "image://theme/icon-m-clear"
                        onClicked: Favorites.del(modelData.board, modelData.thread)
                    }
                    IconButton {
                        id: editbutton
                        visible: false
                        icon.source: "image://theme/icon-m-edit"
                        onClicked: pageStack.push(Qt.resolvedUrl("EditFav.qml"), {board: modelData.board, thread: modelData.thread, postcount: modelData.pc, title: modelData.text} )
                    }
                    Column {
                        Label {
                            id: text
                            text: modelData.text
                            width: delbutton.visible === true ? page.width - Theme.horizontalPageMargin * 2 - delbutton.width * 2 : page.width - Theme.horizontalPageMargin * 2
                            font.pixelSize :Theme.fontSizeMedium
                            color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
                            maximumLineCount: 1
                            horizontalAlignment: Text.AlignLeft
                            anchors {
                                left: parent.left
                                leftMargin: Theme.horizontalPageMargin
                            }
                            truncationMode: TruncationMode.Fade
                        }
                        Label {
                            id: url
                            text: modelData.thread !== "0" ? "/" + modelData.board + "/" + modelData.thread : "/" + modelData.board
                            font.pixelSize :Theme.fontSizeTiny
                            anchors {
                                left: parent.left
                                leftMargin: Theme.horizontalPageMargin
                            }
                            color: Theme.secondaryHighlightColor
                        }
                    }
                }
                Rectangle {
                    anchors.fill: parent
                    visible: modelData.thread === "0"
                    color: Theme.rgba(Theme.highlightBackgroundColor, Theme.highlightBackgroundOpacity)
                }
                onPressAndHold: {
                    delbutton.visible = true
                    editbutton.visible = true
                }
                onClicked: {
                    if (delbutton.visible === true) {
                        delbutton.visible = false
                        editbutton.visible = false
                    } else {
                        board = modelData.board
                        if (modelData.thread !== "0") {
                            notification = qsTr("Opening thread")
                            py.call('getdata.dyorg', ["favorites_page", "thread", "https://2ch." + domain + "/" + board + "/res/" + modelData.thread + ".json#" + modelData.pc, cooka], function() {})
                        } else {
                            notification = qsTr("Opening board")
                            py.call('getdata.dyorg', ["favorites_page", "board", "https://2ch." + domain + "/" + board + "/index.json", cooka], function() {})
                        }
                        page.somethingloading = true
                    }
                }
            }
            VerticalScrollDecorator { flickable: listView }
        }
    }

    Notifications {}

    Component.onCompleted: loadfavs ()

    Python {
        id: py

        Component.onCompleted: {
            // Add the Python library directory to the import path
            var pythonpath = Qt.resolvedUrl('../py/').substr('file://'.length);
            //var pythonpath = Qt.resolvedUrl('.').substr('file://'.length);
            addImportPath(pythonpath);
            var requestspath = Qt.resolvedUrl('../py/requests').substr('file://'.length);
            addImportPath(requestspath);
            importModule('getdata', function() {});
            setHandler('favorites_page', function (type, error, data, anchor) {
                if (type === "thread") {
                    Threads.getThread(error, data, anchor, "push")
                } else {
                    Boards.getOne(error, data, "push")
                }
            });
        }
        onError: {
            // when an exception is raised, this error handler will be called
            console.log('python error: ' + traceback);
        }
        onReceived: {
            // asychronous messages from Python arrive here
            // in Python, this can be accomplished via pyotherside.send()
        }
    }

    function loadfavs () {
        DB.initDB()
        Settings.load()
        Favorites.load(page.state)
    }
}
