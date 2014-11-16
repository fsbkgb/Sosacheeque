import QtQuick 2.0
import Sailfish.Silica 1.0
import "../js/db.js" as DB

Page {
    id: page
    property bool loading: false
    property bool newpostsloading: false
    property bool fromfav
    property string tred: ""
    property string borda: ""
    property string domen: ""
    property int anchor
    property var postiki
    property var db
    function saveFav(board, thread, postcount, thumb, subject, timestamp) {
        var db = DB.getDatabase();
        db.transaction( function(tx){
            tx.executeSql('INSERT OR REPLACE INTO favs VALUES(?, ?, ?, ?, ?, ?)', [board, thread, postcount, thumb, subject, timestamp]);
        });
    }
    function getPosts(position) {
        page.loading = true;
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
                page.loading = false;
            }
            if(xhr.readyState === 4) {
                page.postiki = posti
                listView.currentIndex = position
                if(fromfav) {
                    saveFav(borda, tred, posti.length - 1, posti[0].files ? posti[0].files[0].thumbnail : "", posti[0].subject ? posti[0].subject : posti[0].comment, posti[0].timestamp)
                }
            }
        }
        xhr.open("GET", "https://2ch." + domen + "/" + borda + "/res/" + tred + ".json");
        xhr.send();
    }
    function getNewPosts(count, position, ffav, board, thread, postcount, thumb, subject, timestamp) {
        page.newpostsloading = true;
        var xhr = new XMLHttpRequest();
        var posti = []
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.HEADERS_RECEIVED) {
                print('HEADERS_RECEIVED');
            } else if(xhr.readyState === XMLHttpRequest.DONE) {
                var parsed = JSON.parse(xhr.responseText);
                if(parsed.length > 0){
                    page.postiki.push(parsed[0])
                    getNewPosts(count + 1, position, ffav, board, thread, postcount, thumb, subject, timestamp)
                } else {
                    page.postiki = page.postiki
                    page.newpostsloading = false;
                    listView.currentIndex = position
                    if(ffav){
                        saveFav(board, thread, count - 2, thumb, subject, timestamp)
                    }
                }
            }
        }
        xhr.open("GET", "https://2ch." + domen + "/makaba/mobile.fcgi?task=get_thread&board=" + borda + "&thread=" + tred + "&post=" + count);
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
        model: postiki
        header: PageHeader {
            title: borda + "/" + tred
        }
        PushUpMenu {
            MenuItem {
                text: "Получить новые посты"
                onClicked: getNewPosts(listView.count + 1, listView.count - 1, fromfav, borda, tred, listView.count, postiki[0].files ? postiki[0].files[0].thumbnail : "", postiki[0].subject ? postiki[0].subject : postiki[0].comment, postiki[0].timestamp)
            }
            MenuItem {
                text: "Ответить"
                //onClicked: pageStack.push(Qt.resolvedUrl("Webview.qml"), {borda: borda, tred: tred, uri: "https://2ch." + domen + "/contacts.html"} )
            }
        }
        PullDownMenu {
            MenuItem {
                text: "Открыть тред в браузере"
                onClicked: pageStack.push(Qt.openUrlExternally("https://2ch." + domen + "/" + borda + "/res/" + tred + ".html"))
            }
            MenuItem {
                text: "Добавить в избранное"
                onClicked: saveFav(borda, tred, listView.count, postiki[0].files ? postiki[0].files[0].thumbnail : "", postiki[0].subject ? postiki[0].subject : postiki[0].comment, postiki[0].timestamp)
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
                       </style>"  + modelData.comment
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
                        var url = "https://2ch." + domen + "/makaba/mobile.fcgi?task=get_thread&board=" + brd + "&thread=" + trd + "&num=" + pst
                        console.log(url)
                        pageStack.push(Qt.resolvedUrl("Postview.qml"), {url: url, borda: brd, domen: domen} )
                    }
                    else
                        {console.log(link)}
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
        getPosts(anchor)
    }
}
