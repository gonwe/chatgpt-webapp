#!/bin/sh
# __APP_NAME__ 桌面封装启动脚本 — 由 tauri-aur-scaffold 生成

# Fix Wayland protocol error on some compositors
# (GBM buffer creation failure with certain GPU/driver combos)
if [ -z "$GDK_BACKEND" ] && [ "$XDG_SESSION_TYPE" = "wayland" ]; then
    export WEBKIT_DISABLE_COMPOSITING_MODE=1
fi

# Improve CJK font rendering in WebKitGTK
export FREETYPE_PROPERTIES="truetype:interpreter-version=35"
export WEBKIT_FORCE_FONT_CONFIG=1

exec /usr/bin/chatgpt-webapp-desktop.bin "$@"
