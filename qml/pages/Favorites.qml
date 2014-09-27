import QtQuick 2.0
import QtQuick.LocalStorage 2.0
import Sailfish.Silica 1.0

Page {
    id: page
    property string borda: ""
    property string tred: ""
    property int pc
    property int pages
    property var favs
    property var db: null
    function openDB() {
        if(db !== null) return;
        db = LocalStorage.openDatabaseSync("favdb", "0.1", "Favorites", 100000);
        try {
            db.transaction(function(tx){
                tx.executeSql('CREATE TABLE IF NOT EXISTS favs(board TEXT, thread TEXT, postcount INTEGER)');
                var table  = tx.executeSql("SELECT * FROM favs");
                if (table.rows.length === 0) {
                    tx.executeSql('INSERT INTO favs VALUES(?, ?, ?)', ["mobi", "266094", 1]);
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
                favs.push({"borda" : rs.rows.item(i).board, "tred" : rs.rows.item(i).thread, "pc" : rs.rows.item(i).postcount})
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
        id: listView
        model: page.favs
        header: PageHeader {
            title: "Избранное"
        }
        delegate: ListItem {
            id: delegate
            menu: contextMenuComponent
            Label {
                id: text
                text: modelData.borda + "/" + modelData.tred
                width: parent.width
                color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
            }
            Component {
                id: contextMenuComponent
                ContextMenu {
                    MenuItem {
                        text: "Удалить"
                        onClicked: delFav(modelData.borda, modelData.tred)
                    }
                }
            }
            onClicked: pageStack.push(Qt.resolvedUrl("Tred.qml"), {tred: modelData.tred, borda: modelData.borda} )
        }
        VerticalScrollDecorator {}
    }
    Component.onCompleted: {
        loadFav()
    }
}
