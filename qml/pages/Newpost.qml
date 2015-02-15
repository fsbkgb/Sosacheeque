import QtQuick 2.1
import Sailfish.Silica 1.0
import "../js/newpost.js" as NewPost
import io.thp.pyotherside 1.0

Page {
    id: page
    property string thread: ""
    property string board: ""
    property string captcha: ""
    property string domain: ""

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: postform.height + Theme.paddingLarge

        VerticalScrollDecorator {}
        PageHeader {
            title: qsTr("New post")
        }
        Column {
            id: postform
            anchors{
                fill: parent
                topMargin: Theme.paddingLarge * 4
            }

            Button {
                text: qsTr("Send")
                onClicked: {
                    py.call('newpost.sendpost', [domain, board, thread, cmnt.text, captcha, captcha_value.text], function(response) {
                        var x = JSON.parse(response)
                        if (x.Error === null){
                            status.text = x.Status
                        } else {
                            status.text = x.Reason
                        }
                    });
                }
                anchors {
                    right: parent.right
                    rightMargin: Theme.paddingLarge
                }
            }
            TextArea {
                id: cmnt
                width: parent.width
                height: 350
                placeholderText: qsTr("Comment")
                EnterKey.onClicked: parent.focus = true
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
                            NewPost.getCaptcha(domain)
                        }
                    }
                }
            }
            TextField {
                id: captcha_value
                width: parent.width
                placeholderText: qsTr("Verification")
                EnterKey.onClicked: parent.focus = true
            }
            Label {
                id: status
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                text: ""
            }
        }
        Component.onCompleted: {
            NewPost.getCaptcha(domain)
        }
    }
    Python {
        id: py

        Component.onCompleted: {
            // Add the Python library directory to the import path
            var pythonpath = Qt.resolvedUrl('../py/').substr('file://'.length);
            //var pythonpath = Qt.resolvedUrl('.').substr('file://'.length);
            addImportPath(pythonpath);
            console.log(pythonpath);
            importModule('newpost', function() {});
        }
        onError: {
            // when an exception is raised, this error handler will be called
            console.log('python error: ' + traceback);
        }
        onReceived: {
            // asychronous messages from Python arrive here
            // in Python, this can be accomplished via pyotherside.send()
            console.log('got message from python: ' + data);
        }
    }
}
