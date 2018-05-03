import QtQuick 2.1
import Sailfish.Silica 1.0
import "../js/db.js" as DB
import "../js/boards.js" as Boards
import "../js/settings.js" as Settings
import io.thp.pyotherside 1.3

Page {
    id: page
    allowedOrientations : Orientation.All
    objectName: "boardsPage"
    property var categories
    property bool loading: false
    property bool somethingloading: false
    property bool someerror: false
    property var option
    property string domain: page.option[1].value
    property string notification: ""
    property string error: ""

    BusyIndicator {
        anchors.centerIn: parent
        running: page.loading
        visible: page.loading
        size: BusyIndicatorSize.Large
    }

    Label {
        anchors.centerIn: parent
        visible: page.error !== ""
        text: page.error
    }

    Loader {
        anchors.fill: parent
        sourceComponent:  listViewComponent
    }

    Column {
        id: headerContainer

        width: parent.width

        PageHeader {
            title: qsTr("Boards")
        }

        TextField {
            width: parent.width
            placeholderText: "b"
            focus: true
            validator: RegExpValidator {regExp: /[0-9, a-z]+/}
            EnterKey.onClicked: {
                notification = qsTr("Opening board")
                somethingloading = true
                py.call('getdata.dyorg', ["list_page", "board", "https://2ch." + domain + "/" + text + "/index.json"], function() {})
                parent.focus = true
            }
            EnterKey.iconSource: "image://theme/icon-m-enter-next"
        }
    }
    Component {
        id: listViewComponent

        SilicaListView {
            header:  Item {
                id: header
                width: headerContainer.width
                height: headerContainer.height
                Component.onCompleted: headerContainer.parent = header
            }
            id: listView
            visible: !page.loading
            model: categories
            anchors.fill: parent
            delegate: ListItem {
                id: delegate
                Label {
                    id: boardname
                    width: parent.width - 10
                    text: modelData.id + " - " + modelData.name
                    truncationMode: TruncationMode.Fade
                    anchors {
                        left: parent.left
                        leftMargin: Theme.horizontalPageMargin
                    }
                }
                onClicked: {
                    notification = qsTr("Opening board")
                    somethingloading = true
                    py.call('getdata.dyorg', ["list_page", "board", "https://2ch." + domain + "/" + modelData.id + "/index.json"], function() {})
                }
                menu: ContextMenu {
                    MenuItem {
                        text: qsTr("Add to favorites")
                        onClicked: Boards.fav(modelData.id, modelData.name)
                    }
                }
            }
        }
    }

    Notifications {}

    Component.onCompleted: loadlist()

    function loadlist () {
        page.loading = true
        Settings.load()
        py.call('getdata.dyorg', ["list_page", "boards", "https://2ch." + page.option[1].value + "/makaba/mobile.fcgi?task=get_boards"], function() {})
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
            importModule('getdata', function() {});
            setHandler('list_page', function (type, error, data) {
                if (type === "board") {
                    Boards.getOne(error, data, "replace")
                } else {
                    Boards.getAll(error, data)
                }
            })
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
