import QtQuick 2.1
import Sailfish.Silica 1.0
import "../js/db.js" as DB
import "../js/boards.js" as Boards
import "../js/settings.js" as Settings
import io.thp.pyotherside 1.3

Page {
    id: page
    allowedOrientations : Orientation.All
    objectName: "boardsPage"
    property var categories
    property bool loading: false
    property bool somethingloading: false
    property bool someerror: false
    property var option
    property string domain: page.option[0].value
    property string notification: ""

    BusyIndicator {
        anchors.centerIn: parent
        running: page.loading
        visible: page.loading
        size: BusyIndicatorSize.Large
    }

    SilicaListView {
        id: listView
        visible: !page.loading
        model: categories
        anchors.fill: parent
        header: PageHeader {
            title: qsTr("Boards")
        }

        PullDownMenu {
            MenuItem {
                text: qsTr("Settings")
                onClicked: pageStack.push(Qt.resolvedUrl("Settings.qml") )
            }
            MenuItem {
                text: qsTr("Enter board name")
                onClicked: pageStack.push(Qt.resolvedUrl("Chooseboard.qml"), {domain: page.option[0].value} )
            }
        }
        delegate: BackgroundItem {
            id: delegate
            height: (brds.implicitHeight + ctgr.implicitHeight  + 15)

            Rectangle {
                id: lolo
                width: parent.width
                height: Theme.paddingLarge * 5
                color: Theme.secondaryHighlightColor
            }
            OpacityRampEffect {
                sourceItem: lolo
                direction: OpacityRamp.TopToBottom
                slope: 2.50
                offset: 0.01
            }
            Column {
                id:brds
                spacing: 5

                Text {
                    id: ctgr
                    text: modelData[0].category
                    color: Theme.highlightColor
                    anchors {
                        left: parent.left
                        leftMargin: 5
                    }
                }
                Grid {
                    columns: Math.floor(page.width / 135)
                    Repeater {
                        model: modelData
                        delegate: Item {
                            property Item contextMenu
                            id: myListItem
                            property bool menuOpen: contextMenu != null && contextMenu.parent === myListItem
                            width: 135
                            height: menuOpen ? contextMenu.height + 135 : 135

                            Item{
                                width: 135
                                height: 135
                                anchors.top: parent.top
                                Image {
                                    anchors.centerIn: parent
                                    property string iconnumber: "01"
                                    Component.onCompleted: {
                                        var number = Math.floor(Math.random() * (16 - 1 + 1)) + 1
                                        if (number < 10) {
                                            iconnumber = "0" + number.toString()
                                        } else {
                                            iconnumber = number.toString()
                                        }
                                    }

                                    source: "image://theme/icon-launcher-folder-" + iconnumber
                                    Label {
                                        text: modelData.id
                                        anchors.centerIn: parent
                                    }
                                }
                                Label {
                                    id: boardname
                                    width: parent.width - 10
                                    text: modelData.name
                                    font.pixelSize :Theme.fontSizeTiny
                                    truncationMode: TruncationMode.Fade
                                    anchors{
                                        bottom: parent.bottom
                                        left: parent.left
                                        leftMargin: 5
                                    }
                                }
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        notification = qsTr("Opening board")
                                        somethingloading = true
                                        Boards.getOne(modelData.id, "push", "index")
                                    }
                                    onPressAndHold: {
                                        if (!contextMenu)
                                            contextMenu = contextMenuComponent.createObject(listView)
                                        contextMenu.show(myListItem)
                                    }
                                }
                                Component {
                                    id: contextMenuComponent
                                    ContextMenu {
                                        MenuItem {
                                            visible: modelData.category !== "Избранное"
                                            text: qsTr("Add to favorites")
                                            onClicked: {
                                                Boards.fav(modelData.id, modelData.name)
                                                Boards.getAll()
                                            }
                                        }
                                        MenuItem {
                                            visible: modelData.category === "Избранное"
                                            text: qsTr("Remove from favorites")
                                            onClicked: Boards.unfav(modelData.id)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        VerticalScrollDecorator {}
    }

    Notifications {}

    Component.onCompleted: loadlist()
    onStatusChanged: {
        if (status === PageStatus.Active && pageStack.depth === 1) {
            pageStack.pushAttached(Qt.resolvedUrl("Favorites.qml") );
        }
    }

    function loadlist () {
        DB.openDB()
        Settings.load()
        Boards.getAll()
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
        /*onError: {
            // when an exception is raised, this error handler will be called
            console.log('python error: ' + traceback);
        }*/
        onReceived: {
            // asychronous messages from Python arrive here
            // in Python, this can be accomplished via pyotherside.send()
            console.log('got message from python: ' + data);
        }
    }
}
