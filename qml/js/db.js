function openDB() {
    db = LocalStorage.openDatabaseSync("favdb2", "0.1", "Favorites", 100000);
    if(db !== null) return;
    try {
        db.transaction(function(tx){
            tx.executeSql('CREATE TABLE IF NOT EXISTS favs(board TEXT, thread TEXT, postcount INTEGER, thumb TEXT, subj TEXT, timestamp INTEGER UNIQUE)');
            var table  = tx.executeSql("SELECT * FROM favs");
            if (table.rows.length === 0) {
                tx.executeSql('INSERT INTO favs VALUES(?, ?, ?, ?, ?, ?)', ["mobi", "266094", 1, "https://2ch.hk/mobi/thumb/266094/1398715403880s.gif", "В лесу родилась Jollaчка", 1398715403]);
                console.log('Favorites table added');
            };
        });
    } catch (err) {
        console.log("Error creating table in database: " + err);
    };
}
