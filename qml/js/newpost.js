function getCaptcha(domain) {
    yaca.visible = true
    yaca.source = ""
    capchaindicator.visible = true
    py.call('getdata.dyorg', ["https://2ch." + domain + "/makaba/captcha.fcgi?type=mailru"], function(response) {
            var capucha = response.match(/(.{32})/)[1]
            py.call('getdata.milo', ["https://api-nocaptcha.mail.ru/captcha?public_key=" + capucha + "&_=" + new Date().getTime(), "https://api-nocaptcha.mail.ru/c/1?" + new Date().getTime()], function(response) {
                captcha = response.match(/id: "(.+)"/)[1]
                capchaindicator.visible = false
                yaca.source = "/tmp/captcha.jpg?abc=" + Math.random()
            })
        })
}

function insertTag (start, end, open, close) {
    cmnt.text = cmnt.text.substr(0, start) + open + cmnt.text.substr(start)
    cmnt.text = cmnt.text.substr(0, end + (open).length) + close + cmnt.text.substr(end + (open).length)
}
