import QtQuick 2.1
import Sailfish.Silica 1.0
import "../js/db.js" as DB
import "../js/settings.js" as Settings
import "../js/favorites.js" as Favorites

Page {
    id: page
    allowedOrientations : Orientation.All
    objectName: "favsPage"
    property string board: ""
    property string thread: ""
    property int pc
    property var favs
    property var option

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
            onClicked: pageStack.push(Qt.resolvedUrl("Posts.qml"), {thread: modelData.thread, board: modelData.board, domain: page.option[0].value, anchor: modelData.pc, fromfav: true, state: "thread"} )
        }
        VerticalScrollDecorator {}
    }
    Component.onCompleted: loadfavs ()
    onStatusChanged: {
        if (status === PageStatus.Active && pageStack.depth === 1) {
            pageStack.pushAttached(Qt.resolvedUrl("Boardlist.qml") );
        }
    }

    function loadfavs () {
        Settings.load()
        Favorites.load()
    }
}
