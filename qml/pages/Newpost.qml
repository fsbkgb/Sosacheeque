import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page
    property string tred: ""
    property string borda: ""
    property string captcha: ""
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
    function postPost() {
        /*var url = "https://posttestserver.com/post.php";
        var url = "https://2ch.hk/makaba/posting.fcgi?json=1";
        var params = "task=post&board=" + page.borda + "&thread=" + page.tred + "&comment=" + cmnt.text + "&captcha=" + page.captcha + "&captcha_value_id_06=" + captcha_value.text;

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
            board: page.borda,
            thread: page.tred,
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
    Column {
        id: postform
        anchors{
            fill: parent
            topMargin: Theme.paddingLarge * 4
        }
        Button {
           text: "Ответ"
           onClicked: postPost()
           anchors {
               right: parent.right
               rightMargin: Theme.paddingLarge
           }
        }
        TextArea {
            id: cmnt
            width: parent.width
            height: 350
            placeholderText: "Комментарий"
        }
        Image {
            id: yaca
            source: "https://captcha.yandex.net/image?key=" + captcha
            width: 200
            height: 60
            anchors {
                left: parent.left
                leftMargin: Theme.paddingLarge
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    onClicked: {
                        getCaptcha()
                    }
                }
            }
        }
        TextField {
            id: captcha_value
            width: parent.width
            placeholderText: "Капча"
        }
        /*Label {
            id: status
            text: ""
        }*/
    }
    Component.onCompleted: {
        getCaptcha()
    }
}
/*post
Post Params:
key: 'task' value: 'post'
key: 'board' value: 's'
key: 'thread' value: '1046042'
key: 'usercode' value: ''
key: 'code' value: ''
key: 'email' value: ''
key: 'name' value: ''
key: 'subject' value: ''
key: 'comment' value: '111'
key: 'image1' value: ''
key: 'image2' value: ''
key: 'image3' value: ''
key: 'image4' value: ''
key: 'captcha' value: '23fxl73K8JRD6oZHNcWHBnonCiGufI1V'
key: 'captcha_value_id_06' value: '425477'
key: 'submit' value: 'РћС‚РІРµС‚'
*/

/*thread
Post Params:
key: 'task' value: 'post'
key: 'board' value: 'b'
key: 'thread' value: '0'
key: 'usercode' value: ''
key: 'code' value: ''
key: 'email' value: ''
key: 'comment' value: '2323'
key: 'image1' value: ''
key: 'image2' value: ''
key: 'image3' value: ''
key: 'image4' value: ''
key: 'captcha' value: '100xUhFHuBKIrKmE8GiboTY7DWvOQsUP'
key: 'captcha_value_id_06' value: '4444'
key: 'submit' value: 'РћС‚РІРµС‚'
*/
