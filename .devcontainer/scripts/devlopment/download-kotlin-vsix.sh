#!/bin/bash

# スクリプト内でエラーが発生した場合、直ちにスクリプトを終了させる
set -e

# --- 設定 ---
# ダウンロードするKotlin LSP VSIXのURL
readonly URL="https://download-cdn.jetbrains.com/kotlin-lsp/0.252.17811/kotlin-0.252.17811.vsix"
# --- 設定ここまで ---


# --- パス設定 (相対パス) ---
# このスクリプトが置かれているディレクトリのパスを取得
readonly SCRIPT_DIR=$(dirname "$0")

# スクリプトの場所を基準に、保存先ディレクトリを相対的に指定
readonly DEST_DIR="$SCRIPT_DIR/vsix"
# --- パス設定ここまで ---


# URLからファイル名部分を抽出 (例: kotlin-0.252.17811.vsix)
readonly FILENAME=$(basename "$URL")

# 保存するファイルのフルパスを定義
readonly DEST_FILE="$DEST_DIR/$FILENAME"


# --- 処理開始 ---
echo "--- Kotlin VSIX Downloader (Relative Path) ---"

# 1. ファイルが既に存在するかチェック
if [ -f "$DEST_FILE" ]; then
    echo "✅ File already exists. Skipping download."
    echo "   Path: $DEST_FILE"
    exit 0
fi

# 2. 保存先ディレクトリの存在を確認し、なければ作成
echo "ℹ️  Ensuring destination directory exists: $DEST_DIR"
mkdir -p "$DEST_DIR"

# 3. curlでファイルをダウンロード
echo "🚀 Downloading $FILENAME..."
curl -LfsS -o "$DEST_FILE" "$URL"

echo "✅ Download complete!"
echo "   Saved to: $DEST_FILE"
echo "------------------------------------------"

exit 0