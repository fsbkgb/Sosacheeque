function getCaptcha(domain) {
    var url = "https://2ch." + domain + "/makaba/captcha.fcgi?type=2chaptcha"
    yaca.visible = true
    captcha_value.visible = true
    yaca.source = ""
    capchaindicator.visible = true
    py.call('getdata.dyorg', ["captcha", "none", url], function() {})
    captcha_value.text = ""
    captcha_value.focus = true
}

function insertTag (start, end, open, close) {
    cmnt.text = cmnt.text.substr(0, start) + open + cmnt.text.substr(start)
    cmnt.text = cmnt.text.substr(0, end + (open).length) + close + cmnt.text.substr(end + (open).length)
}
