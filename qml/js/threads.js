function getAll(parsedthreads) {
    var threads = []
    for(var i = 0; i < parsedthreads.length; i++) {
        threads.push(parsedthreads[i]);
    }
    page.loading = false;
    page.parsedposts = threads
    listView.model = page.parsedposts
}

function getThread (error, data) {
    var posti = []
    if (error === "none") {
        var parsed = JSON.parse(data)
        parsedthreads = parsed["threads"][0]["posts"]
        var firsticon = [{name: "None", num: -1}]
        var othericons = parsed.icons
        var icons = firsticon.concat(othericons)
        var enable_icons = parsed.enable_icons
        var enable_names = parsed.enable_names
        var enable_subject = parsed.enable_subject
        pageStack.push(Qt.resolvedUrl("../pages/Posts.qml"), {parsedthreads: parsedthreads, thread: parsed.current_thread, board: board, domain: page.option[0].value, state: "thread", icons: icons, enable_icons: enable_icons, enable_names: enable_names, enable_subject: enable_subject} )
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

function parseThread () {
    var posti = []
    for(var i = 0; i < parsedthreads.length; i++) {
        posti.push(parsedthreads[i]);
    }
    page.loading = false;
    page.parsedposts = posti
    listView.model = page.parsedposts
    Favorites.checkfavs(board, thread, posti.length, posti[0].subject ? posti[0].subject : posti[0].comment, true)
}

function truncateOP (text){
    if (text.length>700){
        return(text.substr(0,699)+'&hellip;')
    } else {
        return(text)
    }
}
