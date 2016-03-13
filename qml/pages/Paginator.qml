import QtQuick 2.1
import Sailfish.Silica 1.0
import "../js/boards.js" as Boards
import io.thp.pyotherside 1.3

Page {
    id: page
    allowedOrientations : Orientation.All
    property string board: ""
    property string url: ""
    property string domain: ""
    property string notification: ""
    property int pages
    property bool somethingloading: false
    property bool someerror: false

    SilicaGridView {
        anchors{
            fill: parent
            leftMargin: Theme.horizontalPageMargin
            rightMargin: Theme.horizontalPageMargin
        }
        id: listView
        model: pages
        header: PageHeader {
            title: qsTr("Choose page")
        }

        delegate: Button {
               text: index
               height: Theme.itemSizeSmall
               width: Theme.itemSizeSmall
               onClicked: {
                   notification = qsTr("Opening board")
                   somethingloading = true
                   if (index == 0)
                   {py.call('getdata.dyorg', ["pager_page", "board", "https://2ch." + domain + "/" + board + "/index.json"], function() {})}
                   else
                   {py.call('getdata.dyorg', ["pager_page", "board", "https://2ch." + domain + "/" + board + "/" + index + ".json"], function() {})}
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
            var requestspath = Qt.resolvedUrl('../py/requests').substr('file://'.length);
            addImportPath(requestspath);
            importModule('getdata', function() {});
            setHandler('pager_page', function (type, error, data) {
                Boards.getOne(error, data, "replace")
            });
        }
        onError: {
            // when an exception is raised, this error handler will be called
            console.log('python error: ' + traceback);
        }
        onReceived: {
            // asychronous messages from Python arrive here
            // in Python, this can be accomplished via pyotherside.send()
        }
    }
}
