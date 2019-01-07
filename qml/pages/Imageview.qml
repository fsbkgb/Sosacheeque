import QtQuick 2.1
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.3

Page {
    id: imagePage
    allowedOrientations : Orientation.All
    property string domain: ""
    property string path: ""
    property string file: ""
    property string progress: "0 %"

    SilicaFlickable {
        id: picFlick
        contentWidth: width
        contentHeight: height
        anchors.fill: parent
        pressDelay: 0
        function _fit() {
            contentX = 0
            contentY = 0
            contentWidth = width
            contentHeight = height
        }

        PullDownMenu {
            MenuItem {
                text: qsTr("Save as")
                onClicked: pageStack.push(Qt.resolvedUrl("SaveFile.qml"), {uri: file})
            }
        }

        Item {
            anchors.fill: parent

            BusyIndicator {
                id: busyIndicator
                size: BusyIndicatorSize.Large
                running: true
                anchors.centerIn: parent
                Label {
                    anchors.centerIn: parent
                    font.pixelSize: Theme.fontSizeSmall
                    text: progress
                }
            }
        }

        PinchArea {
            width: Math.max(picFlick.contentWidth, picFlick.width)
            height: Math.max(picFlick.contentHeight, picFlick.height)
            property real initialWidth
            property real initialHeight
            onPinchStarted: {
                initialWidth = picFlick.contentWidth
                initialHeight = picFlick.contentHeight
            }
            onPinchUpdated: {
                picFlick.contentX += pinch.previousCenter.x - pinch.center.x
                picFlick.contentY += pinch.previousCenter.y - pinch.center.y

                var newWidth = Math.max(initialWidth * pinch.scale, picFlick.width)
                var newHeight = Math.max(initialHeight * pinch.scale, picFlick.height)

                newWidth = Math.min(newWidth, picFlick.width * 3)
                newHeight = Math.min(newHeight, picFlick.height * 3)

                picFlick.resizeContent(newWidth, newHeight, pinch.center)
            }
            onPinchFinished: {
                picFlick.returnToBounds()
            }
        }
        Item {
            width: picFlick.contentWidth
            height: picFlick.contentHeight
            smooth: !(picFlick.movingVertically || picFlick.movingHorizontally)
            anchors.centerIn: parent

            Image {
                visible: false
                id: staticImage
                source: file
                fillMode: Image.PreserveAspectFit
                smooth: true
                anchors.fill: parent
                sourceSize.width: 4000
                sourceSize.height: 4000
            }

            AnimatedImage {
                visible: false
                id: animootedImage
                source: file
                fillMode: Image.PreserveAspectFit
                smooth: true
                anchors.fill: parent
            }
        }
        Component.onCompleted: cache (domain, path)
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
            importModule('savefile', function() {});
        }
        onError: {
            // when an exception is raised, this error handler will be called
            console.log('python error: ' + traceback);
        }
        onReceived: {
            // asychronous messages from Python arrive here
            // in Python, this can be accomplished via pyotherside.send()
            imagePage.progress = data + " %"
        }
    }

    function cache(domain, path) {
        py.call('savefile.cache', [domain, path], function(response) {
            imagePage.file = response
            if (response.match(/gif/)) {animootedImage.visible = true} else {staticImage.visible = true}
            busyIndicator.visible = false
        });
    }
}
