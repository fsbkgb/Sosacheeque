import QtQuick 2.1
import Sailfish.Silica 1.0
import QtMultimedia 5.0

Page{
    id: page
    allowedOrientations : Orientation.All
    property string uri: ""

    Loader {
        id: busyIndicatorLoader
        anchors.centerIn: parent
        sourceComponent: {
            switch (mediaPlayer.status) {
            case MediaPlayer.Loading: return busyIndicatorComponent
            case MediaPlayer.InvalidMedia: return failedLoading
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
                /*Label {
                    anchors.centerIn: parent
                    font.pixelSize: Theme.fontSizeSmall
                    text: Math.round(mediaPlayer.progress * 100) + "%"
                }*/
            }
        }
        Component { id: failedLoading; Label { text: qsTr("Error") } }
    }
    SilicaFlickable {
        anchors.fill: parent

        PullDownMenu {
            MenuItem {
                text: qsTr("Open in browser")
                onClicked: pageStack.push(Qt.openUrlExternally(uri))
            }
            MenuItem {
                text: qsTr("Save as")
                onClicked: pageStack.push(Qt.resolvedUrl("SaveFile.qml"), {uri: uri})
            }
        }
        MediaPlayer{
            id: mediaPlayer
            autoLoad: true
            autoPlay: true
            source: uri
        }
        VideoOutput {
            id: videoOutput
            anchors.centerIn: parent
            source: mediaPlayer
            anchors.fill: parent
        }
    }
}
