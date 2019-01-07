import QtQuick 2.1
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.3
import Qt.labs.folderlistmodel 2.1

Dialog {
    id: cac_fileSelect

    property string setRootFolder: '/home/nemo'
    property string setFolder: '/home/nemo'
    property string uri: ""
    property bool setShowHidden: false
    property string selectedFileName: ""

    FolderListModel {
        id: folderModel
        folder: setFolder
        rootFolder: setRootFolder
        showHidden: setShowHidden
        showFiles: false
        showDotAndDotDot: true
        showOnlyReadable: true
    }

    SilicaListView {
        id: listView
        model: folderModel
        anchors.fill: parent

        header: DialogHeader {
            acceptText: qsTr("Save")
            cancelText: qsTr("Cancel")
        }

        delegate: ListItem {
            id: item

            Image {
                id: itemIcon
                source: folderModel.isFolder(index) ? "image://theme/icon-m-folder" : "image://theme/icon-m-other"
                height: parent.height -Theme.paddingMedium
                width: height
                anchors.left: parent.left
            }

            Label {
                id: itemName
                text: model.fileName
                color: Theme.primaryColor

                anchors {
                    verticalCenter: parent.verticalCenter
                    left: itemIcon.right
                    right: parent.right
                    margins: Theme.paddingMedium
                }
            }

            onClicked: {
                if (folderModel.isFolder(index)) {
                    if (fileName == "..") {
                        folderModel.folder = folderModel.parentFolder
                    } else if (fileName != ".") {
                        folderModel.folder += "/" + fileName
                    }
                } else {
                    selectedFileName = folderModel.folder + "/" + model.fileName
                    console.log(selectedFileName)
                    cac_fileSelect.accept();
                }
            }
        }

        VerticalScrollDecorator {}
    }

    onDone: {
        if (selectedFileName == "") {
            selectedFileName = folderModel.folder;
        }
    }

    onAccepted: py.call('savefile.save', [selectedFileName.slice(7), uri.match(/\d+\.[a-z]+/)[0], uri] );

    Python {
        id: py

        Component.onCompleted: {
            // Add the Python library directory to the import path
            var pythonpath = Qt.resolvedUrl('../py/').substr('file://'.length);
            //var pythonpath = Qt.resolvedUrl('.').substr('file://'.length);
            addImportPath(pythonpath);
            var requestspath = Qt.resolvedUrl('../py/requests').substr('file://'.length);
            addImportPath(requestspath);
            importModule('savefile', function() {});
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
