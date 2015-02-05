function getOne(url) {
    page.loading = true;
    var xhr = new XMLHttpRequest();
    var posti = []
    xhr.onreadystatechange = function() {
        if (xhr.readyState === XMLHttpRequest.HEADERS_RECEIVED) {
            print('HEADERS_RECEIVED');
        } else if(xhr.readyState === XMLHttpRequest.DONE) {
            var parsed = JSON.parse(xhr.responseText);
            posti.push(parsed[0]);
            page.loading = false;
        }
        page.posts = posti
    }
    xhr.open("GET", url);
    xhr.send();
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
        var url = "https://2ch." + domain + "/makaba/mobile.fcgi?task=get_thread&board=" + brd + "&thread=" + trd + "&num=" + pst
        console.log(url)
        pageStack.push(Qt.resolvedUrl("../pages/Postview.qml"), {url: url, board: brd, domain: domain} )
    }
    else
    {console.log(link)}
}
