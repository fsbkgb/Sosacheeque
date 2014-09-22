import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page
    property string borda: ""
    property string url: ""
    property int pages

    SilicaListView {
        anchors{
            fill: parent
            margins: 16
        }
        id: listView
        model: pages
        header: PageHeader {
            title: "Выбрать страницу"
        }
        delegate: BackgroundItem {
            id: delegate
            Label {
                id: text
                text: index
                width: parent.width
                color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
            }
            onClicked: {
                if (index == 0)
                {url = "https://2ch.hk/" + borda + "/index.json"}
                else
                {url = "https://2ch.hk/" + borda + "/" + index + ".json"}
                pageStack.push(Qt.resolvedUrl("Tredi.qml"), {url: url, borda: borda, pages: pages})
            }
        }
        VerticalScrollDecorator {}
    }
}
