function getAll(parsedthreads) {
    var threads = []
    for(var i = 0; i < parsedthreads.length; i++) {
        threads.push(parsedthreads[i]);
    }
    page.loading = false;
    page.parsedposts = threads
    listView.model = page.parsedposts
}

function getThread (url, anchor, fromfav) {
    py.call('getdata.dyorg', [url], function(response) {
        var posti = []
        if (response.error === "none") {
            var parsed = JSON.parse(response.response)
            parsedthreads = parsed["threads"][0]["posts"]
            var firsticon = [{name: "None", num: -1}]
            var othericons = parsed.icons
            var icons = firsticon.concat(othericons)
            var enable_icons = parsed.enable_icons
            var enable_names = parsed.enable_names
            var enable_subject = parsed.enable_subject
            pageStack.push(Qt.resolvedUrl("../pages/Posts.qml"), {parsedthreads: parsedthreads, thread: parsed.current_thread, board: board, domain: page.option[0].value, anchor: anchor, fromfav: fromfav, state: "thread", icons: icons, enable_icons: enable_icons, enable_names: enable_names, enable_subject: enable_subject} )
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

function parseThread (position) {
    var posti = []
    for(var i = 0; i < parsedthreads.length; i++) {
        posti.push(parsedthreads[i]);
    }
    page.loading = false;
    page.parsedposts = posti
    listView.model = page.parsedposts
    listView.positionViewAtIndex(position, ListView.End)
    if(fromfav) {
        Favorites.save(board, thread, posti.length - 1, posti[0].files ? posti[0].files[0].thumbnail : "", posti[0].subject ? posti[0].subject : posti[0].comment, posti[0].timestamp)
        var favsPage = pageStack.find(function(page) { return page.objectName == "favsPage"; })
        favsPage.loadfavs()
    }
}

function truncateOP (text){
    if (text.length>700){
        return(text.substr(0,699)+'&hellip;')
    } else {
        return(text)
    }
}
