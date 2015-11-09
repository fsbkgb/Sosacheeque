.import QtQuick.LocalStorage 2.0 as LS

function getDatabase() {
    return LS.LocalStorage.openDatabaseSync("sosacheequeDBv1", "0.1", "Database of application Sosacheeque", 100000);
}

function openDB() {
    var db = getDatabase();
    db.transaction(
                function(tx) {
                    tx.executeSql('CREATE TABLE IF NOT EXISTS settings(key TEXT UNIQUE, value TEXT)');
                    var table2  = tx.executeSql("SELECT * FROM settings");
                    if (table2.rows.length === 0) {
                        tx.executeSql('INSERT INTO settings VALUES(?, ?)', ["domain", "pm"]);
                        tx.executeSql('INSERT INTO settings VALUES(?, ?)', ["userboards", "show"]);
                    };
                    try {
                        tx.executeSql('SELECT * FROM favs;');
                    } catch(e) {
                        if(e.message.match("no such table")) {
                            console.log("such favs much tabel")
                            tx.executeSql('CREATE TABLE IF NOT EXISTS favs(board TEXT, thread TEXT, postcount INTEGER, thumb TEXT, subj TEXT, timestamp INTEGER UNIQUE)');
                            tx.executeSql("SELECT * FROM favs");
                            tx.executeSql('INSERT INTO favs VALUES(?, ?, ?, ?, ?, ?)', ["mobi", "521312", 1, "thumb/521312/14314630923310s.jpg", "Jolla-тред", 1431463092]);
                        };
                    };
                    try {
                        tx.executeSql('SELECT * FROM favbrds;');
                    } catch(e) {
                        if(e.message.match("no such table")) {
                            console.log("such favbrds much table")
                            tx.executeSql('CREATE TABLE IF NOT EXISTS favbrds(id TEXT UNIQUE, name TEXT, category TEXT)');
                            tx.executeSql("SELECT * FROM favbrds");
                            tx.executeSql('INSERT INTO favbrds VALUES(?, ?, ?)', ["b", "Бред", "Избранное"]);
                        };
                    };
                });
}
