import QtQuick 2.1
import Sailfish.Silica 1.0
import "../js/db.js" as DB
import "../js/favorites.js" as Favorites

Dialog {
    id: page
    property string thread: ""
    property string board: ""
    property string postcount: ""
    property string title: ""

    onAccepted: {
        DB.openDB()
        Favorites.save(board, thread, postcount, subject.text)
    }

    Column {
        width: parent.width
        DialogHeader  {
            title: qsTr("Edit title")
        }
        TextArea {
            id: subject
            width: parent.width
            height: 350
            placeholderText: qsTr("Title")
            text: title
        }
    }
}
