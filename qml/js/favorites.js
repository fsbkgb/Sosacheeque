function load() {
    var favs = []
    var db = DB.getDatabase();
    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT * FROM favs ORDER BY board ASC, thread ASC');
        for(var i = 0; i < rs.rows.length; i++) {
            favs.push({"board" : rs.rows.item(i).board, "thread" : rs.rows.item(i).thread, "pc" : rs.rows.item(i).postcount, "tmb" : rs.rows.item(i).thumb, "text" : rs.rows.item(i).subj})
        }
        page.favs = favs
    });
}

function save(board, thread, postcount, thumb, subject, timestamp) {
    var db = DB.getDatabase();
    db.transaction( function(tx){
        tx.executeSql('INSERT OR REPLACE INTO favs VALUES(?, ?, ?, ?, ?, ?)', [board, thread, postcount, thumb, subject, timestamp]);
    });
    var favsPage = pageStack.find(function(page) { return page.objectName == "favsPage"; })
    favsPage.loadfavs()
}

function del(board, thread) {
    var favs = []
    var db = DB.getDatabase();
    db.transaction(function(tx) {
        var rs = tx.executeSql('DELETE FROM favs WHERE board = ? AND thread = ?;', [board, thread]);
    });
    load();
}
