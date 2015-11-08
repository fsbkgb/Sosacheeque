import QtQuick 2.1
import Sailfish.Silica 1.0
import "../js/boards.js" as Boards
import io.thp.pyotherside 1.3

Page {
    id: page
    property string domain: ""
    property bool somethingloading: false
    property bool someerror: false
    property string notification: ""

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
                    notification = qsTr("Opening board")
                    somethingloading = true
                    Boards.getOne(text, "replace", "index")
                    parent.focus = true
                }
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
            }
        }
    }

    Notifications {}

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
