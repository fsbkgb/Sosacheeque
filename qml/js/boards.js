function getAll() {
    var db = DB.getDatabase();
    page.loading = true;
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
    py.call('getdata.dyorg', ["https://2ch." + page.option[0].value + "/makaba/mobile.fcgi?task=get_boards"], function(response) {
        if (response.error === "none") {
            var parsed = JSON.parse(response.response);
            for (var category in parsed) {
                if (parsed.hasOwnProperty(category)) {
                    if (page.option[1].value === "hide" & category === "Пользовательские") {} else {
                        categories.push(parsed[category])
                    }
                }
            }
        } else {
            console.log(response.error)
        }
        page.categories = categories
        page.loading = false;
    })
}

function getOne(board, action, pagenum) {
    var categories = []
    py.call('getdata.dyorg', ["https://2ch." + domain + "/" + board + "/" + pagenum + ".json"], function(response) {
        if (response.error === "none") {
            var parsed = JSON.parse(response.response);
            var firsticon = [{name: "None", num: -1}]
            var othericons = parsed.icons
            var icons = firsticon.concat(othericons)
            var enable_icons = parsed.enable_icons
            var enable_names = parsed.enable_names
            var current_page = parsed.current_page
            if (current_page === 0) {
                current_page = "index"
            }
            var enable_subject = parsed.enable_subject
            if (action === "replace") {
                pageStack.replace(Qt.resolvedUrl("../pages/Posts.qml"), {parsedthreads: parsed["threads"], board: board, pages: parsed.pages.length, domain: domain, state: "board", boardname: parsed.BoardName, icons: icons, enable_icons: enable_icons, enable_names: enable_names, enable_subject: enable_subject, currentpage: current_page} )
            } else {
                pageStack.push(Qt.resolvedUrl("../pages/Posts.qml"), {parsedthreads: parsed["threads"], board: board, pages: parsed.pages.length, domain: domain, state: "board", boardname: parsed.BoardName, icons: icons, enable_icons: enable_icons, enable_names: enable_names, enable_subject: enable_subject, currentpage: current_page } )
            }
            page.somethingloading = false
        } else {
            page.notification = "Error: " + response.error
            page.somethingloading = false
            page.someerror = true
            page.somethingloading = true
            py.call('getdata.timeout', [2], function() {
                page.someerror = false
                page.somethingloading = false
            })
        }
    })
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
