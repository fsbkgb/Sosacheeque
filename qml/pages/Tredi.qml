import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page
    property string borda: ""
    property string url: ""
    property string domen: ""
    property int pages
    property var trediki
    property bool loading: false
    function getThreads() {
        page.loading = true;
        var xhr = new XMLHttpRequest();
        var threads = []
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.HEADERS_RECEIVED) {
                print('HEADERS_RECEIVED');
            } else if(xhr.readyState === XMLHttpRequest.DONE) {
                var parsed = JSON.parse(xhr.responseText);
                var lalka = parsed["threads"]
                for(var i = 0; i < lalka.length; i++) {
                    var post = lalka[i];
                    threads.push(post);
                }
                page.loading = false;
            }
            page.trediki = threads
        }
        xhr.open("GET", url);
        xhr.send();
    }
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
        model: trediki
        header: PageHeader {
            title: borda
        }
        PullDownMenu {
            MenuItem {
                text: "Выбрать страницу"
                onClicked: pageStack.push(Qt.resolvedUrl("Paginator.qml"), {borda: borda, pages: pages, domen: domen} )
            }
            MenuItem {
                text: "Перезагрузить"
                onClicked: pageStack.replace(Qt.resolvedUrl("Tredi.qml"), {url: url, borda: borda, pages: pages} )
            }
        }
        PushUpMenu {
            MenuItem {
                text: "Выбрать страницу"
                onClicked: pageStack.push(Qt.resolvedUrl("Paginator.qml"), {borda: borda, pages: pages, domen: domen} )
            }
            MenuItem {
                text: "Перезагрузить"
                onClicked: pageStack.replace(Qt.resolvedUrl("Tredi.qml"), {url: url, borda: borda, pages: pages} )
            }
        }
        delegate: BackgroundItem {
            id: delegate
            height: (rowrow.implicitHeight + text.implicitHeight + postnum.implicitHeight + postdate.implicitHeight + 15)
            Text {
                id: postnum
                text: modelData.thread_num
                color: Theme.highlightColor
                anchors {
                    right: parent.right
                    rightMargin: 5
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
                text: "Ответов: " + modelData.posts_count
                font.pixelSize :Theme.fontSizeTiny
                color: Theme.secondaryHighlightColor
                anchors {
                    left: parent.left
                    leftMargin: 5
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
                    model: modelData.posts[0].files
                    height: childrenRect.height
                    Image {
                        id: pic
                        source: "https://2ch." + domen + "/" + borda + "/" + modelData.thumbnail
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
                                    pageStack.push(Qt.resolvedUrl("Webm.qml"), {uri: "https://2ch." + domen + "/" + borda + "/" + modelData.path} )
                                }
                                else{
                                    pageStack.push(Qt.resolvedUrl("Image.qml"), {uri: "https://2ch." + domen + "/" + borda + "/" + modelData.path} )
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
                       </style>" + modelData.posts[0].comment
                width: parent.width
                wrapMode: Text.WordWrap
                color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
                anchors{
                    top: postdate.bottom
                    topMargin: rowrow.height
                    left: parent.left
                    leftMargin: 5
                }
            }
            onClicked: pageStack.push(Qt.resolvedUrl("Tred.qml"), {tred: modelData.thread_num, borda: borda, domen: domen, anchor: 1, fromfav: false} )
        }
        VerticalScrollDecorator {}
    }
    Component.onCompleted: {
        getThreads()
    }
}
