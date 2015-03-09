import QtQuick 2.1
import Sailfish.Silica 1.0
import "../js/db.js" as DB
import "../js/settings.js" as Settings

Page {
    property var option
    id: page
    PageHeader {
        title: qsTr("Settings")
    }

    SilicaFlickable {
        anchors{
            fill: parent
            topMargin: Theme.paddingLarge * 4
        }

        Column {
            id: column
            width: parent.width

            ComboBox {
                id: domain
                width: page.width
                label: qsTr("Domain")
                currentIndex: -1
                menu: ContextMenu {
                    MenuItem { text: "hk" }
                    MenuItem { text: "pm" }
                }
                onCurrentItemChanged: {
                    Settings.save("domain", currentItem.text)
                    domain.value = page.option[0].value
                    updatepages ()
                }
            }
            TextSwitch {
                id: userboards
                checked: false
                text: "Show user boards"
                onCheckedChanged: {
                    Settings.save("userboards", checked ? "show" : "hide" );
                    updatepages ()
                }
            }
        }
    }
    Component.onCompleted: {
        Settings.load()
        domain.value = page.option[0].value
        if (page.option[1].value === "show") {
            userboards.checked = true
        }
    }

    function updatepages () {
        var boardsPage = pageStack.find(function(page) { return page.objectName == "boardsPage"; })
        var favsPage = pageStack.find(function(page) { return page.objectName == "favsPage"; })
        boardsPage.loadlist()
        favsPage.loadfavs()
    }
}
