#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd -- "${SCRIPT_DIR}/.." && pwd)"

BUILD_DIR="${BUILD_DIR:-${PROJECT_ROOT}/build-linux-release}"
BUILD_TYPE="${CMAKE_BUILD_TYPE:-Release}"
GENERATOR="${CMAKE_GENERATOR:-Ninja}"

cmake_args=(
    -S "${PROJECT_ROOT}"
    -B "${BUILD_DIR}"
    -DCMAKE_BUILD_TYPE="${BUILD_TYPE}"
)

if [[ -n "${CMAKE_PREFIX_PATH:-}" ]]; then
    cmake_args+=( -DCMAKE_PREFIX_PATH="${CMAKE_PREFIX_PATH}" )
fi

if [[ "${GENERATOR}" == "Ninja" ]]; then
    if command -v ninja >/dev/null 2>&1; then
        cmake_args=( -G "Ninja" "${cmake_args[@]}" )
    else
        echo "[BetterTTY] Ninja not found; falling back to CMake default generator."
    fi
else
    cmake_args=( -G "${GENERATOR}" "${cmake_args[@]}" )
fi

echo "[BetterTTY] Configuring Linux ${BUILD_TYPE} build..."
cmake "${cmake_args[@]}"

echo "[BetterTTY] Building..."
cmake --build "${BUILD_DIR}"

echo "[BetterTTY] Build complete: ${BUILD_DIR}/bettertty"
