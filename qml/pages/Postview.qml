import QtQuick 2.1
import Sailfish.Silica 1.0
import "../js/posts.js" as Posts

Page {
    id: page
    property string board: ""
    property string domain: ""
    property string trd: ""
    property var postnums
    property var posts: []
    property var thread
    property bool loading: false

    BusyIndicator {
        anchors.centerIn: parent
        running: page.loading
        visible: page.loading
        size: BusyIndicatorSize.Large
    }
    SilicaListView {
        anchors{
            fill: parent
            topMargin: Theme.paddingLarge * 1.5
        }
        spacing: 16
        id: listView
        visible: !page.loading
        model: posts

        delegate: Item {
            property Item contextMenu
            id: myListItem
            property bool menuOpen: contextMenu != null && contextMenu.parent === myListItem
            width: ListView.view.width
            height: menuOpen ? contextMenu.height + content.height : content.height

            BackgroundItem {
                id: content
                height: (rowrow.implicitHeight + text.implicitHeight + postnum.implicitHeight + postdate.implicitHeight)

                Text {
                    id: postnum
                    text: modelData.num
                    color: Theme.highlightColor
                    anchors {
                        right: parent.right
                        rightMargin: 5
                    }
                    Rectangle {
                        id: hr
                        width: page.width - parent.width - Theme.paddingLarge * 2
                        height: 2
                        border.color: Theme.secondaryHighlightColor
                        border.width: 1
                        radius: 1
                        anchors {
                            right: parent.left
                            top: parent.verticalCenter
                            rightMargin: Theme.paddingLarge
                        }
                    }
                    OpacityRampEffect {
                        sourceItem: hr
                        slope: 1.7
                        offset: 0.45
                        direction: OpacityRamp.RightToLeft
                    }
                    GlassItem {
                        id: replychecker
                        color: Theme.highlightColor
                        visible: false
                        falloffRadius: 0.2
                        radius: 0.1
                        cache: false
                        anchors.verticalCenter: parent.bottom
                        anchors.horizontalCenter: parent.right
                        Component.onCompleted: {
                            if(Posts.checkReplies(modelData.num, thread) === true){
                                visible = true
                            }
                        }
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
                Column {
                    id:rowrow
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
                        topMargin: rowrow.height
                        left: parent.left
                        leftMargin: 5
                    }
                    onLinkActivated: Posts.parseLinks (link)
                }
                onPressAndHold: {
                    var replies = Posts.getReplies(modelData.num, page.thread)
                    if (!contextMenu)
                        contextMenu = contextMenuComponent.createObject(listView, {replies: replies})
                    contextMenu.show(myListItem)
                }
            }
        }
        Component {
            id: contextMenuComponent

            ContextMenu {
                property var replies

                MenuItem {
                    visible: replies[1] > 0
                    text: qsTr("View replies")
                    onClicked: pageStack.push(Qt.resolvedUrl("Postview.qml"), {postnums: replies, trd: trd, board: board, domain: domain, thread: thread} )
                }
                MenuItem {
                    text: qsTr("Reply (to do)")
                }
            }
        }
        VerticalScrollDecorator {}
    }
    Component.onCompleted: {
        Posts.getPosts(posts, 0, postnums, trd, board, domain, thread)
    }
}
