#!/bin/bash

echo "=== Karate テスト実行スクリプト ==="

# Docker イメージ名を明示
IMAGE_NAME="karate"

# スクリプトの絶対パスを元にプロジェクトルートを取得
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$SCRIPT_DIR/../../.."

# Karate ディレクトリ構成
KARATE_DIR_REL=".devcontainer/karate"
KARATE_DIR_ABS="$PROJECT_ROOT/$KARATE_DIR_REL"

# Dockerfile のパス
DOCKERFILE_PATH="$PROJECT_ROOT/.devcontainer/scripts/karate/docker"

# 実行用プロファイル選択
PROFILES=("dev" "wiremock" "quit")
echo "🌐 実行するプロファイルを選択してください："
select PROFILE in "${PROFILES[@]}"; do
  if [ "$PROFILE" == "quit" ]; then
    echo "🚪 キャンセルしました。"
    exit 0
  elif [[ " ${PROFILES[*]} " == *" $PROFILE "* ]]; then
    break
  else
    echo "❌ 無効な選択です。"
  fi
done

# Feature ファイル名の入力
read -p "📄 実行する Feature ファイル名（例: hello.feature）: " FEATURE_FILE
if [ -z "$FEATURE_FILE" ]; then
  echo "❌ 入力されていません。"
  exit 1
fi

# Karate 実行結果出力ディレクトリ
RESULT_DIR="$KARATE_DIR_ABS/result"
mkdir -p "$RESULT_DIR"

# Karate Docker イメージが無ければビルド
if ! docker image inspect "$IMAGE_NAME" > /dev/null 2>&1; then
  echo "📦 Karate Docker イメージが見つかりません。ビルドします..."
  docker build -t "$IMAGE_NAME" "$DOCKERFILE_PATH"
fi

# Docker で Karate テスト実行（karate-config.js を読み込むために -w /karate に変更）
echo "🚀 Karate テストを Docker で実行します..."
docker run --rm \
  --network dev.internal \
  -v "$KARATE_DIR_ABS":/karate \
  -w /karate \
  "$IMAGE_NAME" \
  java \
    -Dkarate.env="$PROFILE" \
    -Dkarate.output.dir=/karate/result \
    -jar /opt/karate/karate.jar "feature/$FEATURE_FILE"
