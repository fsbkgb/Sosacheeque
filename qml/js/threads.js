function getAll() {
    py.call('getdata.dyorg', [url], function(response) {
        var threads = []
        var parsed = JSON.parse(response);
        var parsedthreads = parsed["threads"]
        for(var i = 0; i < parsedthreads.length; i++) {
            threads.push(parsedthreads[i]);
        }
        page.loading = false;
        page.parsedposts = threads
        listView.model = page.parsedposts
    })
}

function getOne (position) {
    py.call('getdata.dyorg', ["https://2ch." + domain + "/" + board + "/res/" + thread + ".json"], function(response) {
        var posti = []
        var parsed = JSON.parse(response);
        var parsedthread = parsed["threads"][0]["posts"]
        for(var i = 0; i < parsedthread.length; i++) {
            posti.push(parsedthread[i]);
        }
        var firsticon = [{name: "None", num: -1}]
        var othericons = parsed.icons
        page.icons = firsticon.concat(othericons)
        page.enable_icons = parsed.enable_icons
        page.enable_names = parsed.enable_names
        page.enable_subject = parsed.enable_subject
        page.loading = false;
        page.parsedposts = posti
        listView.model = page.parsedposts
        listView.positionViewAtIndex(position, ListView.End)
        if(fromfav) {
            Favorites.save(board, thread, posti.length - 1, posti[0].files ? posti[0].files[0].thumbnail : "", posti[0].subject ? posti[0].subject : posti[0].comment, posti[0].timestamp)
            var favsPage = pageStack.find(function(page) { return page.objectName == "favsPage"; })
            favsPage.loadfavs()
        }
    })
}

function truncateOP (text){
    if (text.length>700){
        return(text.substr(0,699)+'&hellip;')
    } else {
        return(text)
    }
}
