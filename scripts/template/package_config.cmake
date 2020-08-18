macro(check_required_components _NAME)
  foreach(comp ${${_NAME}_FIND_COMPONENTS})
    if(NOT TARGET ${_NAME}::${comp})
      if(${_NAME}_FIND_REQUIRED_${comp})
        set(${_NAME}_FOUND FALSE)
      endif()
    endif()
  endforeach()
endmacro()

##检查必须存在的库
include(CMakeFindDependencyMacro)

##注意目的并不是检查所有依赖项,因为package有public的依赖
##所以要保证对应的package存在,这样才有继续使用的可能
find_dependency(Qt5 COMPONENTS Core REQUIRED)

include("${CMAKE_CURRENT_LIST_DIR}/@PROJECT_NAME@_targets.cmake")
check_required_components(@PROJECT_NAME@)