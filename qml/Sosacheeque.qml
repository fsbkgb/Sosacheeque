import QtQuick 2.0
import Sailfish.Silica 1.0
import "pages"

ApplicationWindow
{
    initialPage: Component { Bordi { } }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    id: mainWindow
}
