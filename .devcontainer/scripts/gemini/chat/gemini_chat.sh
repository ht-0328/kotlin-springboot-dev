#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
HISTORY_FILE="${SCRIPT_DIR}/history.json"
PROMPT_FILE="${SCRIPT_DIR}/prompt.txt"
RESULT_DIR="${SCRIPT_DIR}/result"
mkdir -p "$RESULT_DIR"

API_KEY="${GEMINI_API_KEY}"
if [ -z "$API_KEY" ]; then
  echo "❌ 環境変数 GEMINI_API_KEY が設定されていません"
  exit 1
fi

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

if [ ! -s "$PROMPT_FILE" ]; then
  echo "❌ prompt.txt が空か存在しません"
  exit 1
fi
PROMPT_TEXT=$(<"$PROMPT_FILE")

# ✅ 履歴ファイルがなければ初期化
if [ ! -f "$HISTORY_FILE" ]; then
  echo '{ "contents": [] }' > "$HISTORY_FILE"
fi

# ✅ history に user の発言を追加
BASE_HISTORY=$(<"$HISTORY_FILE")
REQUEST_BODY=$(echo "$BASE_HISTORY" | jq --arg prompt "$PROMPT_TEXT" \
  '.contents += [{"role": "user", "parts": [{"text": $prompt}]}]')

# ✅ API 呼び出し
RESPONSE=$(curl -s -X POST \
  "https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent?key=${API_KEY}" \
  -H "Content-Type: application/json" \
  -d "$REQUEST_BODY")

echo "------ Gemini API レスポンス全文（DEBUG） ------"
echo "$RESPONSE" | jq

REPLY_TEXT=$(echo "$RESPONSE" | jq -r '.candidates[0].content.parts[0].text')

if [ "$REPLY_TEXT" = "null" ] || [ -z "$REPLY_TEXT" ]; then
  echo "❌ AIの返答が null です"
  exit 1
fi

# ✅ 結果保存
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
OUTPUT_FILE="${RESULT_DIR}/reply_${TIMESTAMP}.txt"
echo "$REPLY_TEXT" > "$OUTPUT_FILE"
echo "✅ AIの返答を ${OUTPUT_FILE} に保存しました"

# ✅ 履歴に model の発言を追加し、常に更新
FINAL_HISTORY=$(echo "$REQUEST_BODY" | jq --arg reply "$REPLY_TEXT" \
  '.contents += [{"role": "model", "parts": [{"text": $reply}]}]')
echo "$FINAL_HISTORY" > "$HISTORY_FILE"
echo "✅ 履歴（history.json）を更新しました"
