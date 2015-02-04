import QtQuick 2.1
import Sailfish.Silica 1.0
import "../js/newpost.js" as NewPost

Page {
    id: page
    property string thread: ""
    property string board: ""
    property string captcha: ""

    Column {
        id: postform
        anchors{
            fill: parent
            topMargin: Theme.paddingLarge * 4
        }

        Button {
           text: qsTr("Reply")
           onClicked: NewPost.post()
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
                        NewPost.getCaptcha()
                    }
                }
            }
        }
        TextField {
            id: captcha_value
            width: parent.width
            placeholderText: qsTr("Verification")
        }
        /*Label {
            id: status
            text: ""
        }*/
    }
    Component.onCompleted: {
        NewPost.getCaptcha()
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
