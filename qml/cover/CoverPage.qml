import QtQuick 2.0
import Sailfish.Silica 1.0

CoverBackground {
    Image {
        id: image
        anchors{
            fill: parent
            left: parent.left
        }
        fillMode: Image.PreserveAspectFit
        smooth: true
        source: "../images/abu.png"
    }
    CoverActionList {
        id: coverAction
        CoverAction {
            iconSource: "image://theme/icon-cover-refresh"
            onTriggered: {
                pageStack.clear()
                pageStack.push(Qt.resolvedUrl("../pages/Boardlist.qml"))
                mainWindow.activate()
            }
        }
        CoverAction {
            iconSource: "image://theme/icon-cover-favorite"
            onTriggered: {
                pageStack.clear()
                pageStack.push(Qt.resolvedUrl("../pages/Favorites.qml"))
                mainWindow.activate()
            }
        }
    }
}
