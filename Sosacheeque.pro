# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = Sosacheeque

CONFIG += sailfishapp

SOURCES += src/Sosacheeque.cpp

OTHER_FILES += qml/Sosacheeque.qml \
    qml/cover/CoverPage.qml \
    rpm/Sosacheeque.changes.in \
    rpm/Sosacheeque.spec \
    rpm/Sosacheeque.yaml \
    translations/*.ts \
    Sosacheeque.desktop \
    qml/pages/Bordi.qml \
    qml/pages/Tredi.qml \
    qml/pages/Tred.qml \
    qml/pages/Paginator.qml \
    qml/pages/Webview.qml \
    qml/images/abu.png \
    qml/pages/Chooseboard.qml \
    qml/pages/Postview.qml \
    README.md \
    qml/pages/Newpost.qml \
    qml/pages/Favorites.qml \
    qml/js/db.js \
    qml/pages/Settings.qml \
    qml/pages/Image.qml \
    qml/pages/Webm.qml \
    translations/Sosacheeque-ua.ts \
    translations/Sosacheeque-ru.ts

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n
TRANSLATIONS += translations/Sosacheeque-ru.ts
TRANSLATIONS += translations/Sosacheeque-ua.ts

