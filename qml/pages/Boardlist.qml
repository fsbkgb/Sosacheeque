import QtQuick 2.1
import Sailfish.Silica 1.0
import "../js/db.js" as DB
import "../js/boards.js" as Boards
import "../js/settings.js" as Settings

Page {
    id: page
    objectName: "boardsPage"
    property var categories
    property bool loading: false
    property var option

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
                Repeater {
                    id: brd
                    model: modelData
                    height: childrenRect.height

                    Label {
                        id: text
                        text: "/" + modelData.id + "/ – " + modelData.name
                        horizontalAlignment: Text.AlignLeft
                        truncationMode: TruncationMode.Fade
                        width: page.width
                        color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
                        anchors{
                            topMargin: 5
                            left: parent.left
                            leftMargin: 5
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: pageStack.push(Qt.resolvedUrl("Posts.qml"), {url: "https://2ch." + page.option[0].value + "/" + modelData.id + "/index.json", board: modelData.id, pages: modelData.pages, domain: page.option[0].value, state: "board"} )
                        }
                    }
                }
            }
        }
        VerticalScrollDecorator {}
    }
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
}
