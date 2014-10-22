import QtQuick 2.0
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
        Component { id: failedLoading; Label { text: "Error loading image" } }
    }
    SilicaFlickable {
        anchors.fill: parent
        PullDownMenu {
            MenuItem {
                text: "Открыть в браузере"
                onClicked: pageStack.push(Qt.openUrlExternally(uri))
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
