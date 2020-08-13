﻿#include <QtWidgets\QApplication>
#include <QtWidgets\QPushButton>

#include <spdlog/spdlog.h>

void test_spdlog()
{
    spdlog::info("Welcome to spdlog!");
    spdlog::error("Some error message with arg: {}", 1);

    spdlog::warn("Easy padding in numbers like {:08d}", 12);
    spdlog::critical("Support for int: {0:d};  hex: {0:x};  oct: {0:o}; bin: {0:b}", 42);
    spdlog::info("Support for floats {:03.2f}", 1.23456);
    spdlog::info("Positional args are {1} {0}..", "too", "supported");
    spdlog::info("{:<30}", "left aligned");

    spdlog::set_level(spdlog::level::debug); // Set global log level to debug
    spdlog::debug("This message should be displayed..");
}

int main(int argc, char **argv)
{
    test_spdlog();
    QApplication app(argc, argv);

    QPushButton btn("Hello World!", nullptr);
    btn.resize(100, 30);
    btn.show();
    return app.exec();
}
