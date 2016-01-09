function load() {
    var favs = []
    var db = DB.getDatabase();
    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT * FROM favs ORDER BY board ASC, thread ASC');
        for(var i = 0; i < rs.rows.length; i++) {
            favs.push({"board" : rs.rows.item(i).board, "thread" : rs.rows.item(i).thread, "pc" : rs.rows.item(i).postcount, "text" : rs.rows.item(i).subj})
        }
        page.favs = favs
    });
}

function checkfavs (board, thread, postcount, subject, scroll) {
    var db = DB.getDatabase();
    db.transaction(function(tx) {
        var check = tx.executeSql('SELECT * FROM favs WHERE board = ? AND thread = ?;', [board, thread])
        var position = 0
        if (check.rows.length === 1) {
            position = check.rows.item(0).postcount - 1
            console.log(position)
            save(board, thread, postcount, subject)
        }
        if (scroll === true) {
            listView.positionViewAtIndex(position, ListView.Contain)
        }
    });
}

function save(board, thread, postcount, subject) {
    var db = DB.getDatabase();
    db.transaction( function(tx){
        tx.executeSql('INSERT OR REPLACE INTO favs VALUES(?, ?, ?, ?)', [board, thread, postcount, subject]);
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
