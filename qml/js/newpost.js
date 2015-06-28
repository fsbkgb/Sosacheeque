function getCaptcha(domain) {
    yaca.source = ""
    capchaindicator.visible = true
    py.call('getdata.dyorg', ["https://2ch." + domain + "/makaba/captcha.fcgi"], function(response) {
        captcha = response.match(/(\w{32})/)[1]
        capchaindicator.visible = false
        yaca.source = "https://captcha.yandex.net/image?key=" + captcha
        captcha_value.text = ""
    })
}

function insertTag (start, end, open, close) {
    cmnt.text = cmnt.text.substr(0, start) + open + cmnt.text.substr(start)
    cmnt.text = cmnt.text.substr(0, end + (open).length) + close + cmnt.text.substr(end + (open).length)
}
