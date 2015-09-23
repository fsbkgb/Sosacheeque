import QtQuick 2.1
import Sailfish.Silica 1.0
import "../js/newpost.js" as NewPost
import io.thp.pyotherside 1.4

Page {
    id: page
    allowedOrientations : Orientation.All
    property string thread: ""
    property string board: ""
    property string captcha: ""
    property string domain: ""
    property string comment: ""
    property var icons: []
    property int enable_icons: 0
    property int enable_names: 0
    property int enable_subject: 0

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: postform.implicitHeight + Theme.paddingLarge * 6

        PageHeader {
            title: qsTr("New post")
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
                            property string iconnum: modelData.num
                            text: modelData.name
                        }
                    }
                }
                onCurrentIndexChanged: {
                    icon.text = iconslist.currentItem.iconnum
                }
            }
            Row {
                id: buttons

                Button {
                    width: Math.floor(page.width / 5)
                    Text {
                        text: "<b>B</b>"
                        textFormat: Text.RichText
                        color: Theme.primaryColor
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                    onClicked: NewPost.insertTag (cmnt.selectionStart, cmnt.selectionEnd, "[B]", "[/B]")
                }
                Button {
                    width: Math.floor(page.width / 5)
                    Text {
                        text: "<i>I</i>"
                        textFormat: Text.RichText
                        color: Theme.primaryColor
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                    onClicked: NewPost.insertTag (cmnt.selectionStart, cmnt.selectionEnd, "[I]", "[/I]")
                }
                Button {
                    width: Math.floor(page.width / 5)
                    Text {
                        text: "<u>U</u>"
                        textFormat: Text.RichText
                        color: Theme.primaryColor
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                    onClicked: NewPost.insertTag (cmnt.selectionStart, cmnt.selectionEnd, "[U]", "[/U]")
                }
                Button {
                    width: Math.floor(page.width / 5)
                    Text {
                        text: "<s>S</s>"
                        textFormat: Text.RichText
                        color: Theme.primaryColor
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                    onClicked: NewPost.insertTag (cmnt.selectionStart, cmnt.selectionEnd, "[S]", "[/S]")
                }
                Button {
                    width: Math.floor(page.width / 5)
                    Rectangle {
                        color: "#BBBBBB"
                        anchors {
                            bottom: parent.verticalCenter
                            top: parent.top
                            left: parent.left
                            right: parent.right
                            bottomMargin: Theme.paddingSmall
                            topMargin: Theme.paddingSmall
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
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }

                Image {
                    id: yaca
                    width: 234
                    height: 70

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            NewPost.getCaptcha(domain)
                        }
                    }
                    BusyIndicator {
                        id: capchaindicator
                        visible: false
                        running: true
                        size: BusyIndicatorSize.Medium
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }
                Button {
                    text: qsTr("Send")
                    width: page.width - yaca.width - Theme.paddingLarge
                    onClicked: {
                        indicator.visible = true
                        status.visible = false
                        enabled = false
                        var file_1 = (fileList.get(0) ? fileList.get(0).filepath : "")
                        var file_2 = (fileList.get(1) ? fileList.get(1).filepath : "")
                        var file_3 = (fileList.get(2) ? fileList.get(2).filepath : "")
                        var file_4 = (fileList.get(3) ? fileList.get(3).filepath : "")
                        py.call('newpost.sendpost', [domain, board, thread, cmnt.text, captcha, captcha_value.text, email.text, name.text, subject.text, icon.text, file_1, file_2, file_3, file_4], function(response) {
                            var x = JSON.parse(response)
                            indicator.visible = false
                            status.visible = true
                            enabled = true
                            if (x.Error === null){
                                status.text = x.Status
                                if (thread === "0" ) {
                                    pageStack.replace(Qt.resolvedUrl("Posts.qml"), {thread: x.Target, board: board, domain: domain, anchor: 0, fromfav: false, state: "thread"} )
                                } else {
                                    clearfields()
                                    var threadPage = pageStack.find(function(page) { return page.state == "thread"; })
                                    threadPage.comment = ""
                                    pageStack.replaceAbove(threadPage, Qt.resolvedUrl("KostylPage.qml"), null, PageStackAction.Immediate)
                                    threadPage.refreshthread()
                                    pageStack.navigateBack()
                                }
                            } else {
                                status.text = x.Reason
                                if (x.Error === -5) {
                                    NewPost.getCaptcha(domain)
                                    captcha_value.text = ""
                                    captcha_value.focus = true
                                }
                            }
                        });
                    }
                }
            }
            TextField {
                id: captcha_value
                width: parent.width
                placeholderText: qsTr("Verification")
                EnterKey.onClicked: parent.focus = true
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
            }
            Repeater {
                model: fileList
                TextField {
                    width: parent.width
                    text: modelData
                    readOnly: true
                    onClicked: {
                        fileList.remove(index)
                    }
                }
            }
        }
        VerticalScrollDecorator {}
    }

    onStatusChanged: {
        if (page.status === PageStatus.Activating && cmnt.text === "") {
            NewPost.getCaptcha(domain)
        }
    }

    function clearfields() {
        status.visible = false
        NewPost.getCaptcha(domain)
        cmnt.text = ""
        fileList.clear()
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
            importModule('getdata', function() {});
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
