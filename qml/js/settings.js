function load(key) {
    var setts = []
    var db = DB.openDB();
    var value
    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT * FROM settings WHERE key = ?', key);
        value = rs.rows.item(0).value
    });
    return value
}

function save(key, value) {
    var db = DB.openDB();
    db.transaction( function(tx){
        tx.executeSql('REPLACE INTO settings VALUES(?, ?)', [key, value]);
    });
}
