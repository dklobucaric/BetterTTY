#!/usr/bin/env python3
"""Static integrity checks for BetterTTY 1.0.2 source/release metadata.
Does NOT compile Qt or replace platform QA.
"""
from pathlib import Path
import re, sys
root = Path(__file__).resolve().parent.parent
cmake = (root / "CMakeLists.txt").read_text(encoding="utf-8")
version = re.search(r"(?m)^\s*VERSION\s+(\d+\.\d+\.\d+)\s*$", cmake)
assert version and version.group(1) == "1.0.2", "unexpected CMake version"
assert 'set(BETTERTTY_VERSION_STRING "${PROJECT_VERSION}")' in cmake
about = (root / "src/ui/MainWindow.cpp").read_text(encoding="utf-8")
assert 'Development build — not a verified release.' not in about
assert '"Previous Tab"' not in about
assert '"Next Tab"' in about
for file in ["README.md", "docs/RELEASE_NOTES_1.0.2.md", "docs/RELEASE_STATUS_1.0.2.md", "docs/BUILD_1.0.2.md"]:
    content = (root / file).read_text(encoding="utf-8")
    assert "1.0.2" in content, file
for script in ['scripts/linux-package-deb.sh','scripts/macos-deploy-release.sh','scripts/windows-package-portable.ps1']:
    t=(root/script).read_text(encoding="utf-8")
    assert 'VERSION' in t and '0.0.0' not in t, script
print("PASS: source version, metadata, package scripts, docs and shortcut assertions")
print("NOTE: Windows/Linux/macOS GUI and deployment are NOT tested by this script")
