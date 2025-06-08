#!/bin/bash

echo "=== ~/.ssh と ~/.gitconfig を .devcontainer/git に相対パスでコピーします ==="

# このスクリプト自身のディレクトリを取得
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# コピー先ディレクトリ（相対指定）
DEST_SSH_DIR="$SCRIPT_DIR/../../git/.ssh"
DEST_GITCONFIG="$SCRIPT_DIR/../../git/.gitconfig"

# .ssh コピー処理
mkdir -p "$DEST_SSH_DIR"
cp -a ~/.ssh/* "$DEST_SSH_DIR/"
echo "✅ コピー完了: ~/.ssh → $DEST_SSH_DIR"

# .gitconfig コピー処理
if [ -f ~/.gitconfig ]; then
  cp ~/.gitconfig "$DEST_GITCONFIG"
  echo "✅ コピー完了: ~/.gitconfig → $DEST_GITCONFIG"
else
  echo "⚠ ~/.gitconfig が見つかりません。スキップします。"
fi
