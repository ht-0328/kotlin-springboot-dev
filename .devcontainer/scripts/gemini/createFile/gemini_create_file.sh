#!/bin/bash

# スクリプトのディレクトリ
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# 履歴・プロンプトファイルの定義
HISTORY_FILE="${SCRIPT_DIR}/history.json"
PROMPT_FILE="${SCRIPT_DIR}/prompt.txt"

# ==============================
# 対話形式の入力
# ==============================

# 出力先ディレクトリ
read -p "📁 出力先ディレクトリを指定してください（例: ./result）: " RESULT_DIR
RESULT_DIR="${RESULT_DIR:-./result}"
mkdir -p "$RESULT_DIR"

# 出力ファイル名
read -p "📄 出力ファイル名を指定してください（拡張子なし、例: reply_001）: " FILE_NAME
OUTPUT_FILE="${RESULT_DIR}/${FILE_NAME}"

# モデル選択
echo "🌐 使用する Gemini モデルを選んでください:"
echo "1. gemini-pro"
echo "2. gemini-1.5-pro"
echo "3. gemini-1.5-flash"
read -p "番号を入力してください (1〜3): " MODEL_CHOICE
case "$MODEL_CHOICE" in
  1) MODEL="gemini-pro" ;;
  2) MODEL="gemini-1.5-pro" ;;
  3) MODEL="gemini-1.5-flash" ;;
  *) echo "❌ 無効な選択です"; exit 1 ;;
esac
echo "✅ モデル: $MODEL"

# 環境変数の確認
API_KEY="${GEMINI_API_KEY}"
if [ -z "$API_KEY" ]; then
  echo "❌ 環境変数 GEMINI_API_KEY が設定されていません"
  exit 1
fi

# プロンプト読み込み
if [ ! -s "$PROMPT_FILE" ]; then
  echo "❌ prompt.txt が空か存在しません"
  exit 1
fi
PROMPT_TEXT=$(<"$PROMPT_FILE")

# 履歴初期化
if [ ! -f "$HISTORY_FILE" ]; then
  echo '{ "contents": [] }' > "$HISTORY_FILE"
fi

# ユーザー発言を追加
BASE_HISTORY=$(<"$HISTORY_FILE")
REQUEST_BODY=$(echo "$BASE_HISTORY" | jq --arg prompt "$PROMPT_TEXT" \
  '.contents += [{"role": "user", "parts": [{"text": $prompt}]}]')

# API呼び出し
RESPONSE=$(curl -s -X POST \
  "https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent?key=${API_KEY}" \
  -H "Content-Type: application/json" \
  -d "$REQUEST_BODY")

# デバッグ表示
echo "------ Gemini API レスポンス全文（DEBUG） ------"
echo "$RESPONSE" | jq

# モデルの返答を取り出す
REPLY_TEXT=$(echo "$RESPONSE" | jq -r '.candidates[0].content.parts[0].text')

if [ "$REPLY_TEXT" = "null" ] || [ -z "$REPLY_TEXT" ]; then
  echo "❌ AIの返答が null です"
  exit 1
fi

# ✅ 結果保存
echo "$REPLY_TEXT" > "$OUTPUT_FILE"
echo "✅ AIの返答を ${OUTPUT_FILE} に保存しました"

# ✅ 履歴更新
FINAL_HISTORY=$(echo "$REQUEST_BODY" | jq --arg reply "$REPLY_TEXT" \
  '.contents += [{"role": "model", "parts": [{"text": $reply}]}]')
echo "$FINAL_HISTORY" > "$HISTORY_FILE"
echo "✅ 履歴（history.json）を更新しました"
