function load() {
    var setts = []
    var db = DB.getDatabase();
    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT * FROM settings ORDER BY key ASC');
        for(var i = 0; i < rs.rows.length; i++) {
            setts.push({"key" : rs.rows.item(i).key, "value" : rs.rows.item(i).value})
        }
        page.option = setts
    });
}

function save(key, value) {
    var db = DB.getDatabase();
    db.transaction( function(tx){
        tx.executeSql('REPLACE INTO settings VALUES(?, ?)', [key, value]);
    });
    load();
}
