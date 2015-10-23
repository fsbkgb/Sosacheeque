import QtQuick 2.1
import Sailfish.Silica 1.0
import "../js/boards.js" as Boards
import io.thp.pyotherside 1.3

Page {
    id: page
    property string domain: ""
    property bool somethingloading: false

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
                validator: RegExpValidator {regExp: /[a-z]+/}
                EnterKey.onClicked: {
                    somethingloading = true
                    Boards.getOne(text)
                    parent.focus = true
                }
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
            }
        }
    }

    Rectangle {
        anchors{
            top: parent.top
        }
        color: Theme.highlightBackgroundColor
        width: parent.width
        height: Theme.paddingLarge * 2
        visible: page.somethingloading
        BusyIndicator {
            id: krooteelka
            size: BusyIndicatorSize.Small
            running: true
            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
                leftMargin: Theme.paddingSmall
            }
        }
        Label {
            text: qsTr("Opening board")
            anchors {
                left: krooteelka.right
                verticalCenter: parent.verticalCenter
                leftMargin: Theme.paddingSmall
            }
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
            var requestspath = Qt.resolvedUrl('../py/requests').substr('file://'.length);
            addImportPath(requestspath);
            importModule('getdata', function() {});
        }
        /*onError: {
            // when an exception is raised, this error handler will be called
            console.log('python error: ' + traceback);
        }*/
        onReceived: {
            // asychronous messages from Python arrive here
            // in Python, this can be accomplished via pyotherside.send()
            console.log('got message from python: ' + data);
        }
    }
}
