function getCaptcha(domain) {
    yaca.source = ""
    capchaindicator.visible = true
    var xhr = new XMLHttpRequest();
    var posti = []
    xhr.onreadystatechange = function() {
        if (xhr.readyState === XMLHttpRequest.HEADERS_RECEIVED) {
            print('HEADERS_RECEIVED');
        } else if(xhr.readyState === XMLHttpRequest.DONE) {
            var parsed = xhr.responseText;
            captcha = parsed.match(/(\w{32})/)[1]
            capchaindicator.visible = false
            yaca.source = "https://captcha.yandex.net/image?key=" + captcha
            captcha_value.text = ""
        }
    }
    xhr.open("GET", "https://2ch." + domain + "/makaba/captcha.fcgi");
    xhr.send();
}

function insertTag (start, end, open, close) {
    cmnt.text = cmnt.text.substr(0, start) + open + cmnt.text.substr(start)
    cmnt.text = cmnt.text.substr(0, end + (open).length) + close + cmnt.text.substr(end + (open).length)
}
