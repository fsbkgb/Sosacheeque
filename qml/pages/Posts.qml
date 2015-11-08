import QtQuick 2.1
import Sailfish.Silica 1.0
import "../js/db.js" as DB
import "../js/threads.js" as Threads
import "../js/posts.js" as Posts
import "../js/favorites.js" as Favorites
import "../js/settings.js" as Settings
import "../js/boards.js" as Boards
import io.thp.pyotherside 1.3

Page {
    id: page
    objectName: "mainPage"
    allowedOrientations : Orientation.All
    property string board: ""
    property string boardname: ""
    property string thread: ""
    property string url: ""
    property string domain: ""
    property string state: ""
    property string comment: ""
    property string notification: ""
    property string currentpage: ""
    property int pages
    property int anchor
    property int enable_icons: 0
    property int enable_names: 0
    property int enable_subject: 0
    property var parsedthreads: []
    property var parsedposts
    property var parsedreplies: []
    property var icons: []
    property var postnums
    property var db
    property var option
    property bool loading: true
    property bool somethingloading: false
    property bool someerror: false
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
            visible: (page.state === "board" || page.state === "thread") ? true : false
            MenuItem {
                visible: page.state === "board" ? true : false
                text: qsTr("Add board to favorites")
                onClicked: {
                    Boards.fav(board, boardname)
                    var boardsPage = pageStack.find(function(page) { return page.objectName === "boardsPage"; })
                    boardsPage.loadlist()
                }
            }
            MenuItem {
                visible: page.state === "board" ? true : false
                text: qsTr("Choose page")
                onClicked: pageStack.push(Qt.resolvedUrl("Paginator.qml"), {board: board, pages: pages, domain: domain} )
            }
            MenuItem {
                visible: page.state === "board" ? true : false
                text: qsTr("Reload page")
                onClicked: {
                    notification = qsTr("Opening board")
                    somethingloading = true
                    Boards.getOne(board, "replace", currentpage)
                }
            }
            MenuItem {
                visible: page.state === "board" ? true : false
                text: qsTr("New thread")
                onClicked: pageStack.push(Qt.resolvedUrl("Newpost.qml"), {domain: domain, board: board, thread: "0", comment: "", icons: icons, enable_icons: enable_icons, enable_names: enable_names, enable_subject: enable_subject } )
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
            visible: (page.state === "board" || page.state === "thread") ? true : false
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
                onClicked: refreshthread ()
            }
        }
        delegate: Item {
            property Item contextMenu
            id: myListItem
            property bool menuOpen: contextMenu != null && contextMenu.parent === myListItem
            anchors {
                left: parent.left
                right: parent.right
                leftMargin: 5
                rightMargin: 5
            }
            height: menuOpen ? contextMenu.height + content.height : content.height

            BackgroundItem {
                id: content
                height: (thumbs.height + posttext.height + postnum.height + postdate.height + Theme.paddingLarge + Theme.paddingMedium)

                Text {
                    id: postnum
                    color: Theme.highlightColor
                    anchors {
                        right: parent.right
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
                        slope: 1.66
                        offset: 0.25
                        direction: OpacityRamp.RightToLeft
                    }
                    Component.onCompleted: {
                        if (page.state === "board"){
                            text = modelData.thread_num} else {
                            text = modelData.num}
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
                    }
                    Component.onCompleted: {
                        if (page.state === "board"){
                            text = modelData.posts[0].date} else {
                            text = modelData.date}
                    }
                }
                Label {
                    id: theme
                    text: ""
                    font.bold: true
                    font.pixelSize :Theme.fontSizeTiny
                    color: Theme.highlightColor
                    width: parent.width - postdate.width
                    truncationMode: TruncationMode.Fade
                    anchors {
                        top: postnum.bottom
                        left: parent.left
                    }
                    Component.onCompleted: {
                        if (page.state === "board"){
                            text = modelData.posts[0].subject} else {
                            text = modelData.subject}
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
                    }
                    Component.onCompleted: {
                        if (page.state === "board"){
                            text = qsTr("Replies: ") + modelData.posts_count} else {
                            text = "#"+index}
                    }
                }
                Column {
                    id:thumbs
                    anchors {
                        top: postdate.bottom
                        left: parent.left
                        topMargin: 5
                    }

                    Row {
                        id: attachments
                        anchors {
                            left: parent.left
                        }
                        spacing: 5

                        Repeater {
                            id: picrepeater
                            model: modelData.posts[0].files
                            Item {
                                id: container
                                width: Math.floor((page.width - 5 * attachments.spacing) / 4)
                                anchors.leftMargin: attachments.spacing
                                height: modelData.tn_height > Math.floor((page.width - 5 * attachments.spacing) / 4) ? Math.floor((page.width - 5 * attachments.spacing) / 4) + Theme.paddingMedium : modelData.tn_height + Theme.paddingMedium

                                Image {
                                    id: pic
                                    source: "https://2ch." + domain + "/" + board + "/" + modelData.thumbnail
                                    width: modelData.tn_width > Math.floor((page.width - 5 * attachments.spacing) / 4) ? Math.floor((page.width - 5 * attachments.spacing) / 4) : modelData.tn_width
                                    height: modelData.tn_height > Math.floor((page.width - 5 * attachments.spacing) / 4) ? Math.floor((page.width - 5 * attachments.spacing) / 4) : modelData.tn_height
                                    fillMode: Image.PreserveAspectFit
                                    smooth: true
                                    anchors.horizontalCenter: parent.horizontalCenter
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
                            }
                        }
                    }
                    Row {
                        id: filesize
                        anchors {
                            left: parent.left
                        }
                        spacing: 5

                        Repeater {
                            id: filerepeater
                            model: modelData.posts[0].files
                            Label {
                                id: file
                                font.pixelSize :Theme.fontSizeTiny
                                text: modelData.path.match(/\.([a-z]+)/)[1] + ", " + modelData.size + "kB"
                                color: Theme.secondaryColor
                                width: Math.floor((page.width - 5 * filesize.spacing) / 4)
                                horizontalAlignment: TextInput.AlignHCenter
                            }
                        }
                    }
                    Component.onCompleted: {
                        if (page.state === "board"){
                            picrepeater.model = filerepeater.model = modelData.posts[0].files} else {
                            picrepeater.model = filerepeater.model = modelData.files}
                    }
                }
                Label {
                    id: posttext
                    textFormat: Text.RichText
                    text: ""
                    width: parent.width - 10
                    wrapMode: Text.WordWrap
                    color: content.highlighted ? Theme.highlightColor : Theme.primaryColor
                    anchors{
                        top: postdate.bottom
                        topMargin: thumbs.height
                        left: parent.left
                    }
                    onWidthChanged: {
                        posttext.text = ""
                        var styles = "<style>
                                a:link { color: " + Theme.highlightColor + "; }
                                .unkfunc { color: " + Theme.secondaryHighlightColor + "; }
                                span.spoiler { color: #747474; }
                                .s { text-decoration: line-through; }
                                .u { text-decoration: underline; }
                              </style>"
                        if (page.state === "board"){
                            text = Threads.truncateOP(styles + modelData.posts[0].comment)} else {
                            text = styles + modelData.comment}
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
                        notification= qsTr("Opening thread")
                        page.somethingloading = true
                        Threads.getThread("https://2ch." + domain + "/" + board + "/res/" + modelData.thread_num + ".json", 1, false)
                    }
                }
                Image {
                    id: replychecker
                    visible: false
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right
                    source: "image://theme/icon-s-chat"
                    Component.onCompleted: {
                        if (page.state != "board"){
                            var rcount = Posts.checkReplies(modelData.num, parsedposts)
                            if( rcount > 0){
                                visible = true
                                repcount.text = rcount
                            }
                        }
                    }
                    Label {
                        id: repcount
                        anchors.right: parent.left
                        text: ""
                        font.pixelSize :Theme.fontSizeTiny
                        color: Theme.secondaryColor
                    }
                }
                Row {
                    anchors.bottom: parent.bottom
                    spacing: 5
                    Label {
                        id: name
                        textFormat: Text.RichText
                        text: ""
                        font.pixelSize :Theme.fontSizeTiny
                        color: Theme.secondaryColor
                        Component.onCompleted: {
                            if (page.state === "board"){
                                text = modelData.posts[0].name} else {
                                text = modelData.name}
                        }
                    }
                    Label {
                        id: trip
                        textFormat: Text.RichText
                        text: ""
                        font.pixelSize :Theme.fontSizeTiny
                        color: Theme.secondaryHighlightColor
                        Component.onCompleted: {
                            if (page.state === "board"){
                                text = modelData.posts[0].trip} else {
                                text = modelData.trip}
                            if (text === "!!%adm%!!") {
                                color = Theme.highlightColor
                                text = "Abu"
                            }
                            if (text === "!!%mod%!!") {
                                color = Theme.highlightColor
                                text = "Mod"
                            }
                        }
                    }
                    Image {
                        id: sage
                        visible: false
                        source: "image://theme/icon-s-low-importance"
                        Component.onCompleted: {
                            if (page.state !== "board"){
                                if( modelData.email === "mailto:sage"){
                                    visible = true
                                }
                            }
                        }
                    }
                    Image{
                        source: ""
                        anchors.verticalCenter: parent.verticalCenter
                        Component.onCompleted: if (page.state === "board") {source = geticons(0, modelData.posts[0])} else {source = geticons(0, modelData)}
                    }
                    Image{
                        source: ""
                        anchors.verticalCenter: parent.verticalCenter
                        Component.onCompleted: if (page.state === "board") {source = geticons(1, modelData.posts[0])} else {source = geticons(1, modelData)}
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
                        onClicked: pageStack.push(Qt.resolvedUrl("Posts.qml"), {postnums: replies, thread: thread, board: board, domain: domain, parsedposts: parsedposts, state: "replies", icons: icons} )
                    }
                    MenuItem {
                        text: qsTr("Reply")
                        onClicked: {
                            var replyform = pageStack.nextPage()
                            replyform.comment = comment + comm
                            navigateForward()
                        }
                    }
                    MenuItem {
                        text: qsTr("Reply with quote")
                        onClicked: {
                            var q = comm + "\r\n>" + quote.replace(/<br>/g, "\r\n>").replace(/<\/?[^>]+>/g, "")
                            var replyform = pageStack.nextPage()
                            replyform.comment = comment + q
                            navigateForward()
                        }
                    }
                }
            }
            VerticalScrollDecorator {}
        }
    }

    Notifications {}

    Component.onCompleted: {
        Settings.load()
        if (state === "board") {
            Threads.getAll(parsedthreads)
        } else if (state === "thread"){
            Threads.parseThread(anchor)
        } else {
            Posts.getPosts(parsedreplies, 0, postnums, thread, board, domain, parsedposts)
        }
    }
    onStatusChanged: {
        if (status === PageStatus.Active && comment === "" && (state === "thread" || state === "replies")  ) {
            pageStack.pushAttached(Qt.resolvedUrl("Newpost.qml"), {domain: domain, board: board, thread: thread, comment: comment, icons: icons, enable_icons: enable_icons, enable_names: enable_names, enable_subject: enable_subject } )
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

    function refreshthread () {
        notification= qsTr("Loading new posts")
        Posts.getNew(listView.count + 1, listView.count, fromfav, board, thread, listView.count, parsedposts[0].files ? parsedposts[0].files[0].thumbnail : "", parsedposts[0].subject ? parsedposts[0].subject : parsedposts[0].comment, parsedposts[0].timestamp)
    }

    function geticons(num, post) {
        if (post.icon !== undefined) {
            if (post.icon.match(/\/(\S*\.png)/g)[num] !== undefined) {
                return "https://2ch." + domain + post.icon.match(/\/(\S*\.png)/g)[num]
            } else {
                return ""
            }
        } else {
            return ""
        }
    }
}
