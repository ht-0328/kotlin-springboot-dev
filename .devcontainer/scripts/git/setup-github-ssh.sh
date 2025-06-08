#!/bin/bash

echo "=== GitHub SSHキー作成 & 登録スクリプト ==="

# --- トークンファイルの相対パス指定 ---
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TOKEN_FILE="$SCRIPT_DIR/../../git/.github-token"

# --- トークン読み込み処理 ---
if [ ! -f "$TOKEN_FILE" ]; then
  echo "❌ Personal Access Token ファイルが見つかりません: $TOKEN_FILE"
  exit 1
fi

TOKEN=$(cat "$TOKEN_FILE")

read -p "📧 GitHubに登録しているメールアドレスを入力してください（例: your.email@example.com）: " EMAIL
read -p "👤 GitHubのユーザー名を入力してください（例: your-github-id）: " GITHUB_USERNAME
read -p "📝 このSSHキーのコメントを入力してください（例: my-dev-machine）: " KEY_COMMENT
read -p "💾 SSHキーの保存ファイル名を入力してください（例: id_rsa_github）: " KEY_NAME

# --- ファイルパス定義 ---
KEY_FILE="$HOME/.ssh/${KEY_NAME}"
CONFIG_FILE="$HOME/.ssh/config"
KNOWN_HOSTS_FILE="$HOME/.ssh/known_hosts"

# --- SSHキー生成 ---
echo "🛠️ SSHキーを作成中..."
mkdir -p "$HOME/.ssh"
ssh-keygen -t rsa -b 4096 -C "$EMAIL" -f "$KEY_FILE" -N ""

# --- SSHエージェントに登録 ---
eval "$(ssh-agent -s)"
ssh-add "$KEY_FILE"

# --- GitHubのフィンガープリントを known_hosts に追加 ---
echo "🔒 GitHubのフィンガープリントを known_hosts に追加中..."
ssh-keyscan github.com >> "$KNOWN_HOSTS_FILE" 2>/dev/null

# --- GitHub に公開鍵を登録 ---
PUB_KEY=$(cat "${KEY_FILE}.pub")
HOSTNAME=$(hostname)

echo "🌐 GitHubに公開鍵を登録中..."
RESPONSE=$(curl -s -w "%{http_code}" -o /tmp/gh_ssh_response.txt \
  -H "Authorization: token $TOKEN" \
  --data "{\"title\":\"${KEY_COMMENT}@${HOSTNAME}\",\"key\":\"$PUB_KEY\"}" \
  https://api.github.com/user/keys)

if [[ "$RESPONSE" == "201" ]]; then
  echo "✅ 鍵の登録に成功しました。"
else
  echo "❌ 鍵の登録に失敗しました。レスポンス:"
  cat /tmp/gh_ssh_response.txt
fi

# --- ~/.ssh/config に設定追加（なければ） ---
if ! grep -q "Host github.com" "$CONFIG_FILE" 2>/dev/null; then
  echo -e "\nHost github.com\n  HostName github.com\n  User git\n  IdentityFile $KEY_FILE\n" >> "$CONFIG_FILE"
  echo "🧷 ~/.ssh/config に設定を追加しました。"
else
  echo "ℹ️ ~/.ssh/config に既に 'Host github.com' の設定があります。追記はスキップしました。"
fi

echo "🎉 完了しました！"
