#include <QtWidgets\QApplication>
#include <QtWidgets\QPushButton>

int main(int argc, char **argv)
{
    QApplication app(argc, argv);

    QPushButton btn("Hello World!", nullptr);
    btn.resize(100, 30);
    btn.show();
    return app.exec();
}