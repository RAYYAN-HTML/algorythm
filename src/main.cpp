#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QPalette>
#include <QQuickStyle>
#include "engine/playbackcontroller.h"
#include "controllers/structurecontroller.h"
#include "controllers/graphcontroller.h"

int main(int argc, char *argv[])
{
    QQuickStyle::setStyle("Fusion");
    QGuiApplication app(argc, argv);
    QPalette dark;
    dark.setColor(QPalette::Window, QColor("#080C17"));
    dark.setColor(QPalette::WindowText, QColor("#F8FAFC"));
    dark.setColor(QPalette::Base, QColor("#101827"));
    dark.setColor(QPalette::AlternateBase, QColor("#151F32"));
    dark.setColor(QPalette::Text, QColor("#F8FAFC"));
    dark.setColor(QPalette::Button, QColor("#182438"));
    dark.setColor(QPalette::ButtonText, QColor("#F8FAFC"));
    dark.setColor(QPalette::Highlight, QColor("#22D3EE"));
    dark.setColor(QPalette::HighlightedText, QColor("#080C17"));
    dark.setColor(QPalette::PlaceholderText, QColor("#94A3B8"));
    app.setPalette(dark);
    app.setApplicationName("Algorythm");
    app.setOrganizationName("Algorythm Studio");
    PlaybackController playback;
    PlaybackController playbackA;
    PlaybackController playbackB;
    StructureController structures;
    GraphController graph;
    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("playback", &playback);
    engine.rootContext()->setContextProperty("playbackA", &playbackA);
    engine.rootContext()->setContextProperty("playbackB", &playbackB);
    engine.rootContext()->setContextProperty("structures", &structures);
    engine.rootContext()->setContextProperty("graph", &graph);
    engine.loadFromModule("Algorythm", "Main");
    if (engine.rootObjects().isEmpty()) return -1;
    return app.exec();
}

