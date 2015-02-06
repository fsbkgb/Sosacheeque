function getPosts(posti, count, postnums, trd, board, domain, thread) {
    page.loading = true;
    var xhr = new XMLHttpRequest();
    xhr.onreadystatechange = function() {
        if (xhr.readyState === XMLHttpRequest.HEADERS_RECEIVED) {
            print('HEADERS_RECEIVED');
        } else if(xhr.readyState === XMLHttpRequest.DONE) {
            var parsed = JSON.parse(xhr.responseText);
            posti.push(parsed[0]);
            posti.sort(function(a,b) { return parseInt(a.num) - parseInt(b.num) } );
            page.posts = posti;
        }
    }
    xhr.open("GET", "https://2ch." + domain + "/makaba/mobile.fcgi?task=get_thread&board=" + board + "&thread=" + trd + "&num=" + postnums[count]);
    xhr.send();
    count++
    if (count < postnums.length) {
        getPosts (posti, count, postnums, trd, board, domain, thread);
    } else {
        page.loading = false;
    }
}

function getNew(count, position, ffav, board, thread, postcount, thumb, subject, timestamp) {
    page.newpostsloading = true;
    var xhr = new XMLHttpRequest();
    var posti = []
    xhr.onreadystatechange = function() {
        if (xhr.readyState === XMLHttpRequest.HEADERS_RECEIVED) {
            print('HEADERS_RECEIVED');
        } else if(xhr.readyState === XMLHttpRequest.DONE) {
            var parsed = JSON.parse(xhr.responseText);
            if(parsed.length > 0){
                page.posts.push(parsed[0])
                getNew(count + 1, position, ffav, board, thread, postcount, thumb, subject, timestamp)
            } else {
                page.posts = page.posts
                page.newpostsloading = false;
                listView.currentIndex = position
                if(ffav){
                    saveFav(board, thread, count - 2, thumb, subject, timestamp)
                }
            }
        }
    }
    xhr.open("GET", "https://2ch." + domain + "/makaba/mobile.fcgi?task=get_thread&board=" + board + "&thread=" + thread + "&post=" + count);
    xhr.send();
}

function parseLinks (link) {
    var extlink = new RegExp(/^http/)
    var intlink = new RegExp(/^\/[a-z]+\/res\/[0-9]+\.html#[0-9]+/)
    if (link.match(extlink))
    {Qt.openUrlExternally(link)}
    else if (link.match(intlink)){
        var brd = link.match(/([a-z]+)/)[1]
        var trd = link.match(/([0-9]+)/)[1]
        var pst = link.match(/#([0-9]+)/)[1]
        var postnums = []
        postnums.push(pst)
        pageStack.push(Qt.resolvedUrl("../pages/Postview.qml"), {postnums: postnums, trd: trd, board: brd, domain: domain} )
    }
    else
}

function getReplies (postnum, posts, trd, brd, domain) {
    var linkregxp = 'data-num="' + postnum + '"'
    var postnums = []
    postnums.push(postnum)
    for (var i = 0; i < posts.length; i++) {
        if (posts[i].comment.match(linkregxp)) {
            postnums.push(posts[i].num)
        }
    }
    pageStack.push(Qt.resolvedUrl("../pages/Postview.qml"), {postnums: postnums, trd: trd, board: brd, domain: domain, thread: posts} )
}
