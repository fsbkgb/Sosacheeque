function getAll() {
    page.loading = true;
    var xhr = new XMLHttpRequest();
    var categories = []
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
            pageStack.replace(Qt.resolvedUrl("../pages/Posts.qml"), {url: "https://2ch." + domain + "/" + board + "/index.json", board: board, pages: parsed.pages.length, domain: domain, state: "board"} )
        }
    }
    xhr.open("GET", "https://2ch." + domain + "/" + board + "/index.json");
    xhr.send();
}
