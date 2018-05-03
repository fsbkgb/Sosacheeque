.import QtQuick.LocalStorage 2.0 as LS

function getDatabase() {
    return LS.LocalStorage.openDatabaseSync("sosacheequeDBv3", "0.3", "Database of application Sosacheeque", 100000);
}

function openDB() {
    var db = getDatabase();
    db.transaction(
                function(tx) {
                    tx.executeSql('CREATE TABLE IF NOT EXISTS settings(key TEXT UNIQUE, value TEXT)');
                    var table2  = tx.executeSql("SELECT * FROM settings");
                    if (table2.rows.length === 0) {
                        tx.executeSql('INSERT INTO settings VALUES(?, ?)', ["domain", "hk"]);
                        tx.executeSql('INSERT INTO settings VALUES(?, ?)', ["userboards", "show"]);
                    };
                    if (table2.rows.length === 2) {
                        tx.executeSql('INSERT INTO settings VALUES(?, ?)', ["captcha", "2ch"]);
                    };
                    try {
                        tx.executeSql('SELECT * FROM favs');
                    } catch(e) {
                        if(e.message.match("no such table")) {
                            console.log("such favs much tabel")
                            tx.executeSql('CREATE TABLE IF NOT EXISTS favs (board TEXT, thread TEXT, postcount INTEGER, subj TEXT, PRIMARY KEY (board, thread))');
                            tx.executeSql("SELECT * FROM favs");
                            tx.executeSql('INSERT INTO favs VALUES(?, ?, ?, ?)', ["mobi", "1336031", 1, "Мобильных девайсов на GNU/Linux тхреад"]);
                            tx.executeSql('INSERT INTO favs VALUES(?, ?, ?, ?)', ["b", "0", 1, "Бред"]);
                        };
                    };
                });
}
