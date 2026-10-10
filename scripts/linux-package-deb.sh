#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd -- "${SCRIPT_DIR}/.." && pwd)"

PACKAGE_NAME="${PACKAGE_NAME:-bettertty}"
detect_project_version() {
    local cmake_file="${PROJECT_ROOT}/CMakeLists.txt"
    local version=""

    if [[ -f "${cmake_file}" ]]; then
        version="$(sed -nE '1,25s/^[[:space:]]*VERSION[[:space:]]+([0-9]+\.[0-9]+\.[0-9]+)[[:space:]]*$/\1/p' "${cmake_file}" | head -n 1 || true)"
    fi

    if [[ -n "${version}" ]]; then
        echo "${version}"
        return 0
    fi

    echo "ERROR: Could not extract project(VERSION ...) from CMakeLists.txt" >&2
    return 1
}
PROJECT_VERSION="$(detect_project_version)"
DEB_VERSION="${BETTERTTY_DEB_VERSION:-${PROJECT_VERSION}}"
ARCH="${DEB_ARCH:-$(dpkg --print-architecture 2>/dev/null || echo amd64)}"
BUILD_DIR="${BUILD_DIR:-${PROJECT_ROOT}/build-linux-release}"
OUT_DIR="${OUT_DIR:-${PROJECT_ROOT}/dist/deb}"
PKG_ROOT="${OUT_DIR}/${PACKAGE_NAME}_${DEB_VERSION}_${ARCH}"
DEB_FILE="${OUT_DIR}/${PACKAGE_NAME}_${DEB_VERSION}_${ARCH}.deb"

if ! command -v dpkg-deb >/dev/null 2>&1; then
    echo "ERROR: dpkg-deb not found. Install dpkg-dev/dpkg first." >&2
    exit 1
fi

if [[ ! -x "${BUILD_DIR}/bettertty" ]]; then
    echo "[BetterTTY] Release binary not found. Building first..."
    "${SCRIPT_DIR}/linux-build-release.sh"
fi

echo "[BetterTTY] Debian package version: ${DEB_VERSION}"
echo "[BetterTTY] Creating Debian package staging tree..."
rm -rf "${PKG_ROOT}" "${DEB_FILE}"
mkdir -p "${PKG_ROOT}"

DESTDIR="${PKG_ROOT}" cmake --install "${BUILD_DIR}" --prefix /usr

mkdir -p "${PKG_ROOT}/DEBIAN"

fallback_depends="libc6, libstdc++6, libgcc-s1, libssh-4, libqt6core6, libqt6gui6, libqt6widgets6, libqt6webchannel6, libqt6webenginecore6, libqt6webenginewidgets6"

detect_depends() {
    if [[ -n "${BETTERTTY_DEB_DEPENDS:-}" ]]; then
        echo "${BETTERTTY_DEB_DEPENDS}"
        return 0
    fi

    if command -v dpkg-shlibdeps >/dev/null 2>&1; then
        local tmp_dir="${OUT_DIR}/.shlibdeps"
        rm -rf "${tmp_dir}"
        mkdir -p "${tmp_dir}/debian"
        cat > "${tmp_dir}/debian/control" <<EOF
Source: ${PACKAGE_NAME}
Section: net
Priority: optional
Maintainer: Dalibor Klobučarić <info@dd-lab.net>
Standards-Version: 4.6.2

Package: ${PACKAGE_NAME}
Architecture: any
Depends: \${shlibs:Depends}, \${misc:Depends}
Description: BetterTTY dependency probe package
 Temporary control file used by dpkg-shlibdeps.
EOF
        local deps_output=""
        deps_output="$(cd "${tmp_dir}" && dpkg-shlibdeps -O "${PKG_ROOT}/usr/bin/bettertty" 2>/dev/null || true)"
        rm -rf "${tmp_dir}"
        if [[ "${deps_output}" == shlibs:Depends=* ]]; then
            local deps="${deps_output#shlibs:Depends=}"
            if [[ -n "${deps}" ]]; then
                echo "${deps}"
                return 0
            fi
        fi
    fi

    echo "${fallback_depends}"
}

DEPENDS="$(detect_depends)"
INSTALLED_SIZE="$(du -ks "${PKG_ROOT}" | awk '{print $1}')"

cat > "${PKG_ROOT}/DEBIAN/control" <<EOF
Package: ${PACKAGE_NAME}
Version: ${DEB_VERSION}
Section: net
Priority: optional
Architecture: ${ARCH}
Maintainer: Dalibor Klobučarić <info@dd-lab.net>
Installed-Size: ${INSTALLED_SIZE}
Depends: ${DEPENDS}
Homepage: https://bettertty.dev
Description: Clean cross-platform SSH and SFTP client
 BetterTTY is a Qt/C++/libssh SSH and SFTP client with saved sessions,
 BetterTTY.json configuration, known-host verification, password/private-key
 authentication, xterm.js terminal tabs, and a two-panel file manager.
EOF

for script_name in postinst postrm; do
    if [[ -f "${PROJECT_ROOT}/packaging/linux/debian/${script_name}" ]]; then
        cp "${PROJECT_ROOT}/packaging/linux/debian/${script_name}" "${PKG_ROOT}/DEBIAN/${script_name}"
        chmod 0755 "${PKG_ROOT}/DEBIAN/${script_name}"
    fi
done

# Ensure executable bits survived staging.
chmod 0755 "${PKG_ROOT}/usr/bin/bettertty"

mkdir -p "${OUT_DIR}"

echo "[BetterTTY] Building ${DEB_FILE}..."
dpkg-deb --build --root-owner-group "${PKG_ROOT}" "${DEB_FILE}"

echo "[BetterTTY] Debian package ready: ${DEB_FILE}"
echo "[BetterTTY] Inspect: dpkg-deb -I ${DEB_FILE}"
echo "[BetterTTY] Install: sudo apt install ./${DEB_FILE#${PROJECT_ROOT}/}"
