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
TARGET = harbour-sosacheeque

CONFIG += sailfishapp

SOURCES += \
    src/harbour-sosacheeque.cpp

OTHER_FILES += \
    qml/cover/CoverPage.qml \
    translations/*.ts \
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
    qml/pages/SaveFile.qml \
    qml/harbour-sosacheeque.qml \
    harbour-sosacheeque.desktop \
    translations/harbour-sosacheeque-ru.ts \
    translations/harbour-sosacheeque-ua.ts \
    qml/pages/Boardlist.qml \
    qml/pages/Imageview.qml \
    qml/pages/Thread.qml \
    qml/pages/Threads.qml \
    qml/pages/Webmview.qml \
    qml/js/boards.js \
    qml/js/settings.js \
    rpm/harbour-sosacheeque.changes.in \
    rpm/harbour-sosacheeque.spec \
    rpm/harbour-sosacheeque.yaml \
    qml/js/favorites.js \
    qml/js/threads.js \
    qml/js/posts.js \
    qml/py/newpost.py \
    qml/js/newpost.js

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n
TRANSLATIONS += translations/harbour-sosacheeque-ru.ts
TRANSLATIONS += translations/harbour-sosacheeque-ua.ts

HEADERS +=

