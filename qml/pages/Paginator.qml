import QtQuick 2.1
import Sailfish.Silica 1.0
import "../js/boards.js" as Boards
import io.thp.pyotherside 1.3

Page {
    id: page
    property string board: ""
    property string url: ""
    property string domain: ""
    property string notification: ""
    property int pages
    property bool somethingloading: false
    property bool someerror: false

    SilicaListView {
        anchors{
            fill: parent
            margins: 16
        }
        id: listView
        model: pages
        header: PageHeader {
            title: qsTr("Choose page")
        }

        delegate: BackgroundItem {
            id: delegate

            Label {
                id: text
                text: index
                width: parent.width
                color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
            }
            onClicked: {
                notification = qsTr("Opening board")
                somethingloading = true
                if (index == 0)
                {Boards.getOne(board, "replace", "index")}
                else
                {Boards.getOne(board, "replace", index)}
            }
        }
        VerticalScrollDecorator {}
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
