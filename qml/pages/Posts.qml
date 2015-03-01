import QtQuick 2.1
import Sailfish.Silica 1.0
import "../js/db.js" as DB
import "../js/threads.js" as Threads
import "../js/posts.js" as Posts
import "../js/favorites.js" as Favorites

Page {
    id: page
    property string board: ""
    property string thread: ""
    property string url: ""
    property string domain: ""
    property string state: ""
    property int pages
    property int anchor
    property var parsedposts
    property var parsedreplies: []
    property var postnums
    property var db
    property bool loading: true
    property bool newpostsloading: false
    property bool fromfav

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
        header: PageHeader {
            id: header
            Component.onCompleted: {
                if (page.state === "board"){
                    header.title = "/" + board + "/"} else if (page.state === "thread"){
                    header.title = board + "/" + thread} else {
                    header.title = qsTr("Replies")
                }
            }
        }

        PullDownMenu {
            MenuItem {
                visible: page.state === "board" ? true : false
                text: qsTr("Choose page")
                onClicked: pageStack.push(Qt.resolvedUrl("Paginator.qml"), {board: board, pages: pages, domain: domain} )
            }
            MenuItem {
                visible: page.state === "board" ? true : false
                text: qsTr("Reload page")
                onClicked: pageStack.replace(Qt.resolvedUrl("Posts.qml"), {url: url, board: board, pages: pages, domain: domain, state: "board"} )
            }
            MenuItem {
                visible: page.state === "board" ? true : false
                text: qsTr("New thread")
                onClicked: pageStack.push(Qt.resolvedUrl("Newpost.qml"), {domain: domain, board: board, thread: "0", comment: "" } )
            }
            MenuItem {
                visible: page.state === "thread" ? true : false
                text: qsTr("Open in browser")
                onClicked: pageStack.push(Qt.openUrlExternally("https://2ch." + domain + "/" + board + "/res/" + thread + ".html"))
            }
            MenuItem {
                visible: page.state === "thread" ? true : false
                text: qsTr("Add to favorites")
                onClicked: Favorites.save(board, thread, listView.count, parsedposts[0].files ? parsedposts[0].files[0].thumbnail : "", parsedposts[0].subject ? parsedposts[0].subject : parsedposts[0].comment, parsedposts[0].timestamp)
            }
        }
        PushUpMenu {
            MenuItem {
                visible: page.state === "board" ? true : false
                text: qsTr("Choose page")
                onClicked: pageStack.push(Qt.resolvedUrl("Paginator.qml"), {board: board, pages: pages, domain: domain} )
            }
            MenuItem {
                visible: page.state === "board" ? true : false
                text: qsTr("Reload page")
                onClicked: pageStack.replace(Qt.resolvedUrl("Posts.qml"), {url: url, board: board, pages: pages, domain: domain, state: "board"} )
            }
            MenuItem {
                visible: page.state === "thread" ? true : false
                text: qsTr("Get new posts")
                onClicked: Posts.getNew(listView.count + 1, listView.count - 1, fromfav, board, thread, listView.count, parsedposts[0].files ? parsedposts[0].files[0].thumbnail : "", parsedposts[0].subject ? parsedposts[0].subject : parsedposts[0].comment, parsedposts[0].timestamp)
            }
            MenuItem {
                visible: page.state === "thread" ? true : false
                text: qsTr("Reply")
                onClicked: pageStack.push(Qt.resolvedUrl("Newpost.qml"), {domain: domain, board: board, thread: thread } )
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
                height: (threadlist.implicitHeight + text.implicitHeight + postnum.implicitHeight + postdate.implicitHeight + Theme.paddingLarge)

                Text {
                    id: postnum
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
                        offset: 0.2
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
                            if (page.state != "board"){
                                if(Posts.checkReplies(modelData.num, parsedposts) === true){
                                    visible = true
                                }
                            }
                        }
                    }
                    Component.onCompleted: {
                        if (page.state === "board"){
                            postnum.text = modelData.thread_num} else {
                            postnum.text = modelData.num}
                    }
                }
                Text {
                    id: postdate
                    text: modelData.posts[0].date
                    font.pixelSize :Theme.fontSizeTiny
                    color: Theme.secondaryColor
                    anchors {
                        top: postnum.bottom
                        right: parent.right
                        rightMargin: 5
                    }
                    Component.onCompleted: {
                        if (page.state === "board"){
                            postdate.text = modelData.posts[0].date} else {
                            postdate.text = modelData.date}
                    }
                }
                Text {
                    id: postcount
                    text: qsTr("Replies: ") + modelData.posts_count
                    font.pixelSize :Theme.fontSizeTiny
                    color: Theme.secondaryHighlightColor
                    anchors {
                        verticalCenter: postnum.verticalCenter
                        left: parent.left
                        leftMargin: 5
                    }
                    Component.onCompleted: {
                        if (page.state === "board"){
                            postcount.text = qsTr("Replies: ") + modelData.posts_count} else {
                            postcount.text = "#"+index}
                    }
                }
                Column {
                    id:threadlist
                    anchors {
                        top: postdate.bottom
                    }
                    spacing: 5

                    Repeater {
                        id: attachments
                        model: modelData.posts[0].files
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
                        Component.onCompleted: {
                            if (page.state === "board"){
                                attachments.model = modelData.posts[0].files} else {
                                attachments.model = modelData.files}
                        }
                    }
                }
                Label {
                    id: text
                    textFormat: Text.RichText
                    text: ""
                    width: parent.width - 10
                    wrapMode: Text.WordWrap
                    color: content.highlighted ? Theme.highlightColor : Theme.primaryColor
                    anchors{
                        top: postdate.bottom
                        topMargin: threadlist.height
                        left: parent.left
                        leftMargin: 5
                    }
                    Component.onCompleted: {
                        var styles = "<style>
                                a:link { color: " + Theme.highlightColor + "; }
                                .unkfunc { color: " + Theme.secondaryHighlightColor + "; }
                                span.spoiler { color: #747474; }
                                .s { text-decoration: line-through; }
                                .u { text-decoration: underline; }
                              </style>"
                        if (page.state === "board"){
                            text.text = Threads.truncateOP(styles + modelData.posts[0].comment)} else {
                            text.text = styles + modelData.comment}
                    }
                    onLinkActivated: {
                        if (page.state != "board"){
                            Posts.parseLinks (link)
                        }
                    }
                }
                onPressAndHold: {
                    if (page.state != "board") {
                        var replies = Posts.getReplies(modelData.num, parsedposts)
                        if (!contextMenu)
                            contextMenu = contextMenuComponent.createObject(listView, {replies: replies, comm: ">>" + modelData.num, quote: modelData.comment})
                        contextMenu.show(myListItem)
                    }
                }
                onClicked: {
                    if (page.state === "board") {
                        pageStack.push(Qt.resolvedUrl("Posts.qml"), {thread: modelData.thread_num, board: board, domain: domain, anchor: 1, fromfav: false, state: "thread"} )
                    }
                }

            }
            Component {
                id: contextMenuComponent

                ContextMenu {
                    property var replies
                    property var comm
                    property var quote
                    visible: page.state === "board" ? false : true

                    MenuItem {
                        visible: replies[1] > 0
                        text: qsTr("View replies")
                        onClicked: pageStack.push(Qt.resolvedUrl("Posts.qml"), {postnums: replies, thread: thread, board: board, domain: domain, parsedposts: parsedposts} )
                    }
                    MenuItem {
                        text: qsTr("Reply")
                        onClicked: pageStack.push(Qt.resolvedUrl("Newpost.qml"), {domain: domain, board: board, thread: thread, comment: comm } )
                    }
                    MenuItem {
                        text: qsTr("Reply with quote")
                        onClicked: {
                            var q = comm + "\r\n>" + quote.replace(/<br>/g, "\r\n>").replace(/<\/?[^>]+>/g, "")
                            pageStack.push(Qt.resolvedUrl("Newpost.qml"), {domain: domain, board: board, thread: thread, comment: q } )
                        }
                    }
                }
            }
            VerticalScrollDecorator {}
        }
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
        if (state === "board") {
            Threads.getAll()
        } else if (state === "thread"){
            Threads.getOne(anchor)
        } else {
            Posts.getPosts(parsedreplies, 0, postnums, thread, board, domain, parsedposts)
        }

    }
}
