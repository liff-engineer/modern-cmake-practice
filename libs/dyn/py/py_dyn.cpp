#include <pybind11/pybind11.h>
#include <pybind11/stl.h>
#include "dyn/dyn.hpp"

namespace py = pybind11;

PYBIND11_MODULE(dyn, m) {
    m.doc() = u8"cmake&pybind11 example";

    m.def("ReportLibrarys", []() {
            auto results = ReadFileLines();
            for (auto& result : results)
            {
                py::print(result);
            }
        });
    m.def("ReadFileLines", [](std::string const& file)->std::vector<std::string> {
            return ReadFileLines(file);
        },py::arg("file"));
}
