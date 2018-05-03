function getCaptcha(domain, captcha_type) {
    var url = ""
    if (captcha_type === "2ch") {
        url = "https://2ch." + domain + "/api/captcha/2chaptcha/service_id"
        yaca.visible = true
        captcha_value.visible = true
        yaca.source = ""
        capchaindicator.visible = true
        py.call('getdata.dyorg', ["captcha", "none", url], function() {})
        captcha_value.text = ""
        captcha_value.focus = true
    } else {
        url = "https://2ch." + domain + "/api/captcha/recaptcha/mobile"
        pageStack.push(Qt.resolvedUrl("../pages/Webview.qml"), {uri: url } )
    }
}

function insertTag (start, end, open, close) {
    cmnt.text = cmnt.text.substr(0, start) + open + cmnt.text.substr(start)
    cmnt.text = cmnt.text.substr(0, end + (open).length) + close + cmnt.text.substr(end + (open).length)
}
