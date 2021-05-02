function getCaptcha(url, captcha_type, thread) {
    if (captcha_type === "2ch" && thread !== "0" ) {
        url = url + "/app/id/" + zaloopa28()
        py.call('getdata.dyorg', ["captcha", "none", url, ""], function() {})
    } else {
        url = url + "/recaptcha/mobile"
        pageStack.push(Qt.resolvedUrl("../pages/Webview.qml"), {uri: url } )
    }
}

function insertTag (start, end, open, close) {
    cmnt.text = cmnt.text.substr(0, start) + open + cmnt.text.substr(start)
    cmnt.text = cmnt.text.substr(0, end + (open).length) + close + cmnt.text.substr(end + (open).length)
}

function zaloopa28() {
    var input = page.string1 + "\n" + page.string3
    var output = ""
    var chr1, chr2, chr3 = ""
    var enc1, enc2, enc3, enc4 = ""
    var i = 0
    var keyStr = "ABCDEFGHIJKLMNOP" +
      "QRSTUVWXYZabcdef" +
      "ghijklmnopqrstuv" +
      "wxyz0123456789+/" +
      "="

    var zaloopa28test = /[^A-Za-z0-9\+\/\=]/g
    if (zaloopa28test.exec(input)) {}
    input = input.replace(/[^A-Za-z0-9\+\/\=]/g, "")

    do {
        enc1 = keyStr.indexOf(input.charAt(i++))
        enc2 = keyStr.indexOf(input.charAt(i++))
        enc3 = keyStr.indexOf(input.charAt(i++))
        enc4 = keyStr.indexOf(input.charAt(i++))

        chr1 = (enc1 << 2) | (enc2 >> 4)
        chr2 = ((enc2 & 15) << 4) | (enc3 >> 2)
        chr3 = ((enc3 & 3) << 6) | enc4

        output = output + String.fromCharCode(chr1)

        if (enc3 !== 64) {
            output = output + String.fromCharCode(chr2)
        }
        if (enc4 !== 64) {
            output = output + String.fromCharCode(chr3)
        }

        chr1 = chr2 = chr3 = ""
        enc1 = enc2 = enc3 = enc4 = ""

    } while (i < input.length)

    page.string7 = output.match(/([^:]{32})/g)[1]
    return output.match(/([^:]{32})/g)[0]
}
