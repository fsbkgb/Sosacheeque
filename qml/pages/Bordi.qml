import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page
    property var razdely
    property bool loading: false
    function getBoards() {
        page.loading = true;
        var xhr = new XMLHttpRequest();
        var categories = []
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.HEADERS_RECEIVED) {
                print('HEADERS_RECEIVED');
            } else if(xhr.readyState === XMLHttpRequest.DONE) {
                var parsed = JSON.parse(xhr.responseText);
                for (var category in parsed) {
                    if (parsed.hasOwnProperty(category)) {
                        categories.push(parsed[category])
                    }
                }
                page.razdely = categories
                page.loading = false;
            }
        }
        xhr.open("GET", "https://2ch.hk/makaba/mobile.fcgi?task=get_boards");
        xhr.send();
    }
    BusyIndicator {
        anchors.centerIn: parent
        running: page.loading
        visible: page.loading
        size: BusyIndicatorSize.Large
    }
    SilicaListView {
        id: listView
        visible: !page.loading
        model: razdely
        anchors.fill: parent
        header: PageHeader {
            title: "САСАЧ))"
        }
        PullDownMenu {
            MenuItem {
                text: "Ввести имя борды"
                onClicked: pageStack.push(Qt.resolvedUrl("Chooseboard.qml") )
            }
        }
        delegate: BackgroundItem {
            id: delegate
            height: (rowrow.implicitHeight + razd.implicitHeight  + 15)
            Column {
                id:rowrow
                spacing: 5
                Text {
                    id: razd
                    text: modelData[0].category
                    color: Theme.highlightColor
                    anchors {
                        left: parent.left
                        leftMargin: 5
                    }
                }
                Repeater {
                    id: bordachki
                    model: modelData
                    height: childrenRect.height
                    Label {
                        id: text
                        text: "/" + modelData.id + "/ – " + modelData.name
                        horizontalAlignment: Text.AlignLeft
                        truncationMode: TruncationMode.Fade
                        width: page.width
                        color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
                        anchors{
                            topMargin: 5
                            left: parent.left
                            leftMargin: 5
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: pageStack.push(Qt.resolvedUrl("Tredi.qml"), {url: "https://2ch.hk/" + modelData.id + "/index.json", borda: modelData.id, pages: modelData.pages} )
                        }
                    }
                }
            }
        }
        VerticalScrollDecorator {}
    }
    Component.onCompleted: {
        getBoards()
    }
}
