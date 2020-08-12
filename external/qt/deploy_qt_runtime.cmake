include(CMakeParseArguments)
include(CMakePrintHelpers)

#部署Qt的运行时以及插件
function(deploy_qt_runtime)
    set(options WebEngine)
    set(oneValueArgs TARGET)
    set(multiValueArgs PLUGINS)
    cmake_parse_arguments(Gen "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})    

    if(NOT QTDIR)
        return()
    endif()
    cmake_print_variables(QTDIR)
    
    #找到Qt的部署程序
    find_program(__qt5_deploy windeployqt PATHS ${QTDIR})
    
    #将插件列表转换成命令行形式
    set(plugins "")
    foreach(__plugin ${Gen_PLUGINS})
        string(APPEND plugins " -${__plugin}")
    endforeach()
    
    #部署Qt运行时及插件
    separate_arguments(plugins_list WINDOWS_COMMAND ${plugins})
    add_custom_command(TARGET ${Gen_TARGET} POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E env QTDIR="${QTDIR}" "PATH=${QTDIR}/bin"  windeployqt.exe $<TARGET_FILE:${Gen_TARGET}> ${plugins_list}
        COMMENT "deplot qt runtime dependencies"
    )

    #Qt如果部署包含Qt WebEngine的应用,需要处理无法自动部署的资源
    if(Gen_WebEngine)
        add_custom_command(TARGET ${Gen_TARGETS} POST_BUILD
            COMMAND ${CMAKE_COMMAND} -E copy_directory  "${QTDIR}/resources/"  $<TARGET_FILE_DIR:${Gen_TARGET}>
            COMMENT "deploy qt WebEngine resources"
            COMMAND ${CMAKE_COMMAND} -E copy 
            "${QTDIR}/bin/$<IF:$<CONFIG:DEBUG>,QtWebEngineProcessd.exe,QtWebEngineProcess.exe>" 
            "$<TARGET_FILE_DIR:${Gen_TARGET}>/$<IF:$<CONFIG:DEBUG>,QtWebEngineProcessd.exe,QtWebEngineProcess.exe>"            
            COMMENT "deploy qt WebEngine process"
        )
    endif()

endfunction()

