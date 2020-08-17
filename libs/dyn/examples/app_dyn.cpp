#include "dyn/dyn.hpp"
#include <QtCore/QCoreApplication>
#include <iostream>

int main(int argc, char** argv)
{
    QCoreApplication app{ argc, argv };

    auto results = ReadFileLines();

    for (auto& result : results)
    {
        std::cout << result << "\n";
    }
    return 0;
}
