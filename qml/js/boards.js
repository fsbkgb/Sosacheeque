function getAll(error, data) {
    var categories = []
    var parsedboards = []
    if (error === "none") {
        var parsed = JSON.parse(data);
        for (var category in parsed) {
            if (parsed.hasOwnProperty(category)) {
                if (page.option[1].value === "hide" & category === "Пользовательские") {} else {
                    categories.push(parsed[category])
                }
            }
        }
        for (var i = 0; i < categories.length; i++) {
            var object = categories[i];
            for (var property in object) {
                parsedboards.push(object[property]);
            }
        }
        function compare(a,b) {
            if (a.id < b.id)
                return -1;
            if (a.id > b.id)
                return 1;
            return 0;
        }
        page.categories = parsedboards.sort(compare)
        page.loading = false
    } else {
        page.loading = false
        page.error = "Error: " + error
    }
}

function getOne(error, data, action) {
    console.log(action)
    var categories = []
    if (error === "none") {
        var parsed = JSON.parse(data);
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
            pageStack.replace(Qt.resolvedUrl("../pages/Posts.qml"), {parsedthreads: parsed["threads"], board: parsed.Board, pages: parsed.pages.length, domain: domain, state: "board", boardname: parsed.BoardName, icons: icons, enable_icons: enable_icons, enable_names: enable_names, enable_subject: enable_subject, currentpage: current_page} )
        } else {
            pageStack.push(Qt.resolvedUrl("../pages/Posts.qml"), {parsedthreads: parsed["threads"], board: parsed.Board, pages: parsed.pages.length, domain: domain, state: "board", boardname: parsed.BoardName, icons: icons, enable_icons: enable_icons, enable_names: enable_names, enable_subject: enable_subject, currentpage: current_page } )
        }
        page.somethingloading = false
    } else {
        page.notification = "Error: " + error
        page.somethingloading = false
        page.someerror = true
        page.somethingloading = true
        py.call('getdata.timeout', [2], function() {
            page.someerror = false
            page.somethingloading = false
        })
    }
}

function fav(id, name) {
    var db = DB.getDatabase();
    db.transaction( function(tx){
        tx.executeSql('INSERT OR REPLACE INTO favs VALUES(?, ?, ?, ?)', [id, "0", 1, name]);
    });
    var favsPage = pageStack.find(function(page) { return page.objectName == "favsPage"; })
    favsPage.loadfavs()
}
