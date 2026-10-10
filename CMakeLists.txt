cmake_minimum_required(VERSION 3.24)

project(BetterTTY
    VERSION 1.0.2
    DESCRIPTION "A clean cross-platform SSH and SFTP client"
    HOMEPAGE_URL "https://bettertty.dev"
    LANGUAGES CXX
)

# PROJECT_VERSION is the single numeric source of truth for app, Windows metadata,
# macOS bundle and package helpers. Cross-platform release validation is tracked
# separately; a version number alone does not certify a build.
set(BETTERTTY_VERSION_STRING "${PROJECT_VERSION}")
set(BETTERTTY_CODENAME_STRING "Andromeda")
set(BETTERTTY_MILESTONE_STRING "Maintenance and usability update")
set(BETTERTTY_BUNDLE_ID "hr.ddlab.bettertty")

# If configured inside a Git checkout, expose a commit ID; source ZIPs are marked distinctly.
set(BETTERTTY_BUILD_ID "source-archive")
find_package(Git QUIET)
if(Git_FOUND AND EXISTS "${CMAKE_SOURCE_DIR}/.git")
    execute_process(
        COMMAND "${GIT_EXECUTABLE}" rev-parse --short=8 HEAD
        WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}"
        OUTPUT_VARIABLE BETTERTTY_BUILD_ID
        OUTPUT_STRIP_TRAILING_WHITESPACE
        ERROR_QUIET
        RESULT_VARIABLE BETTERTTY_GIT_RESULT
    )
    if(NOT BETTERTTY_GIT_RESULT EQUAL 0 OR BETTERTTY_BUILD_ID STREQUAL "")
        set(BETTERTTY_BUILD_ID "git-unknown")
    else()
        execute_process(
            COMMAND "${GIT_EXECUTABLE}" status --porcelain
            WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}"
            OUTPUT_VARIABLE BETTERTTY_WORKTREE_STATUS
            OUTPUT_STRIP_TRAILING_WHITESPACE
            ERROR_QUIET
        )
        if(NOT BETTERTTY_WORKTREE_STATUS STREQUAL "")
            string(APPEND BETTERTTY_BUILD_ID "-dirty")
        endif()
    endif()
endif()

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

find_package(Qt6 REQUIRED COMPONENTS Core Widgets WebEngineWidgets WebChannel)
find_package(PkgConfig REQUIRED)
pkg_check_modules(LIBSSH REQUIRED IMPORTED_TARGET libssh)

qt_standard_project_setup()

qt_add_executable(bettertty
    src/main.cpp

    src/ui/MainWindow.h
    src/ui/MainWindow.cpp
    src/ui/ConnectDialog.h
    src/ui/ConnectDialog.cpp
    src/ui/BasicTerminalTab.h
    src/ui/BasicTerminalTab.cpp
    src/ui/TerminalBridge.h
    src/ui/TerminalBridge.cpp
    src/ui/WebTerminalTab.h
    src/ui/WebTerminalTab.cpp
    src/ui/SettingsDialog.h
    src/ui/SettingsDialog.cpp
    src/ui/SftpBrowserTab.h
    src/ui/SftpBrowserTab.cpp

    src/core/SessionProfile.h
    src/core/ConfigManager.h
    src/core/ConfigManager.cpp
    src/core/KnownHostsManager.h
    src/core/KnownHostsManager.cpp
    src/core/AppLogger.h
    src/core/AppLogger.cpp

    src/ssh/SshCompatibility.h
    src/ssh/SshCompatibility.cpp
    src/ssh/SshSession.h
    src/ssh/SshSession.cpp
    src/ssh/SshShellWorker.h
    src/ssh/SshShellWorker.cpp

    src/sftp/SftpProbe.h
    src/sftp/SftpProbe.cpp
)

qt_add_resources(bettertty "xterm_assets"
    PREFIX "/xterm"
    BASE "resources/xterm"
    FILES
        resources/xterm/xterm.js
        resources/xterm/xterm.css
        resources/xterm/addon-fit.js
        resources/xterm/LICENSE.xterm.txt
        resources/xterm/LICENSE.addon-fit.txt
        resources/xterm/THIRD_PARTY_NOTICES.md
)

