import os
import re
import sys
import platform
import subprocess


from setuptools import setup, Extension
from setuptools.command.build_ext import build_ext
from distutils.version import LooseVersion

# 从外部读取传递给CMake的配置
if os.path.exists("builder.py"):
    from builder import *
else:
    project_version = '1.0.0.0'
    generator = 'Visual Studio 15 2017'
    toolset = 'v141'


def setup_init_py(dir):
    all = []
    for file in [file for file in os.listdir(dir) if file.endswith(".pyd")]:
        all.append('"{}"'.format(file.split('.', 1)[0]))

    with open(os.path.join(dir, "__init__.py"), "w") as file:
        file.write('__all__=[{}]'.format(','.join(all)))
    return


class CMakeExtension(Extension):
    def __init__(self, name, sourcedir=''):
        Extension.__init__(self, name, sources=[])
        self.sourcedir = os.path.abspath(sourcedir)


class CMakeBuild(build_ext):
    def run(self):
        try:
            out = subprocess.check_output(['cmake', '--version'])
        except OSError:
            raise RuntimeError("CMake must be installed to build the following extensions: " +
                               ", ".join(e.name for e in self.extensions))

        if platform.system() == "Windows":
            cmake_version = LooseVersion(
                re.search(r'version\s*([\d.]+)', out.decode()).group(1))
            if cmake_version < '3.1.0':
                raise RuntimeError("CMake >= 3.1.0 is required on Windows")

        for ext in self.extensions:
            self.build_extension(ext)

    def build_extension(self, ext):
        extdir = os.path.abspath(os.path.dirname(
            self.get_ext_fullpath(ext.name)))
        # 配置输出路径
        cmake_args = ['-DCMAKE_RUNTIME_OUTPUT_DIRECTORY=' + extdir,
                      '-DCMAKE_LIBRARY_OUTPUT_DIRECTORY=' + extdir,
                      '-DPYTHON_EXECUTABLE=' + sys.executable]
        # 配置工程版本号
        cmake_args += ['-DPROJECT_VERSION=' + project_version]

        # 配置生成器
        cmake_args += ['-G', generator]

        # 配置生成配置
        cfg = 'Debug' if self.debug else 'Release'
        build_args = ['--config', cfg]

        # 如果是MSVC则配置工具集
        if generator != 'Ninja':
            if generator != 'Visual Studio 14 2015':
                cmake_args += ['-T', toolset]

        cmake_args += ['-Dcmakeuser_EXTRAS=ON']

        if platform.system() == "Windows":
            cmake_args += [
                '-DCMAKE_RUNTIME_OUTPUT_DIRECTORY_{}={}'.format(cfg.upper(), extdir)]
            cmake_args += [
                '-DCMAKE_LIBRARY_OUTPUT_DIRECTORY_{}={}'.format(cfg.upper(), extdir)]
            if sys.maxsize > 2**32 and generator != 'Ninja':
                cmake_args += ['-A', 'x64']
        else:
            cmake_args += ['-DCMAKE_BUILD_TYPE=' + cfg]

        env = os.environ.copy()
        env['CXXFLAGS'] = '{} -DVERSION_INFO=\\"{}\\"'.format(env.get('CXXFLAGS', ''),
                                                              self.distribution.get_version())
        if not os.path.exists(self.build_temp):
            os.makedirs(self.build_temp)
        # 执行配置动作
        subprocess.check_call(['cmake', ext.sourcedir] +
                              cmake_args, cwd=self.build_temp, env=env)
        # 执行构建动作
        subprocess.check_call(['cmake', '--build', '.'] +
                              build_args, cwd=self.build_temp)

        # 生成__init__.py文件
        setup_init_py(extdir)


sourcedir = os.path.dirname(os.path.realpath(__file__))

setup(
    name='cmakeuser',
    version=project_version,
    description='cmakeuser:C++模块Python接口',
    author='liff',
    author_email='liff.engineer@gmail.com',
    long_description='',
    ext_modules=[CMakeExtension('cmakeuser.impl', sourcedir=sourcedir)],
    cmdclass=dict(build_ext=CMakeBuild),
    zip_safe=False,
)
