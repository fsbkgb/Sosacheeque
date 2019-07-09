.import QtQuick.LocalStorage 2.0 as LS

function openDB() {
    var baza = LS.LocalStorage.openDatabaseSync("sosacheequeDBv3", "", "Database of application Sosacheeque", 100000);
    return baza
}

function initDB() {
    var db = openDB();
    db.transaction(
                function(tx) {

                    try {
                        tx.executeSql('SELECT * FROM settings');
                    } catch(e) {
                        if(e.message.match("no such table")) {
                            tx.executeSql('CREATE TABLE IF NOT EXISTS settings(key TEXT UNIQUE, value TEXT)');
                            tx.executeSql('SELECT * FROM settings');
                            tx.executeSql('INSERT INTO settings VALUES(?, ?)', ["domain", "hk"]);
                            tx.executeSql('INSERT INTO settings VALUES(?, ?)', ["userboards", "show"]);
                        };
                    };

                    try {
                        tx.executeSql('SELECT * FROM favs');
                    } catch(e) {
                        if(e.message.match("no such table")) {
                            tx.executeSql('CREATE TABLE IF NOT EXISTS favs (board TEXT, thread TEXT, postcount INTEGER, subj TEXT, PRIMARY KEY (board, thread))');
                            tx.executeSql('SELECT * FROM favs');
                            tx.executeSql('INSERT INTO favs VALUES(?, ?, ?, ?)', ["mobi", "1336031", 1, "Мобильных девайсов на GNU/Linux тхреад"]);
                            tx.executeSql('INSERT INTO favs VALUES(?, ?, ?, ?)', ["b", "0", 1, "Бред"]);
                        };
                    };

                });
    updateDB();
}

function updateDB() {

    var db = openDB();

    db.transaction(
                function(tx) {
                    var table  = tx.executeSql("SELECT * FROM settings");
                    if (table.rows.length === 2) {
                        tx.executeSql('INSERT INTO settings VALUES(?, ?)', ["captcha", "2ch"]);
                        table  = tx.executeSql("SELECT * FROM settings");
                    };
                    if (table.rows.length === 3) {
                        tx.executeSql('INSERT INTO settings VALUES(?, ?)', ["usercode", ""]);
                        table  = tx.executeSql("SELECT * FROM settings");
                    };
                });

    if(db.version === ""){
        db.changeVersion("","0.3")
    }

    if(db.version === "0.3"){
        try {
            db.changeVersion("0.3","0.4",function(tx){
                tx.executeSql('ALTER TABLE favs ADD COLUMN inhistory INTEGER');
            });
        } catch (e) {
            console.log("changeVersion exception: " + e);
        }
    }

    if(db.version === "0.4"){
        try {
            db.changeVersion("0.4","0.5",function(tx){
                tx.executeSql('ALTER TABLE favs ADD COLUMN visited INTEGER');
            });
        } catch (e) {
            console.log("changeVersion exception: " + e);
        }
    }

    db = openDB();
}
