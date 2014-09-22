import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page
    property string tred: ""
    property string borda: ""
    property var postiki
    function getPosts() {
        var xhr = new XMLHttpRequest();
        var posti = []
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.HEADERS_RECEIVED) {
                print('HEADERS_RECEIVED');
            } else if(xhr.readyState === XMLHttpRequest.DONE) {
                var parsed = JSON.parse(xhr.responseText);
                var lalka = parsed["threads"][0]["posts"]
                for(var i = 0; i < lalka.length; i++) {
                    var post = lalka[i];
                    posti.push(post);
                }
            }
            page.postiki = posti
        }
        xhr.open("GET", "https://2ch.hk/"+borda+"/res/"+tred+".json");
        xhr.send();
    }
    function getNewPosts(count) {
        var xhr = new XMLHttpRequest();
        var posti = []
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.HEADERS_RECEIVED) {
                print('HEADERS_RECEIVED');
            } else if(xhr.readyState === XMLHttpRequest.DONE) {
                var parsed = JSON.parse(xhr.responseText);
                if(parsed.length > 0){
                    page.postiki.push(parsed[0])
                    page.postiki = page.postiki
                    getNewPosts(count + 1)
                }
            }
        }
        xhr.open("GET", "https://2ch.hk/makaba/mobile.fcgi?task=get_thread&board="+borda+"&thread="+tred+"&post="+count);
        xhr.send();
    }
    SilicaListView {
        anchors{
            fill: parent
        }
        spacing: 16
        id: listView
        model: postiki
        header: PageHeader {
            title: borda + "/" + tred
        }
        PushUpMenu {
            MenuItem {
                text: "Получить новые посты"
                onClicked: {
                    getNewPosts(listView.count + 1)
                }
            }
            MenuItem {
                text: "Ответить"
                onClicked: {
                    onClicked: {pageStack.push(Qt.resolvedUrl("Newpost.qml"), {borda: borda, tred: tred} )}
                }
            }
            MenuItem {
                text: "Добавить в избранное"
                onClicked: {
                    console.log("YOLO")
                }
            }
        }
        PullDownMenu {
            MenuItem {
                text: "Ответить"
                onClicked: {
                    console.log("YOLO")
                }
            }
            MenuItem {
                text: "Добавить в избранное"
                onClicked: {
                    console.log("YOLO")
                }
            }
        }
        delegate: BackgroundItem {
            id: delegate
            height: (rowrow.implicitHeight + text.implicitHeight + postnum.implicitHeight + postdate.implicitHeight)
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
                        source: "https://2ch.hk/"+borda+"/"+modelData.thumbnail
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
                                onClicked: {pageStack.push(Qt.resolvedUrl("Webview.qml"), {uri: "https://2ch.hk/"+borda+"/"+modelData.path} )}
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
                text: "<style>a:link { color: " + Theme.highlightColor + "; } .unkfunc { color: " + Theme.secondaryHighlightColor + "; } </style>" + modelData.comment
                width: parent.width
                wrapMode: Text.WordWrap
                color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
                anchors{
                    top: postdate.bottom
                    topMargin: rowrow.height
                    left: parent.left
                    leftMargin: 5
                }
                onLinkActivated: {
                    var extlink = new RegExp(/^http/)
                    var intlink = new RegExp(/^\/[a-z]+\/res\/[0-9]+\.html#[0-9]+/)
                    if (link.match(extlink))
                        {Qt.openUrlExternally(link)}
                    else if (link.match(intlink)){
                        var brd = link.match(/([a-z]+)/)[1]
                        var trd = link.match(/([0-9]+)/)[1]
                        var pst = link.match(/#([0-9]+)/)[1]
                        var url = "https://2ch.hk/makaba/mobile.fcgi?task=get_thread&board="+brd+"&thread="+trd+"&num="+pst
                        console.log(url)
                        pageStack.push(Qt.resolvedUrl("Postview.qml"), {url: url, borda: brd} )
                    }
                    else
                        {console.log(link)}
                }
            }
        }
        VerticalScrollDecorator {}
    }
    Component.onCompleted: {
        getPosts()
    }
}
