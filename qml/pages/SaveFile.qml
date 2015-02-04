import QtQuick 2.1
import Sailfish.Silica 1.0

Dialog {
    id: page
    property string uri: ""

    SilicaListView {
        id: saveform
        header: PageHeader {
            title: qsTr("Save")
        }
        anchors{
            fill: parent
        }

        Label {
            id: filepath
            width: parent.width
            text: uri
            anchors{
                top: parent.top
                topMargin: Theme.paddingLarge * 4
            }
        }
        Label {
            width: parent.width
            text: uri.match(/\d+\.[a-z]+/)[0]
            anchors{
                top: filepath.bottom
            }
        }
    }
}
