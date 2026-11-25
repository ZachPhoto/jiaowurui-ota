#!/bin/bash
set -e

REPO="ZachPhoto/jiaowurui-ota"
APP_DST="/Applications/教务睿.app"
ALT_DST="$HOME/Applications/教务睿.app"
TMP_TGZ="/tmp/jwr_mac_$$.tar.gz"

echo "=================================================="
echo "  教务睿 Mac 独立版 — 一键免拦截全自动安装"
echo "=================================================="

URLS=(
  "https://ghfast.top/https://github.com/$REPO/releases/download/mac-base/jiaowurui-mac.tar.gz"
  "https://gh-proxy.com/https://github.com/$REPO/releases/download/mac-base/jiaowurui-mac.tar.gz"
  "https://github.com/$REPO/releases/download/mac-base/jiaowurui-mac.tar.gz"
)

DOWNLOADED=0
echo "1/4 正在高速下载教务睿安装包..."
for U in "${URLS[@]}"; do
  if curl -fL --connect-timeout 10 --max-time 180 --progress-bar "$U" -o "$TMP_TGZ" 2>/dev/null; then
    if tar -tzf "$TMP_TGZ" >/dev/null 2>&1; then
      DOWNLOADED=1
      break
    fi
  fi
done

if [ "$DOWNLOADED" -ne 1 ]; then
  echo "下载失败，请检查网络连接后重试。"
  rm -f "$TMP_TGZ"
  exit 1
fi

echo "2/4 正在安装到应用程序目录..."
TARGET="$APP_DST"
if ! mkdir -p "/Applications" >/dev/null 2>&1 || [ ! -w "/Applications" ]; then
  TARGET="$ALT_DST"
  mkdir -p "$HOME/Applications"
fi

rm -rf "$TARGET" >/dev/null 2>&1 || true
tar -xzf "$TMP_TGZ" -C "$(dirname "$TARGET")"
rm -f "$TMP_TGZ"
xattr -cr "$TARGET" >/dev/null 2>&1 || true

echo "3/4 正在准备运行环境并后台检测最新 OTA 版本..."
"$TARGET/Contents/MacOS/launcher"

echo "4/4 安装完成！"
echo "以后只需从「应用程序」或底部程序坞打开「教务睿」，所有更新将在后台自动静默完成。"