qt_add_resources(bettertty "icon_assets"
    PREFIX "/icons"
    BASE "resources/icons"
    FILES
        resources/icons/bettertty.png
        resources/icons/bettertty-16.png
        resources/icons/bettertty-24.png
        resources/icons/bettertty-32.png
        resources/icons/bettertty-48.png
        resources/icons/bettertty-64.png
        resources/icons/bettertty-128.png
        resources/icons/bettertty-256.png
        resources/icons/bettertty-512.png
        resources/icons/bettertty-1024.png
        resources/icons/tab-close-dark.png
        resources/icons/tab-close-light.png
        resources/icons/checkbox-light-unchecked.png
        resources/icons/checkbox-light-checked.png
        resources/icons/checkbox-light-unchecked-disabled.png
        resources/icons/checkbox-light-checked-disabled.png
        resources/icons/checkbox-dark-unchecked.png
        resources/icons/checkbox-dark-checked.png
        resources/icons/checkbox-dark-unchecked-disabled.png
        resources/icons/checkbox-dark-checked-disabled.png
)

if(WIN32)
    file(MAKE_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/generated")
    configure_file(
        "${CMAKE_CURRENT_SOURCE_DIR}/resources/windows/bettertty.rc.in"
        "${CMAKE_CURRENT_BINARY_DIR}/generated/bettertty.rc"
        @ONLY
    )
    target_sources(bettertty PRIVATE
        "${CMAKE_CURRENT_BINARY_DIR}/generated/bettertty.rc"
    )
endif()

if(APPLE)
    set_source_files_properties(resources/macos/bettertty.icns PROPERTIES
        MACOSX_PACKAGE_LOCATION "Resources"
    )
    target_sources(bettertty PRIVATE
        resources/macos/bettertty.icns
    )
endif()

target_include_directories(bettertty
    PRIVATE
        src
)

target_compile_definitions(bettertty
    PRIVATE
        BETTERTTY_VERSION_STRING="${BETTERTTY_VERSION_STRING}"
        BETTERTTY_CODENAME_STRING="${BETTERTTY_CODENAME_STRING}"
        BETTERTTY_MILESTONE_STRING="${BETTERTTY_MILESTONE_STRING}"
        BETTERTTY_BUILD_ID="${BETTERTTY_BUILD_ID}"
)

target_link_libraries(bettertty
    PRIVATE
        Qt6::Core
        Qt6::Widgets
        Qt6::WebEngineWidgets
        Qt6::WebChannel
        PkgConfig::LIBSSH
)

if(WIN32 OR APPLE)
    set(BETTERTTY_OUTPUT_NAME "BetterTTY")
else()
    set(BETTERTTY_OUTPUT_NAME "bettertty")
endif()

set_target_properties(bettertty PROPERTIES
    OUTPUT_NAME "${BETTERTTY_OUTPUT_NAME}"
    WIN32_EXECUTABLE TRUE
    MACOSX_BUNDLE TRUE
    MACOSX_BUNDLE_BUNDLE_NAME "BetterTTY"
    MACOSX_BUNDLE_GUI_IDENTIFIER "${BETTERTTY_BUNDLE_ID}"
    MACOSX_BUNDLE_BUNDLE_VERSION "${PROJECT_VERSION}"
    MACOSX_BUNDLE_SHORT_VERSION_STRING "${PROJECT_VERSION}"
    MACOSX_BUNDLE_ICON_FILE "bettertty.icns"
)

include(GNUInstallDirs)

install(TARGETS bettertty
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    BUNDLE DESTINATION .
)

install(FILES resources/linux/bettertty.desktop.in
    RENAME bettertty.desktop
    DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/applications
)

foreach(icon_size 16 24 32 48 64 128 256 512 1024)
    install(FILES resources/icons/bettertty-${icon_size}.png
        RENAME bettertty.png
        DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/icons/hicolor/${icon_size}x${icon_size}/apps
    )
endforeach()

install(FILES
        README.md
        LICENSE
    DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/doc/bettertty
)

install(DIRECTORY docs/
    DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/doc/bettertty/docs
    FILES_MATCHING
        PATTERN "*.md"
        PATTERN "*.png"
)
