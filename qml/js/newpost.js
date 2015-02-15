function getCaptcha(domain) {
    var xhr = new XMLHttpRequest();
    var posti = []
    xhr.onreadystatechange = function() {
        if (xhr.readyState === XMLHttpRequest.HEADERS_RECEIVED) {
            print('HEADERS_RECEIVED');
        } else if(xhr.readyState === XMLHttpRequest.DONE) {
            var parsed = xhr.responseText;
            page.captcha = parsed.match(/(\w{32})/)[1]
        }
    }
    xhr.open("GET", "https://2ch." + domain + "/makaba/captcha.fcgi");
    xhr.send();
}
