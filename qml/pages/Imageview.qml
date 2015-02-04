import QtQuick 2.1
import Sailfish.Silica 1.0

Page {
    id: imagePage
    allowedOrientations : Orientation.All
    property alias uri: imageItem.source

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
                text: qsTr("Save as (to do)")
                //onClicked: pageStack.push(Qt.resolvedUrl("SaveFile.qml"), {uri: uri})
            }
        }
        Loader {
            id: busyIndicatorLoader
            anchors.centerIn: parent
            sourceComponent: {
                switch (imageItem.status) {
                case Image.Loading: return busyIndicatorComponent
                case Image.Error: return failedLoading
                default: return undefined
                }
            }

            Component {
                id: busyIndicatorComponent

                Item {
                    width: busyIndicator.width
                    height: busyIndicator.height

                    BusyIndicator {
                        id: busyIndicator
                        size: BusyIndicatorSize.Large
                        running: true
                    }
                    Label {
                        anchors.centerIn: parent
                        font.pixelSize: Theme.fontSizeSmall
                        text: Math.round(imageItem.progress * 100) + "%"
                    }
                }
            }
            Component { id: failedLoading; Label { text: qsTr("Error") } }
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

            AnimatedImage {
                id: imageItem
                fillMode: Image.PreserveAspectFit
                smooth: true
                anchors.fill: parent
            }
        }
    }
}
