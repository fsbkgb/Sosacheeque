import QtQuick 2.1
import Sailfish.Silica 1.0
import "../js/db.js" as DB
import "../js/threads.js" as Threads
import "../js/posts.js" as Posts
import "../js/favorites.js" as Favorites

Page {
    id: page
    property bool loading: false
    property bool newpostsloading: false
    property bool fromfav
    property string thread: ""
    property string board: ""
    property string domain: ""
    property int anchor
    property var posts
    property var db

    BusyIndicator {
        anchors.centerIn: parent
        running: page.loading
        visible: page.loading
        size: BusyIndicatorSize.Large
    }
    SilicaListView {
        anchors{
            fill: parent
        }
        spacing: 16
        id: listView
        visible: !page.loading
        model: posts
        header: PageHeader {
            title: board + "/" + thread
        }

        PushUpMenu {
            MenuItem {
                text: qsTr("Get new posts")
                onClicked: Posts.getNew(listView.count + 1, listView.count - 1, fromfav, board, thread, listView.count, posts[0].files ? posts[0].files[0].thumbnail : "", posts[0].subject ? posts[0].subject : posts[0].comment, posts[0].timestamp)
            }
            MenuItem {
                text: qsTr("Reply (to do)")
                //onClicked: pageStack.push(Qt.resolvedUrl("Webview.qml"), {board: board, thread: thread, uri: "https://2ch." + domain + "/contacts.html"} )
            }
        }
        PullDownMenu {
            MenuItem {
                text: qsTr("Open in browser")
                onClicked: pageStack.push(Qt.openUrlExternally("https://2ch." + domain + "/" + board + "/res/" + thread + ".html"))
            }
            MenuItem {
                text: qsTr("Add to favorites")
                onClicked: Favorites.save(board, thread, listView.count, posts[0].files ? posts[0].files[0].thumbnail : "", posts[0].subject ? posts[0].subject : posts[0].comment, posts[0].timestamp)
            }
        }
        delegate: Item {
            property Item contextMenu
            id: myListItem
            property bool menuOpen: contextMenu != null && contextMenu.parent === myListItem
            width: ListView.view.width
            height: menuOpen ? contextMenu.height + content.height : content.height

            BackgroundItem {
                id: content
                height: (pics.implicitHeight + text.implicitHeight + postnum.implicitHeight + postdate.implicitHeight)

                Text {
                    id: postnum
                    text: modelData.num
                    color: Theme.highlightColor
                    anchors {
                        right: parent.right
                        rightMargin: 5
                    }
                }
                Text {
                    id: postdate
                    text: modelData.date
                    font.pixelSize :Theme.fontSizeTiny
                    color: Theme.secondaryColor
                    anchors {
                        top: postnum.bottom
                        right: parent.right
                        rightMargin: 5
                    }
                }
                Text {
                    id: postcount
                    text: "#"+index
                    font.pixelSize :Theme.fontSizeTiny
                    color: Theme.secondaryHighlightColor
                    anchors {
                        left: parent.left
                        leftMargin: 5
                    }
                }
                Column {
                    id:pics
                    anchors {
                        top: postdate.bottom
                    }
                    spacing: 5

                    Repeater {
                        id: attachments
                        model: modelData.files
                        height: childrenRect.height

                        Image {
                            id: pic
                            source: "https://2ch." + domain + "/" + board + "/" + modelData.thumbnail
                            width: modelData.tn_width
                            height: modelData.tn_height
                            fillMode: Image.PreserveAspectFit
                            smooth: true
                            anchors {
                                topMargin: 5
                                left: parent.left
                                leftMargin: 5
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    if(modelData.path.match(/\.([a-z]+)/)[1] === "webm"){
                                        pageStack.push(Qt.resolvedUrl("Webmview.qml"), {uri: "https://2ch." + domain + "/" + board + "/" + modelData.path} )
                                    }
                                    else{
                                        pageStack.push(Qt.resolvedUrl("Imageview.qml"), {uri: "https://2ch." + domain + "/" + board + "/" + modelData.path} )
                                    }
                                }
                            }
                            Label {
                                id: file
                                font.pixelSize :Theme.fontSizeTiny
                                text: modelData.path.match(/\.([a-z]+)/)[1] + ", " + modelData.size + "kB"
                                width: parent.width
                                color: Theme.secondaryColor
                                anchors{
                                    top: parent.top
                                    left: parent.right
                                    leftMargin: 5
                                }
                            }
                        }
                    }
                }
                Label {
                    id: text
                    textFormat: Text.RichText
                    text: "<style>
                           a:link { color: " + Theme.highlightColor + "; }
                           .unkfunc { color: " + Theme.secondaryHighlightColor + "; }
                           span.spoiler { color: #747474; }
                           .s { text-decoration: line-through; }
                           .u { text-decoration: underline; }
                       </style>"  + modelData.comment
                    width: parent.width
                    wrapMode: Text.WordWrap
                    color: content.highlighted ? Theme.highlightColor : Theme.primaryColor
                    anchors{
                        top: postdate.bottom
                        topMargin: pics.height
                        left: parent.left
                        leftMargin: 5
                    }
                    onLinkActivated: Posts.parseLinks (link)
                }
                onPressAndHold: {
                    if (!contextMenu)
                        contextMenu = contextMenuComponent.createObject(listView, {post_num: modelData.num})
                    contextMenu.show(myListItem)
                }
            }
        }
        Component {
            id: contextMenuComponent

            ContextMenu {
                property var post_num

                MenuItem {
                    text: qsTr("View replies")
                    onClicked: Posts.getReplies (post_num, posts, page.thread, page.board, page.domain)
                }
                MenuItem {
                    text: qsTr("Reply (to do)")
                }
            }
        }
        VerticalScrollDecorator {}
    }
    ProgressBar {
        width: parent.width
        indeterminate: true
        visible: page.newpostsloading
        anchors{
            bottom: parent.bottom
            bottomMargin: Theme.paddingLarge * 4
        }
    }
    Component.onCompleted: {
        Threads.getOne(anchor)
    }
}
