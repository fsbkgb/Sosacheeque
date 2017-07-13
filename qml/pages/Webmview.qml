import QtQuick 2.1
import Sailfish.Silica 1.0
import QtMultimedia 5.0

Page{
    id: page
    allowedOrientations : Orientation.All
    property string uri: ""
    property string filesize: ""

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
                Label {
                    anchors.centerIn: parent
                    font.pixelSize: Theme.fontSizeSmall
                    text: Math.round(mediaPlayer.bufferProgress * 100) + "%"
                }
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
        Item {
            anchors.fill: parent
            MediaPlayer{
                id: mediaPlayer
                autoLoad: false
                source: uri
                loops: MediaPlayer.Infinite
            }
            VideoOutput {
                id: videoOutput
                anchors.centerIn: parent
                source: mediaPlayer
                anchors.fill: parent
            }
            MouseArea {
                id: playArea
                anchors.fill: parent
                onClicked: {
                    if (mediaPlayer.playbackState === MediaPlayer.PlayingState) {
                        mediaPlayer.pause();
                    } else if (mediaPlayer.playbackState === MediaPlayer.PausedState) {
                        mediaPlayer.play();
                    } else if (mediaPlayer.playbackState === MediaPlayer.StoppedState) {
                        mediaPlayer.play();
                    }
                    info.visible = false
                }
                Text {
                    id: info
                    anchors.fill: parent
                    text: qsTr("Tap to load media") + " (" + filesize + " kB)"
                    color: Theme.highlightColor
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }
    }
}
