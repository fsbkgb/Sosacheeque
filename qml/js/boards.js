function getAll() {
    var db = DB.getDatabase();
    page.loading = true;
    var xhr = new XMLHttpRequest();
    var categories = []
    var favbds = []
    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT * FROM favbrds ORDER BY id ASC');
        for(var i = 0; i < rs.rows.length; i++) {
            favbds.push({"id" : rs.rows.item(i).id, "name" : rs.rows.item(i).name, "category" : rs.rows.item(i).category})
        }
        if (favbds.length > 0) {
            categories.push(JSON.parse(JSON.stringify(favbds)))
        }
    });
    xhr.onreadystatechange = function() {
        if (xhr.readyState === XMLHttpRequest.HEADERS_RECEIVED) {
            print('HEADERS_RECEIVED');
        } else if(xhr.readyState === XMLHttpRequest.DONE) {
            var parsed = JSON.parse(xhr.responseText);
            for (var category in parsed) {
                if (parsed.hasOwnProperty(category)) {
                    if (page.option[1].value === "hide" & category === "Пользовательские") {} else {
                        categories.push(parsed[category])
                    }
                }
            }
            page.categories = categories
            page.loading = false;
        }
    }
    xhr.open("GET", "https://2ch." + page.option[0].value + "/makaba/mobile.fcgi?task=get_boards");
    xhr.send();
}

function getOne(board) {
    var xhr = new XMLHttpRequest();
    var categories = []
    xhr.onreadystatechange = function() {
        if (xhr.readyState === XMLHttpRequest.HEADERS_RECEIVED) {
            print('HEADERS_RECEIVED');
        } else if(xhr.readyState === XMLHttpRequest.DONE) {
            var parsed = JSON.parse(xhr.responseText);
            var firsticon = [{name: "None", num: -1}]
            var othericons = parsed.icons
            var icons = firsticon.concat(othericons)
            var enable_icons = parsed.enable_icons
            var enable_names = parsed.enable_names
            var enable_subject = parsed.enable_subject
            pageStack.push(Qt.resolvedUrl("../pages/Posts.qml"), {url: "https://2ch." + domain + "/" + board + "/index.json", board: board, pages: parsed.pages.length, domain: domain, state: "board", boardname: parsed.BoardName, icons: icons, enable_icons: enable_icons, enable_names: enable_names, enable_subject: enable_subject } )
        }
    }
    xhr.open("GET", "https://2ch." + domain + "/" + board + "/index.json");
    xhr.send();
}

function fav(id, name) {
    var db = DB.getDatabase();
    db.transaction( function(tx){
        tx.executeSql('INSERT OR REPLACE INTO favbrds VALUES(?, ?, ?)', [id, name, "Избранное"]);
    });
}

function unfav(id) {
    var favs = []
    var db = DB.getDatabase();
    db.transaction(function(tx) {
        var rs = tx.executeSql('DELETE FROM favbrds WHERE id = ?;', [id]);
    });
    getAll()
}
