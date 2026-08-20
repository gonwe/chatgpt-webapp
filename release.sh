#!/usr/bin/env bash
# __APP_NAME__ 打包发布辅助 — 由 tauri-aur-scaffold 生成
#
# 用法: ./release.sh <github-user> <github-repo>
# 前提: 已构建二进制 (cargo tauri build)，且已安装 gh CLI 并登录

set -euo pipefail

if [[ $# -lt 2 ]]; then
    echo "用法: $0 <github-user> <github-repo>"
    echo "示例: $0 gonwe doubao-desktop"
    exit 1
fi

GH_USER="$1"
GH_REPO="$2"
GH=${GH:-gh}

PKGNAME="chatgpt-webapp-desktop-bin"
BINNAME="chatgpt-webapp-desktop"
VERSION="0.1.0"

# 1. 定位二进制
BIN="src-tauri/target/release/${BINNAME}.bin"
if [[ ! -f "$BIN" ]]; then
    BIN="src-tauri/target/release/$(grep '^name' src-tauri/Cargo.toml | head -1 | cut -d'"' -f2)"
fi
echo "==> 二进制: $BIN ($(du -h "$BIN" | cut -f1))"

# 2. 打包 tar.gz（二进制 + 启动脚本 + 多尺寸图标）
PKG_DIR="${PKGNAME}-${VERSION}-x86_64"
rm -rf "$PKG_DIR" "${PKG_DIR}.tar.gz"
mkdir -p "$PKG_DIR"

cp "$BIN" "$PKG_DIR/${BINNAME}.bin"
cp "${BINNAME}.sh" "$PKG_DIR/${BINNAME}" 2>/dev/null || cp doubao-desktop.sh "$PKG_DIR/${BINNAME}"
chmod +x "$PKG_DIR/${BINNAME}" "$PKG_DIR/${BINNAME}.bin"

# 图标（release-icons/ 目录优先）
if [[ -d release-icons ]]; then
    cp -r release-icons/* "$PKG_DIR/"
else
    # 从 src-tauri/icons 生成 48/64/128/256
    python3 - "$PKG_DIR" "$BINNAME" << 'PYEOF'
import os, sys
from PIL import Image
out, binname = sys.argv[1], sys.argv[2]
src = 'src-tauri/icons/128x128.png'
img = Image.open(src)
for size in (48, 64, 128, 256):
    d = f'{out}/{size}x{size}'
    os.makedirs(d, exist_ok=True)
    img.resize((size, size), Image.LANCZOS).save(f'{d}/{binname}.png')
PYEOF
fi

tar czf "${PKG_DIR}.tar.gz" "$PKG_DIR"
SHA=$(sha256sum "${PKG_DIR}.tar.gz" | cut -d' ' -f1)
echo "==> 打包: ${PKG_DIR}.tar.gz ($(du -h ${PKG_DIR}.tar.gz | cut -f1))"
echo "    sha256: $SHA"

# 3. 更新 PKGBUILD 的 sha256（占位 SKIP -> 实际值）
# 注意: 生产 PKGBUILD 里第一行 sha256sums 是 tar.gz 的
if grep -q "SKIP" PKGBUILD 2>/dev/null; then
    python3 - "$SHA" << 'PYEOF'
import sys
sha = sys.argv[1]
p = 'PKGBUILD'
s = open(p).read()
lines = s.split('\n')
for i, line in enumerate(lines):
    if line.startswith("sha256sums=('SKIP'"):
        lines[i] = line.replace("'SKIP'", f"'{sha}'")
        break
open(p, 'w').write('\n'.join(lines))
print("    PKGBUILD sha256 已更新")
PYEOF
fi

# 4. 提交源码 + 创建 GitHub Release
git add -A 2>/dev/null || true
git commit -m "v${VERSION}: ${BINNAME} release" 2>/dev/null || true
git push origin main 2>/dev/null || git push 2>/dev/null || true

if command -v "$GH" >/dev/null 2>&1; then
    "$GH" release create "v${VERSION}" --repo "${GH_USER}/${GH_REPO}" \
        --title "v${VERSION}" --notes "v${VERSION} release" \
        "${PKG_DIR}.tar.gz" || echo "!! Release 创建失败（可能已存在，先删旧 tag）"
fi

echo ""
echo "==> 完成！"
echo "    下一版更新: 编辑 PKGBUILD pkgver + version，重新跑 cargo tauri build && ./release.sh"
