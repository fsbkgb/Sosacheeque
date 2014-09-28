import QtQuick 2.0
import QtQuick.LocalStorage 2.0
import Sailfish.Silica 1.0

Page {
    id: page
    property string borda: ""
    property string tred: ""
    property int pc
    property var favs
    property var db: null
    function openDB() {
        if(db !== null) return;
        db = LocalStorage.openDatabaseSync("favdb2", "0.1", "Favorites", 100000);
        try {
            db.transaction(function(tx){
                tx.executeSql('CREATE TABLE IF NOT EXISTS favs(board TEXT, thread TEXT, postcount INTEGER, thumb TEXT, subj TEXT, timestamp INTEGER UNIQUE)');
                var table  = tx.executeSql("SELECT * FROM favs");
                if (table.rows.length === 0) {
                    tx.executeSql('INSERT INTO favs VALUES(?, ?, ?, ?, ?)', ["mobi", "266094", 1, "https://2ch.hk/mobi/thumb/266094/1398715403880s.gif", "В лесу родилась Jollaчка", 1398715403]);
                    console.log('Favorites table added');
                };
            });
        } catch (err) {
            console.log("Error creating table in database: " + err);
        };
    }
    function loadFav() {
        var favs = []
        openDB();
        db.transaction(function(tx) {
            var rs = tx.executeSql('SELECT * FROM favs ORDER BY board ASC, thread ASC');
            for(var i = 0; i < rs.rows.length; i++) {
                favs.push({"borda" : rs.rows.item(i).board, "tred" : rs.rows.item(i).thread, "pc" : rs.rows.item(i).postcount, "tmb" : rs.rows.item(i).thumb, "text" : rs.rows.item(i).subj})
            }
            page.favs = favs
        });
    }
    function delFav(board, thread) {
        var favs = []
        openDB();
        db.transaction(function(tx) {
            var rs = tx.executeSql('DELETE FROM favs WHERE board = ? AND thread = ?;', [board, thread]);
            loadFav();
        });
    }
    SilicaListView {
        anchors{
            fill: parent
        }
        spacing: 16
        id: listView
        model: page.favs
        header: PageHeader {
            title: "Избранное"
        }
        PullDownMenu {
            MenuItem {
                text: "Список борд"
                onClicked: pageStack.replace(Qt.resolvedUrl("Bordi.qml") )
            }
        }
        delegate: ListItem {
            id: delegate
            height: pic.implicitHeight > (text.implicitHeight + url.implicitHeight) ? pic.implicitHeight : (text.implicitHeight + url.implicitHeight)
            Image {
                id: pic
                source: modelData.tmb
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingSmall
                }
                Label {
                    id: url
                    text: modelData.borda + "/" + modelData.tred
                    width: parent.width
                    font.pixelSize :Theme.fontSizeTiny
                    color: Theme.secondaryHighlightColor
                    anchors {
                        left: parent.right
                        leftMargin: Theme.paddingSmall
                    }

                }
                Label {
                    id: text
                    text: modelData.text
                    width: page.width - 2 * Theme.paddingSmall - parent.width
                    font.pixelSize :Theme.fontSizeExtraSmall
                    color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
                    maximumLineCount: 1
                    horizontalAlignment: Text.AlignLeft
                    truncationMode: TruncationMode.Fade
                    anchors {
                        left: parent.right
                        leftMargin: Theme.paddingSmall
                        top: url.bottom
                        topMargin: Theme.paddingSmall
                    }
                }
            }
            IconButton {
                icon.source: "image://theme/icon-m-clear"
                anchors {
                    right: parent.right
                }
                onClicked: delFav(modelData.borda, modelData.tred)
            }
            onClicked: pageStack.push(Qt.resolvedUrl("Tred.qml"), {tred: modelData.tred, borda: modelData.borda} )
        }
        VerticalScrollDecorator {}
    }
    Component.onCompleted: {
        loadFav()
    }
}
