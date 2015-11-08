function getCaptcha(domain, thread) {
    var url = "https://2ch." + domain + "/makaba/captcha.fcgi?type=2chaptcha"
    if (thread !== "0") {
        url = "https://2ch." + domain + "/makaba/captcha.fcgi?type=2chaptcha&action=thread"
    }
    yaca.visible = true
    captcha_value.visible = true
    yaca.source = ""
    capchaindicator.visible = true
    py.call('getdata.dyorg', [url], function(response) {
            captcha = response.response.match(/(\w{56})/)[1]
            capchaindicator.visible = false
            yaca.source = "https://2ch." + domain + "/makaba/captcha.fcgi?type=2chaptcha&action=image&id=" + captcha
            captcha_value.text = ""
        })
}

function insertTag (start, end, open, close) {
    cmnt.text = cmnt.text.substr(0, start) + open + cmnt.text.substr(start)
    cmnt.text = cmnt.text.substr(0, end + (open).length) + close + cmnt.text.substr(end + (open).length)
}
