function getPosts(posti, count, postnums, trd, board, domain, thread) {
    for (var i = 0; i < thread.length; i++) {
        if (thread[i].num.toString().match(postnums[count])){
            posti.push(thread[i])
            posti.sort(function(a,b) { return parseInt(a.num) - parseInt(b.num) } )
            page.parsedreplies = posti
        }
    }
    count++
    if (count < postnums.length) {
        getPosts (posti, count, postnums, trd, board, domain, thread);
    } else {
        listView.model = page.parsedreplies
        page.loading = false;
    }
}

function getNew(error, data, count, board, thread, lastpost) {
    var posti = []
    if (error === "none") {
        var parsed = JSON.parse(data)
        if(parsed.length > 0){
            for (var i = 0; i < parsed.length; i++) {
                page.parsedposts.push(parsed[i])
                page.parsedposts = page.parsedposts
            }
            listView.model = page.parsedposts
            listView.positionViewAtIndex(count, ListView.Contain)
            Favorites.checkfavs(board, thread, lastpost, false)
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

function parseLinks (link, thread) {
    var intlink = new RegExp(/(https?:\/\/2ch.(hk|pm)|^)\/[0-9a-z]+\/res\/[0-9]+\.html(#[0-9]+)?/)
    if (link.match(intlink)){
        link = link.replace(/https?:\/\/2ch.(hk|pm)/g,"")
        var brd = link.match(/\/([0-9a-z]+)\//)[1]
        brd = brd.replace(/\//g,"")
        var trd = link.match(/([0-9]+\.)/)[1]
        trd = trd.replace(/\./g,"")
        try{
            var pst = link.match(/#([0-9]+)/)[1]
        } catch (err) {
            pst = trd
        }
        var postnums = []
        postnums.push(pst)
        if (thread === trd) {
            pageStack.push(Qt.resolvedUrl("../pages/Posts.qml"), {postnums: postnums, thread: trd, board: brd, domain: domain, parsedposts: parsedposts, state: "replies", icons: icons} )
        } else {
            notification = qsTr("Opening thread")
            page.somethingloading = true
            py.call('getdata.dyorg', ['thread_page'+numnum, "thread", "https://2ch." + domain + "/" + brd + "/res/" + trd + ".json#" + pst, ""], function() {})
        }
    } else {
        Qt.openUrlExternally(link)
    }
}

function getReplies (postnum, posts) {
    var linkregxp = 'data-num="' + postnum + '"'
    var postnums = []
    postnums.push(postnum)
    for (var i = 0; i < posts.length; i++) {
        if (posts[i].comment.match(linkregxp)) {
            postnums.push(posts[i].num)
        }
    }
    return postnums
}

function checkReplies (postnum, posts) {
    var linkregxp = 'data-num="' + postnum + '"'
    var r = 0
    for (var i = 0; i < posts.length; i++) {
        if (posts[i].comment.match(linkregxp))
            r++
    }
    return r
}
