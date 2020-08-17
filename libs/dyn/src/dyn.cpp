#include "dyn.hpp"
#include <QtCore/QFile>
#include <QtCore/QCoreApplication>
#include <QtCore/QTextStream>

namespace
{
    std::vector<std::string> ReadFileLinesImpl(QString const& filename)
    {
        std::vector<std::string> results;
        QFile file(filename);
        if (file.open(QIODevice::ReadOnly | QIODevice::Text)) {
            QTextStream stream(&file);
            while (!stream.atEnd()) {
                results.emplace_back(stream.readLine().toStdString());
            }
        }
        file.close();
        return results;
    }
}

std::vector<std::string> ReadFileLines()
{
    return ReadFileLinesImpl(QCoreApplication::applicationDirPath() + "/libraries.txt");
}

std::vector<std::string> ReadFileLines(std::string const& filename)
{
    return ReadFileLinesImpl(QString::fromStdString(filename));
}
