import QtQuick 2.0
import Sailfish.Silica 1.0
import "../js/db.js" as DB

Page {
    id: page
    property var razdely
    property bool loading: false
    property var seting
    function loadSett() {
        var setts = []
        var db = DB.getDatabase();
        db.transaction(function(tx) {
            var rs = tx.executeSql('SELECT * FROM settings');
            for(var i = 0; i < rs.rows.length; i++) {
                setts.push({"key" : rs.rows.item(i).key, "value" : rs.rows.item(i).value})
                //console.log(rs.rows.item(i).key + ": " + rs.rows.item(i).value)
            }
            page.seting = setts
        });
    }
    function getBoards() {
        page.loading = true;
        var xhr = new XMLHttpRequest();
        var categories = []
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.HEADERS_RECEIVED) {
                print('HEADERS_RECEIVED');
            } else if(xhr.readyState === XMLHttpRequest.DONE) {
                var parsed = JSON.parse(xhr.responseText);
                for (var category in parsed) {
                    if (parsed.hasOwnProperty(category)) {
                        categories.push(parsed[category])
                    }
                }
                page.razdely = categories
                page.loading = false;
            }
        }
        xhr.open("GET", "https://2ch." + page.seting[0].value + "/makaba/mobile.fcgi?task=get_boards");
        xhr.send();
    }
    BusyIndicator {
        anchors.centerIn: parent
        running: page.loading
        visible: page.loading
        size: BusyIndicatorSize.Large
    }
    SilicaListView {
        id: listView
        visible: !page.loading
        model: razdely
        anchors.fill: parent
        header: PageHeader {
            title: "САСАЧ))"
        }
        PullDownMenu {
            MenuItem {
                text: "Настройки"
                onClicked: pageStack.push(Qt.resolvedUrl("Settings.qml") )
            }
            MenuItem {
                text: "Ввести имя борды"
                onClicked: pageStack.push(Qt.resolvedUrl("Chooseboard.qml"), {domen: page.seting[0].value} )
            }
            MenuItem {
                text: "Избранное"
                onClicked: pageStack.replace(Qt.resolvedUrl("Favorites.qml") )
            }
        }
        delegate: BackgroundItem {
            id: delegate
            height: (rowrow.implicitHeight + razd.implicitHeight  + 15)
            Column {
                id:rowrow
                spacing: 5
                Text {
                    id: razd
                    text: modelData[0].category
                    color: Theme.highlightColor
                    anchors {
                        left: parent.left
                        leftMargin: 5
                    }
                }
                Repeater {
                    id: bordachki
                    model: modelData
                    height: childrenRect.height
                    Label {
                        id: text
                        text: "/" + modelData.id + "/ – " + modelData.name
                        horizontalAlignment: Text.AlignLeft
                        truncationMode: TruncationMode.Fade
                        width: page.width
                        color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
                        anchors{
                            topMargin: 5
                            left: parent.left
                            leftMargin: 5
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: pageStack.push(Qt.resolvedUrl("Tredi.qml"), {url: "https://2ch." + page.seting[0].value + "/" + modelData.id + "/index.json", borda: modelData.id, pages: modelData.pages, domen: page.seting[0].value} )
                        }
                    }
                }
            }
        }
        VerticalScrollDecorator {}
    }
    Component.onCompleted: {
        DB.openDB()
        loadSett()
        getBoards()
    }
}
