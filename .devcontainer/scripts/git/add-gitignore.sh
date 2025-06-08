#!/bin/bash

echo "=== .gitignore にパスを追記するスクリプト ==="

# 相対パスで指定しつつ、絶対パスを取得して表示に使用
DEFAULT_REL_PATH="./.gitignore"
DEFAULT_ABS_PATH="$(realpath -m "$DEFAULT_REL_PATH")"

# 入力プロンプトで絶対パスを表示
read -p "📝 .gitignore のパスを入力してください（デフォルト: $DEFAULT_ABS_PATH）: " GITIGNORE_PATH
GITIGNORE_PATH=${GITIGNORE_PATH:-$DEFAULT_REL_PATH}
ABS_GITIGNORE_PATH="$(realpath -m "$GITIGNORE_PATH")"

# .gitignore が存在しなければ作成
if [ ! -f "$ABS_GITIGNORE_PATH" ]; then
  echo "⚠️ $ABS_GITIGNORE_PATH が存在しないため新しく作成します。"
  touch "$ABS_GITIGNORE_PATH"
fi

echo "📍 使用する .gitignore: $ABS_GITIGNORE_PATH"

# 無限ループで複数行追加
while true; do
  read -p "➕ 無視するパスを入力してください（終了したい場合は空でEnter）: " ENTRY

  if [ -z "$ENTRY" ]; then
    echo "🚪 終了します。"
    break
  fi

  if grep -Fxq "$ENTRY" "$ABS_GITIGNORE_PATH"; then
    echo "✅ すでに存在: $ENTRY"
  else
    echo "$ENTRY" >> "$ABS_GITIGNORE_PATH"
    echo "🔽 追加しました: $ENTRY"
  fi
done

echo "🎉 完了: $ABS_GITIGNORE_PATH を更新しました。"
