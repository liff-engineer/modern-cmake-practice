cmake_minimum_required(VERSION 3.15)

##dyn模块python接口
pybind11_add_module(py_dyn)

##指定源文件
target_sources(py_dyn
	PRIVATE py_dyn.cpp
)

##指定输出名,注意和源代码中模块定义保持一致
set_target_properties(py_dyn PROPERTIES 
	OUTPUT_NAME "dyn"
	PDB_NAME "py_dyn"
	FOLDER "extras"
)

##配置库依赖
target_link_libraries(py_dyn 
	PRIVATE ${PROJECT_NAME}::dyn 
)

