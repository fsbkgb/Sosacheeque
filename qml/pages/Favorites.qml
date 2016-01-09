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
    property string domain: page.option[0].value
    property int pc
    property var favs
    property var option
    property var parsedthreads: []
    property bool somethingloading: false
    property bool someerror: false


    SilicaListView {
        anchors{
            fill: parent
        }
        id: listView
        model: page.favs
        header: PageHeader {
            title: qsTr("Favorites")
        }


        PullDownMenu {
            MenuItem {
                text: qsTr("Settings")
                onClicked: pageStack.push(Qt.resolvedUrl("Settings.qml") )
            }
            MenuItem {
                text: qsTr("Load board list")
                onClicked: pageStack.push(Qt.resolvedUrl("Boardlist.qml") )
            }
        }
        delegate: BackgroundItem {
            id: delegate
            Row {
                Column {
                    Label {
                        id: text
                        text: modelData.text
                        width: delbutton.visible === true ? page.width - Theme.horizontalPageMargin * 2 - delbutton.width : page.width - Theme.horizontalPageMargin * 2
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
                IconButton {
                    id: delbutton
                    visible: false
                    icon.source: "image://theme/icon-m-clear"
                    onClicked: Favorites.del(modelData.board, modelData.thread)
                }
            }
            Rectangle {
                anchors.fill: parent
                visible: modelData.thread === "0"
                color: Theme.rgba(Theme.highlightBackgroundColor, Theme.highlightBackgroundOpacity)
            }

            onPressAndHold: {
                delbutton.visible = true
            }

            onClicked: {
                if (delbutton.visible === true) {
                    delbutton.visible = false
                } else {
                    board = modelData.board
                    if (modelData.thread !== "0") {
                        notification = qsTr("Opening thread")
                        py.call('getdata.dyorg', ["favorites_page", "thread", "https://2ch." + domain + "/" + board + "/res/" + modelData.thread + ".json"], function() {})
                    } else {
                        notification = qsTr("Opening board")
                        py.call('getdata.dyorg', ["favorites_page", "board", "https://2ch." + domain + "/" + board + "/index.json"], function() {})
                    }
                    page.somethingloading = true
                }
            }
        }
        VerticalScrollDecorator {}
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
            console.log(pythonpath);
            var requestspath = Qt.resolvedUrl('../py/requests').substr('file://'.length);
            addImportPath(requestspath);
            importModule('getdata', function() {});
            setHandler('favorites_page', function (type, error, data) {
                if (type === "thread") {
                    Threads.getThread(error, data)
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
        DB.openDB()
        Settings.load()
        Favorites.load()
    }
}
