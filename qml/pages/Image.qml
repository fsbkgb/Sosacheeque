import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: imagePage
    allowedOrientations : Orientation.All
    property string uri: ""
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
        Component { id: failedLoading; Label { text: "Error loading image" } }
    }
    AnimatedImage {
        id: imageItem
        source: uri
        fillMode: Image.PreserveAspectFit
        smooth: true
        anchors.fill: parent
        PinchArea {
            anchors.fill: parent
            pinch.target: parent
            pinch.minimumScale: 1
            pinch.maximumScale: 4
        }
    }
}
