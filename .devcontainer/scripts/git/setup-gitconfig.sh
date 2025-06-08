#!/bin/bash

echo "=== Git のユーザー情報を設定します（~/.gitconfig） ==="

# --- ユーザー入力を促す（入力例つき） ---
read -p "📛 Git のユーザー名を入力してください（例: 山田太郎）: " GIT_USERNAME
read -p "📧 Git のメールアドレスを入力してください（例: your.email@example.com）: " GIT_EMAIL
read -p "🌐 GitHubのデフォルトURLはSSHにしますか？（yes/no、例: yes）: " USE_SSH

# --- 設定を反映 ---
git config --global user.name "$GIT_USERNAME"
git config --global user.email "$GIT_EMAIL"

# --- GitHub のURLをHTTPS→SSHに書き換える設定（任意） ---
if [[ "$USE_SSH" == "yes" || "$USE_SSH" == "y" ]]; then
  git config --global url."git@github.com:".insteadOf "https://github.com/"
  echo "🔁 https://github.com/ → git@github.com: に置き換える設定を追加しました。"
fi

# --- 結果表示 ---
echo "✅ 完了: 以下の内容を ~/.gitconfig に設定しました。"
git config --global --list
