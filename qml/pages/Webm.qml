import QtQuick 2.0
import Sailfish.Silica 1.0
import QtMultimedia 5.0

Page{
    id: page
        allowedOrientations : Orientation.All
        property string uri: ""
    SilicaFlickable {
        anchors.fill: parent
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
