import QtQuick 2.0
import Sailfish.Silica 1.0

Rectangle {
    anchors{
        top: parent.top
    }
    color: Theme.highlightBackgroundColor
    width: parent.width
    height: Theme.paddingLarge * 2
    visible: page.somethingloading
    onVisibleChanged: krooteelkaText.text = page.notification
    BusyIndicator {
        id: krooteelka
        visible: !page.someerror
        size: BusyIndicatorSize.Small
        running: true
        anchors {
            left: parent.left
            verticalCenter: parent.verticalCenter
            leftMargin: Theme.paddingSmall
        }
    }
    Image {
        id: error
        visible: page.someerror
        source: "image://theme/icon-lock-warning"
        anchors {
            left: parent.left
            verticalCenter: parent.verticalCenter
            leftMargin: Theme.paddingSmall
        }
    }
    Label {
        id: krooteelkaText
        text: ""
        anchors {
            left: krooteelka.right
            verticalCenter: parent.verticalCenter
            leftMargin: Theme.paddingSmall
        }
    }
}
