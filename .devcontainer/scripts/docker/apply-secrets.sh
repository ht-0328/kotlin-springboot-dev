#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SECRETS_FILE_REL="../../.secrets.env"
SECRETS_FILE="$(realpath "$SCRIPT_DIR/$SECRETS_FILE_REL")"
BASHRC_FILE="$HOME/.bashrc"
SOURCE_LINE="source \"$SECRETS_FILE\""

if [ ! -f "$SECRETS_FILE" ]; then
  echo "⚠️ .secrets.env が見つかりません。環境変数の登録はスキップされます。"
  exec /bin/bash -l
fi

echo "✅ .secrets.env が見つかりました。.bashrc に登録します。"

if ! grep -Fxq "$SOURCE_LINE" "$BASHRC_FILE"; then
  echo "" >> "$BASHRC_FILE"
  echo "# .secrets.env を自動読み込み" >> "$BASHRC_FILE"
  echo "$SOURCE_LINE" >> "$BASHRC_FILE"
  echo "✅ .bashrc に source 行を追加しました。"
else
  echo "ℹ️ .bashrc には既に source 行があります。"
fi

# export付きで即時適用
while IFS='=' read -r key value; do
  [[ "$key" =~ ^#.*$ || -z "$key" ]] && continue
  key=$(echo "$key" | xargs)
  value=$(echo "$value" | sed -e 's/^"//' -e 's/"$//' | xargs)
  export "$key"="$value"
  echo "✅ $key を即時適用しました"
done < "$SECRETS_FILE"

# ログインシェルを起動（.bashrc が読み込まれる）
exec /bin/bash -l
