function getAll() {
    page.loading = true;
    var xhr = new XMLHttpRequest();
    var threads = []
    xhr.onreadystatechange = function() {
        if (xhr.readyState === XMLHttpRequest.HEADERS_RECEIVED) {
            print('HEADERS_RECEIVED');
        } else if(xhr.readyState === XMLHttpRequest.DONE) {
            var parsed = JSON.parse(xhr.responseText);
            var lalka = parsed["threads"]
            for(var i = 0; i < lalka.length; i++) {
                var post = lalka[i];
                threads.push(post);
            }
            page.loading = false;
        }
        page.threads = threads
    }
    xhr.open("GET", url);
    xhr.send();
}

function getOne (position) {
    page.loading = true;
    var xhr = new XMLHttpRequest();
    var posti = []
    xhr.onreadystatechange = function() {
        if (xhr.readyState === XMLHttpRequest.HEADERS_RECEIVED) {
            print('HEADERS_RECEIVED');
        } else if(xhr.readyState === XMLHttpRequest.DONE) {
            var parsed = JSON.parse(xhr.responseText);
            var lalka = parsed["threads"][0]["posts"]
            for(var i = 0; i < lalka.length; i++) {
                var post = lalka[i];
                posti.push(post);
            }
            page.loading = false;
        }
        if(xhr.readyState === 4) {
            page.posts = posti
            listView.currentIndex = position
            if(fromfav) {
                Favorites.save(board, thread, posti.length - 1, posti[0].files ? posti[0].files[0].thumbnail : "", posti[0].subject ? posti[0].subject : posti[0].comment, posti[0].timestamp)
            }
        }
    }
    xhr.open("GET", "https://2ch." + domain + "/" + board + "/res/" + thread + ".json");
    xhr.send();
}
