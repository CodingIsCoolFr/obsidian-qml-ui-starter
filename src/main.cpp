#include <QDir>
#include <QFileInfo>
#include <QGuiApplication>
#include <QImage>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QQuickWindow>
#include <QTimer>

int main(int argc, char *argv[])
{
    QQuickStyle::setStyle(QStringLiteral("Basic"));

    QGuiApplication app(argc, argv);
    QCoreApplication::setOrganizationName(QStringLiteral("YourOrganization"));
    QCoreApplication::setApplicationName(QStringLiteral("ObsidianQmlUiStarter"));
    QGuiApplication::setApplicationDisplayName(QStringLiteral("Obsidian UI Starter"));

    QQmlApplicationEngine engine;
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreationFailed,
                     &app, [] { QCoreApplication::exit(EXIT_FAILURE); },
                     Qt::QueuedConnection);
    engine.loadFromModule(QStringLiteral("ObsidianStarter"), QStringLiteral("Main"));

    const QStringList arguments = app.arguments();
    const qsizetype screenshotIndex = arguments.indexOf(QStringLiteral("--screenshot"));
    if (screenshotIndex >= 0 && screenshotIndex + 1 < arguments.size() && !engine.rootObjects().isEmpty()) {
        const QString outputPath = QDir::cleanPath(arguments.at(screenshotIndex + 1));
        auto *window = qobject_cast<QQuickWindow *>(engine.rootObjects().constFirst());
        if (window) {
            QTimer::singleShot(1200, window, [window, outputPath] {
                const QImage image = window->grabWindow();
                QDir().mkpath(QFileInfo(outputPath).absolutePath());
                image.save(outputPath);
                QCoreApplication::quit();
            });
        }
    }

    return app.exec();
}
