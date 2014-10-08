import QtQuick 2.0
import Sailfish.Silica 1.0
import "../js/db.js" as DB

Page {
    property var seting
    function loadSett() {
        var setts = []
        var db = DB.getDatabase();
        db.transaction(function(tx) {
            var rs = tx.executeSql('SELECT * FROM settings');
            for(var i = 0; i < rs.rows.length; i++) {
                setts.push({"key" : rs.rows.item(i).key, "value" : rs.rows.item(i).value})
                console.log(rs.rows.item(i).key + ": " + rs.rows.item(i).value)
            }
            page.seting = setts
        });
    }
    function saveSett(key, value) {
        var db = DB.getDatabase();
        db.transaction( function(tx){
            tx.executeSql('REPLACE INTO settings VALUES(?, ?)', [key, value]);
        });
        loadSett();
    }
    id: page
    SilicaFlickable {
        anchors{
            fill: parent
            topMargin: Theme.paddingLarge * 4
        }
        Column {
            id: column
            width: parent.width
            ComboBox {
                id: domain
                width: page.width
                label: "Домен"
                currentIndex: -1
                menu: ContextMenu {
                    MenuItem { text: "hk" }
                    MenuItem { text: "pm" }
                }
                onCurrentItemChanged: {
                    saveSett("domen", currentItem.text)
                    domain.value = page.seting[0].value
                }
            }
        }
    }
    Component.onCompleted: {
        loadSett()
        domain.value = page.seting[0].value
    }
}
