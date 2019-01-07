import QtQuick 2.1
import Sailfish.Silica 1.0
import QtMultimedia 5.0
import io.thp.pyotherside 1.3

Page{
    id: page
    allowedOrientations : Orientation.All
    property string domain: ""
    property string path: ""
    property string file: ""
    property string filesize: ""
    property string progress: "0 %"

    SilicaFlickable {
        anchors.fill: parent

        PullDownMenu {
            MenuItem {
                text: qsTr("Open in browser")
                onClicked: pageStack.push(Qt.openUrlExternally("https://2ch." + domain + path))
            }
            MenuItem {
                text: qsTr("Save as")
                onClicked: pageStack.push(Qt.resolvedUrl("SaveFile.qml"), {uri: file})
            }
        }
        Item {
            anchors.fill: parent

            BusyIndicator {
                visible: false
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
        Item {
            anchors.fill: parent
            MediaPlayer{
                id: mediaPlayer
                autoLoad: false
                source: file
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
                        cache (domain, path);
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
            page.progress = data + " %"
        }
    }

    function cache(domain, path) {
        busyIndicator.visible = true
        py.call('savefile.cache', [domain, path], function(response) {
            page.file = response
            busyIndicator.visible = false
            mediaPlayer.play()
        });
    }
}
