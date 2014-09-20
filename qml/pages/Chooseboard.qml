import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page
    function getBoard(board) {
        var xhr = new XMLHttpRequest();
        var categories = []
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.HEADERS_RECEIVED) {
                print('HEADERS_RECEIVED');
            } else if(xhr.readyState === XMLHttpRequest.DONE) {
                var parsed = JSON.parse(xhr.responseText);
                pageStack.replace(Qt.resolvedUrl("Tredi.qml"), {url: "https://2ch.hk/"+board+"/index.json", borda: board, pages: parsed.pages.length} )
            }
        }
        xhr.open("GET", "https://2ch.hk/" + board + "/index.json");
        xhr.send();
    }
    SilicaFlickable {
        anchors{
            fill: parent
            topMargin: Theme.paddingLarge * 4
        }
        Column {
            id: column
            width: parent.width
            TextField {
                width: parent.width
                placeholderText: "b"
                focus: true
                validator: RegExpValidator { regExp: /[a-z]+/ }
                EnterKey.onClicked: {
                    getBoard(text);
                    parent.focus = true;
                }
            }
        }
    }
}
