import QtQuick 2.1
import Sailfish.Silica 1.0
import "../js/db.js" as DB
import "../js/settings.js" as Settings
import "../js/favorites.js" as Favorites
import "../js/threads.js" as Threads
import io.thp.pyotherside 1.3

Page {
    id: page
    allowedOrientations : Orientation.All
    objectName: "favsPage"
    property string board: ""
    property int pc
    property var favs
    property var option
    property var parsedthreads: []
    property bool somethingloading: false

    SilicaListView {
        anchors{
            fill: parent
        }
        spacing: 16
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
        }
        delegate: BackgroundItem {
            id: delegate
            Row {
                spacing: Theme.paddingSmall
                RemorseItem { id: remorse }
                Image {
                    id: pic
                    source: "https://2ch." + page.option[0].value + "/" + modelData.board + "/" + modelData.tmb
                    width: 100
                    height: 100
                    fillMode: Image.PreserveAspectCrop
                }
                Column {
                    Label {
                        id: url
                        text: modelData.board + "/" + modelData.thread
                        font.pixelSize :Theme.fontSizeTiny
                        color: Theme.secondaryHighlightColor

                    }
                    Label {
                        id: text
                        text: modelData.text
                        width: page.width - Theme.paddingLarge - pic.width - delbutton.width
                        font.pixelSize :Theme.fontSizeExtraSmall
                        color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
                        maximumLineCount: 1
                        horizontalAlignment: Text.AlignLeft
                        truncationMode: TruncationMode.Fade
                    }
                }
                IconButton {
                    id: delbutton
                    icon.source: "image://theme/icon-m-clear"
                    onClicked: remorse.execute(delegate, qsTr("Deleting"), function() { Favorites.del(modelData.board, modelData.thread) }, 5000)
                }
            }
            onClicked: {
                page.somethingloading = true
                krooteelkaText.text = qsTr("Opening thread")
                board = modelData.board
                Threads.getThread("https://2ch." + page.option[0].value + "/" + board + "/res/" + modelData.thread + ".json")
            }
        }
        VerticalScrollDecorator {}
    }
    Rectangle {
        anchors{
            top: parent.top
        }
        color: Theme.highlightBackgroundColor
        width: parent.width
        height: Theme.paddingLarge * 2
        visible: page.somethingloading
        BusyIndicator {
            id: krooteelka
            size: BusyIndicatorSize.Small
            running: true
            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
                leftMargin: Theme.paddingSmall
            }
        }
        Label {
            id: krooteelkaText
            text: qsTr("Loading new posts")
            anchors {
                left: krooteelka.right
                verticalCenter: parent.verticalCenter
                leftMargin: Theme.paddingSmall
            }
        }
    }
    Component.onCompleted: loadfavs ()
    onStatusChanged: {
        if (status === PageStatus.Active && pageStack.depth === 1) {
            pageStack.pushAttached(Qt.resolvedUrl("Boardlist.qml") );
        }
    }

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

    function loadfavs () {
        Settings.load()
        Favorites.load()
    }
}
