import QtQuick 2.1
import Sailfish.Silica 1.0
import "../js/newpost.js" as NewPost
import "../js/threads.js" as Threads
import "../js/settings.js" as Settings
import "../js/db.js" as DB
import io.thp.pyotherside 1.3

Page {
    id: page
    allowedOrientations : Orientation.All
    property string state: "postform"
    property string thread: ""
    property string board: ""
    property string captcha: ""
    property string captcha_type: ""
    property string domain: ""
    property string comment: ""
    property string notification: ""
    property string cooka: ""
    property string string1: Settings.load("string1")
    property string string3: Settings.load("string3")
    property string string7: ""
    property var icons: []
    property var parsedthreads: []
    property int enable_icons: 0
    property int enable_names: 0
    property int enable_subject: 0
    property bool somethingloading: false
    property bool someerror: false

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: postform.implicitHeight + Theme.paddingLarge * 6

        PageHeader {
            title: qsTr("New post")
        }
        PullDownMenu {
            MenuItem {
                text: qsTr("Get Cookies")
                onClicked: pageStack.push(Qt.resolvedUrl("Webview.qml"), {board: board, domain: domain, uri: "https://2ch." + domain + "/" + board + "/res/" + thread + ".html", captcha: captcha, captcha_type: captcha_type, comment: cmnt.text, thread: thread} )
            }
        }
        Column {
            id: postform
            anchors{
                fill: parent
                topMargin: Theme.paddingLarge * 6
            }

            ListModel { id: fileList }
            TextField {
                id: email
                width: parent.width
                placeholderText: qsTr("E-mail")
                EnterKey.onClicked: parent.focus = true
            }
            TextField {
                id: name
                visible: enable_names === 1 ? true : false
                width: parent.width
                placeholderText: qsTr("Name")
                EnterKey.onClicked: parent.focus = true
            }
            TextField {
                id: subject
                visible: enable_subject === 1 ? true : false
                width: parent.width
                placeholderText: qsTr("Subject")
                EnterKey.onClicked: parent.focus = true
            }
            TextField {
                id: icon
                visible: false
                width: parent.width
                text: "-1"
                EnterKey.onClicked: parent.focus = true
            }
            ComboBox {
                id: iconslist
                visible: enable_icons === 1 ? true : false 
                width: page.width
                label: qsTr("Icon")
                menu: ContextMenu {
                    Repeater {
                        model: icons
                        MenuItem {
                            property string iconnum: enable_icons === 1 ? modelData.num : ""
                            text: enable_icons === 1 ? modelData.name : ""
                        }
                    }
                }
                onCurrentIndexChanged: {
                    icon.text = iconslist.currentItem.iconnum
                }
            }
            Row {
                id: buttons
                spacing: 3
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                property int btnwdth: Math.floor((page.width - Theme.paddingLarge * 2) / 5)

                Button {
                    width: buttons.btnwdth
                    Text {
                        text: "<b>B</b>"
                        textFormat: Text.RichText
                        color: Theme.primaryColor
                        anchors {
                            horizontalCenter: parent.horizontalCenter
                            verticalCenter: parent.verticalCenter
                        }
                    }
                    onClicked: NewPost.insertTag (cmnt.selectionStart, cmnt.selectionEnd, "[B]", "[/B]")
                }
                Button {
                    width: buttons.btnwdth
                    Text {
                        text: "<i>I</i>"
                        textFormat: Text.RichText
                        color: Theme.primaryColor
                        anchors {
                            horizontalCenter: parent.horizontalCenter
                            verticalCenter: parent.verticalCenter
                        }
                    }
                    onClicked: NewPost.insertTag (cmnt.selectionStart, cmnt.selectionEnd, "[I]", "[/I]")
                }
                Button {
                    width: buttons.btnwdth
                    Text {
                        text: "<u>U</u>"
                        textFormat: Text.RichText
                        color: Theme.primaryColor
                        anchors {
                            horizontalCenter: parent.horizontalCenter
                            verticalCenter: parent.verticalCenter
                        }
                    }
                    onClicked: NewPost.insertTag (cmnt.selectionStart, cmnt.selectionEnd, "[U]", "[/U]")
                }
                Button {
                    width: buttons.btnwdth
                    Text {
                        text: "<s>S</s>"
                        textFormat: Text.RichText
                        color: Theme.primaryColor
                        anchors {
                            horizontalCenter: parent.horizontalCenter
                            verticalCenter: parent.verticalCenter
                        }
                    }
                    onClicked: NewPost.insertTag (cmnt.selectionStart, cmnt.selectionEnd, "[S]", "[/S]")
                }
                Button {
                    width: buttons.btnwdth
                    Rectangle {
                        color: "#BBBBBB"
                        anchors {
                            verticalCenter: parent.verticalCenter
                            top: parent.top
                            left: parent.left
                            right: parent.right
                            bottomMargin: Theme.paddingMedium
                            topMargin: Theme.paddingMedium
                            leftMargin: Theme.paddingLarge
                            rightMargin: Theme.paddingLarge
                        }
                    }
                    onClicked: NewPost.insertTag (cmnt.selectionStart, cmnt.selectionEnd, "[SPOILER]", "[/SPOILER]")
                }
            }
            TextArea {
                id: cmnt
                width: parent.width
                height: 350
                placeholderText: qsTr("Comment")
                text: comment
                onTextChanged: {
                    var threadPage = pageStack.find(function(page) { return page.objectName === "mainPage"; })
                    threadPage.comment = text + "\r\n"
                }
            }
            BusyIndicator {
                id: indicator
                visible: false
                running: true
                size: BusyIndicatorSize.Medium
                anchors.horizontalCenter: parent.horizontalCenter
            }
            TextField {
                id: status
                visible: false
                readOnly: true
                width: parent.width
                text: ""
            }

            Row {
                spacing: Theme.paddingLarge
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                IconButton {
                    icon.source: "image://theme/icon-m-image"
                    onClicked: {
                        if (fileList.count < 4) {
                            var imagePicker = pageStack.push("Sailfish.Pickers.ImagePickerPage");
                            imagePicker.selectedContentChanged.connect(function() {
                                var a = imagePicker.selectedContent
                                var path = a.toString().substr(7)
                                fileList.append({"filepath": path})
                            })
                        }
                    }
                    Image {
                        source: "image://theme/icon-s-attach"
                    }
                }
                IconButton {
                    icon.source: "image://theme/icon-m-video"
                    onClicked: {
                        if (fileList.count < 4) {
                            var videoPicker = pageStack.push("Sailfish.Pickers.VideoPickerPage");
                            videoPicker.selectedContentChanged.connect(function() {
                                var a = videoPicker.selectedContent
                                var path = a.toString().substr(7)
                                fileList.append({"filepath": path})
                            })
                        }
                    }
                    Image {
                        source: "image://theme/icon-s-attach"
                    }
                }
                Button {
                    Text {
                        text: captcha === "" ? qsTr("Get captcha") : qsTr("Post")
                        color: Theme.primaryColor
                        anchors {
                            horizontalCenter: parent.horizontalCenter
                            verticalCenter: parent.verticalCenter
                        }
                    }
                    onClicked: {
                        focus = true
                        captcha === "" ? NewPost.getCaptcha("https://2ch." + domain + "/api/captcha", captcha_type, thread) : postPost()
                    }
                }
            }
            Repeater {
                model: fileList
                TextField {
                    width: parent.width
                    text: modelData
                    validator: RegExpValidator {regExp: /[\x00-\x7F]+/}
                    readOnly: true
                    onClicked: {
                        fileList.remove(index)
                    }
                }
            }
        }
        VerticalScrollDecorator {}
    }

    Notifications {}

    function clearfields() {
        status.visible = false
        cmnt.text = ""
        fileList.clear()
    }

    function postPost () {
        indicator.visible = true
        status.visible = false
        enabled = false
        var file_1 = (fileList.get(0) ? fileList.get(0).filepath : "")
        var file_2 = (fileList.get(1) ? fileList.get(1).filepath : "")
        var file_3 = (fileList.get(2) ? fileList.get(2).filepath : "")
        var file_4 = (fileList.get(3) ? fileList.get(3).filepath : "")
        py.call('newpost.sendpost', [domain, captcha_type, board, thread, cmnt.text, captcha, string7, email.text, name.text, subject.text, icon.text, file_1, file_2, file_3, file_4], function(response) {
            var x = JSON.parse(response)
            indicator.visible = false
            status.visible = true
            enabled = true
            if (x.Error === null){
                status.text = x.Status
                if (thread === "0" ) {
                    notification= qsTr("Opening thread")
                    page.somethingloading = true
                    py.call('getdata.dyorg', ["new_thread_page", "thread", "https://2ch." + domain + "/" + board + "/res/" + x.Target + ".json#" + x.Target, cooka], function() {})
                } else {
                    clearfields()
                    var threadPage = pageStack.find(function(page) { return page.state === "thread"; })
                    threadPage.comment = ""
                    pageStack.replaceAbove(threadPage, Qt.resolvedUrl("KostylPage.qml"), null, PageStackAction.Immediate)
                    threadPage.refreshthread()
                    pageStack.navigateBack()
                }
            } else {
                status.text = x.Reason
                if (x.Error === -5) {
                    captcha = ""
                }
            }
        })
    }

    Python {
        id: py

        Component.onCompleted: {
            // Add the Python library directory to the import path
            var pythonpath = Qt.resolvedUrl('../py/').substr('file://'.length);
            //var pythonpath = Qt.resolvedUrl('.').substr('file://'.length);
            addImportPath(pythonpath);
            var requestspath = Qt.resolvedUrl('../py/requests').substr('file://'.length);
            addImportPath(requestspath);
            importModule('newpost', function() {});
            importModule('getdata', function() {});
            setHandler('captcha', function (type, error, data) {
                captcha = data.match(/(\w{64})/)[1]
            });
            setHandler('new_thread_page', function (type, error, data, anchor) {
                Threads.getThread(error, data, anchor, "replace", domain)
            });
        }
        onError: {
            // when an exception is raised, this error handler will be called
            console.log('python error: ' + traceback);
        }
        onReceived: {
            // asychronous messages from Python arrive here
            // in Python, this can be accomplished via pyotherside.send()
            console.log("pyotherside.send: " + data)
        }
    }
}
