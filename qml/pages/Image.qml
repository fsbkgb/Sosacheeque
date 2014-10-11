import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: imagePage
    allowedOrientations : Orientation.All
    property string uri: ""
    AnimatedImage {
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
