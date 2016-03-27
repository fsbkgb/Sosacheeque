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

function checkfavs (board, thread, lastpost, scroll) {
    var db = DB.getDatabase();
    db.transaction(function(tx) {
        var check = tx.executeSql('SELECT * FROM favs WHERE board = ? AND thread = ?;', [board, thread])
        var position = 0
        if (check.rows.length === 1) {
            var title = check.rows.item(0).subj
            anch = check.rows.item(0).postcount
            save(board, thread, lastpost, title)
        }
        if (scroll === true) {
            for (var i = 0; i < parsedposts.length; i++) {
                if (parsedposts[i].num <= anch){
                    position = i
                }
            }
            listView.positionViewAtIndex(position, ListView.Contain)
        }
    });
}

function save(board, thread, lastpost, subject) {
    var db = DB.getDatabase();
    db.transaction( function(tx){
        tx.executeSql('INSERT OR REPLACE INTO favs VALUES(?, ?, ?, ?)', [board, thread, lastpost, subject]);
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
