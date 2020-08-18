from dataclasses import dataclass
from jinja2 import Template


@dataclass
class library:
    name: str
    type: str
    withQtLinguist: bool
    withQtMOC: bool
    withPCH: bool
    withData: bool
    withExtra: bool
    withInstall: bool
    withExample: bool


@dataclass
class project:
    name: str
    withMasterCheck: bool
    withNinjaSupport: bool
    withPCHSupport: bool
    withVersion: bool
    withExamples: bool
    withInstall: bool
    withExtras: bool


prj = project(
    name='cmakeuser',
    withMasterCheck=False,
    withNinjaSupport=True,
    withPCHSupport=False,
    withVersion=False,
    withExamples=True,
    withInstall=False,
    withExtras=True
)

lib = library(
    name='dyn',
    type='executable',
    withQtLinguist=False,
    withQtMOC=False,
    withPCH=False,
    withData=False,
    withExtra=False,
    withInstall=prj.withInstall,
    withExample=False
)
with open('template/project.jinja.cmake', encoding='utf-8') as file:
    template = Template(file.read(), trim_blocks=True, lstrip_blocks=True)
    template.stream(prj=prj
                    ).dump(f'result/CMakeLists.txt')

with open('template/library.jinja.cmake', encoding='utf-8') as file:
    template = Template(file.read(), trim_blocks=True, lstrip_blocks=True)
    template.stream(lib=lib
                    ).dump(f'result/CMakeLists.txt')
