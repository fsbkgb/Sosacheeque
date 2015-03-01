import QtQuick 2.1
import Sailfish.Silica 1.0

Page {
    id: page
    property string board: ""
    property string url: ""
    property string domain: ""
    property int pages

    SilicaListView {
        anchors{
            fill: parent
            margins: 16
        }
        id: listView
        model: pages
        header: PageHeader {
            title: qsTr("Choose page")
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
                {url = "https://2ch." + domain + "/" + board + "/index.json"}
                else
                {url = "https://2ch." + domain + "/" + board + "/" + index + ".json"}
                pageStack.push(Qt.resolvedUrl("Posts.qml"), {url: url, board: board, pages: pages, domain: domain, state: "board"})
            }
        }
        VerticalScrollDecorator {}
    }
}
