function getCaptcha() {
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
    xhr.open("GET", "https://2ch.hk/makaba/captcha.fcgi");
    xhr.send();
}

function post() {
    /*var url = "https://posttestserver.com/post.php";
    var url = "https://2ch.hk/makaba/posting.fcgi?json=1";
    var params = "task=post&board=" + page.board + "&thread=" + page.thread + "&comment=" + cmnt.text + "&captcha=" + page.captcha + "&captcha_value_id_06=" + captcha_value.text;

    var xhr = new XMLHttpRequest();
    xhr.open("GET","https://2ch.hk/b/",true);
    xhr.send();
    xhr.onreadystatechange = function() {
        if (xhr.readyState === XMLHttpRequest.HEADERS_RECEIVED) {
            print('HEADERS_RECEIVED');
            print(xhr.getAllResponseHeaders());
        } else if(xhr.readyState === 3) {
            console.log(xhr.responseText);
        }
    }

    var data = {
        task: "post",
        board: page.board,
        thread: page.thread,
        comment: cmnt.text,
        captcha: page.captcha,
        captcha_value_id_06: captcha_value.text
    };

    var boundary = String(Math.random()).slice(2);
    var boundaryMiddle = '--' + boundary + '\r\n';
    var boundaryLast = '--' + boundary + '--\r\n'

    var params = ['\r\n'];
    for (var key in data) {
      params.push('Content-Disposition: form-data; name="'+key+'"\r\n\r\n'+data[key]+'\r\n');
    }

    params = params.join(boundaryMiddle) + boundaryLast;
    //var xhr = new XMLHttpRequest();
    xhr.open("POST", url, true);
    xhr.setRequestHeader('Content-Type','multipart/form-data; boundary=' + boundary);
    xhr.setRequestHeader("Content-length", params.length);
    xhr.setRequestHeader("Connection", "close");
    xhr.onreadystatechange = function() {//Call a function when the state changes.
        if(xhr.readyState == 3) {
            console.log(xhr.responseText);
            console.log(xhr.status);
            status.text = xhr.status;
        }
    }
    xhr.send(params)
    pageStack.push(Qt.resolvedUrl("Webview.qml"), {uri: url+params})*/
}
