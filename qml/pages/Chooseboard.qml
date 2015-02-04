import QtQuick 2.1
import Sailfish.Silica 1.0
import "../js/boards.js" as Boards

Page {
    id: page
    property string domain: ""

    SilicaFlickable {
        anchors{
            fill: parent
            topMargin: Theme.paddingLarge * 4
        }

        Column {
            id: column
            width: parent.width

            TextField {
                width: parent.width
                placeholderText: "b"
                focus: true
                validator: RegExpValidator {regExp: /[a-z]+/}
                EnterKey.onClicked: {
                    Boards.getOne(text);
                    parent.focus = true;
                }
            }
        }
    }
}
