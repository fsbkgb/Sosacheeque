import QtQuick 2.1
import Sailfish.Silica 1.0
import "../js/threads.js" as Threads

Page {
    id: page
    property string board: ""
    property string url: ""
    property string domain: ""
    property int pages
    property var threads
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
        }
        spacing: 16
        id: listView
        visible: !page.loading
        model: threads
        header: PageHeader {
            title: "/" + board + "/"
        }

        PullDownMenu {
            MenuItem {
                text: qsTr("Choose page")
                onClicked: pageStack.push(Qt.resolvedUrl("Paginator.qml"), {board: board, pages: pages, domain: domain} )
            }
            MenuItem {
                text: qsTr("Reload page")
                onClicked: pageStack.replace(Qt.resolvedUrl("Threads.qml"), {url: url, board: board, pages: pages, domain: domain} )
            }
            MenuItem {
                text: qsTr("New thread")
                onClicked: pageStack.push(Qt.resolvedUrl("Newpost.qml"), {domain: domain, board: board, thread: "0", comment: "" } )
            }
        }
        PushUpMenu {
            MenuItem {
                text: qsTr("Choose page")
                onClicked: pageStack.push(Qt.resolvedUrl("Paginator.qml"), {board: board, pages: pages, domain: domain} )
            }
            MenuItem {
                text: qsTr("Reload page")
                onClicked: pageStack.replace(Qt.resolvedUrl("Threads.qml"), {url: url, board: board, pages: pages, domain: domain} )
            }
        }
        delegate: BackgroundItem {
            id: delegate
            height: (threadlist.implicitHeight + text.implicitHeight + postnum.implicitHeight + postdate.implicitHeight + Theme.paddingLarge)

            Text {
                id: postnum
                text: modelData.thread_num
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
                }
            }
            Label {
                id: text
                textFormat: Text.RichText
                text: ""
                width: parent.width - 10
                wrapMode: Text.WordWrap
                color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
                anchors{
                    top: postdate.bottom
                    topMargin: threadlist.height
                    left: parent.left
                    leftMargin: 5
                }
                Component.onCompleted: {
                    var op = "<style>
                                a:link { color: " + Theme.highlightColor + "; }
                                .unkfunc { color: " + Theme.secondaryHighlightColor + "; }
                                span.spoiler { color: #747474; }
                                .s { text-decoration: line-through; }
                                .u { text-decoration: underline; }
                              </style>" + modelData.posts[0].comment
                    text.text = Threads.truncateOP(op)
                }
            }
            onClicked: pageStack.push(Qt.resolvedUrl("Thread.qml"), {thread: modelData.thread_num, board: board, domain: domain, anchor: 1, fromfav: false} )
        }
        VerticalScrollDecorator {}
    }
    Component.onCompleted: {
        Threads.getAll()
    }
}
