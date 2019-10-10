#ifndef SHORTCUT_H
#define SHORTCUT_H

#include <QObject>
#include <QGuiApplication>
#include <QQuickItem>
#include <QQuickWindow>

class ShortCut : public QObject
{
    Q_OBJECT
public:
    explicit ShortCut(QObject *parent = nullptr) : QObject(parent) {}
    Q_INVOKABLE void simulateKey(int key, Qt::KeyboardModifiers modifiers, const QString &text) {
        QQuickItem *r = qobject_cast<QQuickItem *>(QGuiApplication::focusObject());
        if (r) {
            bool autorep = false;
            QKeyEvent press = QKeyEvent(QKeyEvent::KeyPress, key, modifiers, text, autorep);
            r->window()->sendEvent(r, &press);
            QKeyEvent release = QKeyEvent(QKeyEvent::KeyRelease, key, modifiers, text, autorep);
            r->window()->sendEvent(r, &release);
        }
    };

signals:

public slots:
};

#endif // SHORTCUT_H
