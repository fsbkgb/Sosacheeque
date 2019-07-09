function load(state) {
    var favs = []
    var db = DB.openDB();
    db.transaction(function(tx) {
        var rs = []
        if (state !== "history") {
            rs = tx.executeSql('SELECT * FROM favs WHERE inhistory IS NULL OR inhistory = 0 ORDER BY board ASC, thread ASC');
        } else {
            rs = tx.executeSql('SELECT * FROM favs WHERE inhistory = 1 ORDER BY visited DESC');
        }
        for(var i = 0; i < rs.rows.length; i++) {
            console.log(rs.rows.item(i).inhistory)
            favs.push({"board" : rs.rows.item(i).board, "thread" : rs.rows.item(i).thread, "pc" : rs.rows.item(i).postcount, "text" : rs.rows.item(i).subj})
        }
        page.favs = favs
    });
}

function checkfavs (board, thread, lastpost, scroll, header) {
    var db = DB.openDB();
    db.transaction(function(tx) {
        var check = tx.executeSql('SELECT * FROM favs WHERE board = ? AND thread = ?;', [board, thread])
        var position = 0
        if (check.rows.length === 1) {
            var title = check.rows.item(0).subj
            var inhistory = 0
            anch = check.rows.item(0).postcount
            if (check.rows.item(0).inhistory === 1) {
                inhistory = 1
            }
            save(board, thread, lastpost, title, inhistory)
        } else {
            save(board, thread, lastpost, header, 1)
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

function save(board, thread, lastpost, subject, history) {
    var db = DB.openDB();
    if (subject === "") { subject = "No title" }
    db.transaction( function(tx){
        tx.executeSql('INSERT OR REPLACE INTO favs VALUES(?, ?, ?, ?, ?, ?)', [board, thread, lastpost, subject, history, Date.now()]);
    });
    var favsPage = pageStack.find(function(page) { return page.objectName === "favsPage"; })
    favsPage.loadfavs()
}

function del(board, thread) {
    var favs = []
    var db = DB.openDB();
    db.transaction(function(tx) {
        var rs = tx.executeSql('DELETE FROM favs WHERE board = ? AND thread = ?;', [board, thread]);
    });
    load();
}
