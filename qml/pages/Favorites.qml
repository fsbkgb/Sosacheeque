import QtQuick 2.1
import Sailfish.Silica 1.0
import "../js/db.js" as DB
import "../js/settings.js" as Settings
import "../js/favorites.js" as Favorites

Page {
    id: page
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
            height: pic.implicitHeight > (text.implicitHeight + url.implicitHeight) ? pic.implicitHeight : (text.implicitHeight + url.implicitHeight)

            Image {
                id: pic
                source: "https://2ch." + page.option[0].value + "/" + modelData.board + "/" + modelData.tmb
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingSmall
                }
            }
            Label {
                id: url
                text: modelData.board + "/" + modelData.thread
                width: parent.width
                font.pixelSize :Theme.fontSizeTiny
                color: Theme.secondaryHighlightColor
                anchors {
                    left: pic.right
                    leftMargin: Theme.paddingSmall
                }

            }
            Label {
                id: text
                text: modelData.text
                width: page.width - Theme.paddingLarge - pic.width
                font.pixelSize :Theme.fontSizeExtraSmall
                color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
                maximumLineCount: 1
                horizontalAlignment: Text.AlignLeft
                truncationMode: TruncationMode.Fade
                anchors {
                    left: pic.right
                    leftMargin: Theme.paddingSmall
                    top: url.bottom
                    topMargin: Theme.paddingSmall
                }
            }
            IconButton {
                icon.source: "image://theme/icon-m-clear"
                anchors {
                    right: parent.right
                    verticalCenter: url.verticalCenter
                }
                onClicked: Favorites.del(modelData.board, modelData.thread)
            }
            onClicked: pageStack.push(Qt.resolvedUrl("Posts.qml"), {thread: modelData.thread, board: modelData.board, domain: page.option[0].value, anchor: modelData.pc, fromfav: true, state: "thread"} )
        }
        VerticalScrollDecorator {}
    }
    Component.onCompleted: {
        Settings.load()
        Favorites.load()
    }
    onStatusChanged: {
        if (status === PageStatus.Active && pageStack.depth === 1) {
            pageStack.pushAttached(Qt.resolvedUrl("Boardlist.qml") );
        }
    }
}
