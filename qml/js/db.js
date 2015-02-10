.import QtQuick.LocalStorage 2.0 as LS

function getDatabase() {
    return LS.LocalStorage.openDatabaseSync("sosacheequeDBv1", "0.1", "Database of application Sosacheeque", 100000);
}

function openDB() {
    var db = getDatabase();
    db.transaction(
                function(tx) {
                    tx.executeSql('CREATE TABLE IF NOT EXISTS favs(board TEXT, thread TEXT, postcount INTEGER, thumb TEXT, subj TEXT, timestamp INTEGER UNIQUE)');
                    var table1  = tx.executeSql("SELECT * FROM favs");
                    if (table1.rows.length === 0) {
                        tx.executeSql('INSERT INTO favs VALUES(?, ?, ?, ?, ?, ?)', ["mobi", "450132", 1, "thumb/450132/14224052543470s.jpg", "Jolla&Sailfish", 1422405254]);
                    };
                    tx.executeSql('CREATE TABLE IF NOT EXISTS settings(key TEXT UNIQUE, value TEXT)');
                    var table2  = tx.executeSql("SELECT * FROM settings");
                    if (table2.rows.length === 0) {
                        tx.executeSql('INSERT INTO settings VALUES(?, ?)', ["domain", "hk"]);
                        tx.executeSql('INSERT INTO settings VALUES(?, ?)', ["userboards", "show"]);
                    };
                });
}
