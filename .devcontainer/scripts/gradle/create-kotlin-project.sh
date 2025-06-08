#!/bin/bash

echo "=== Kotlin + Gradle プロジェクト初期化スクリプト ==="

# --- 入力を受け取る ---
read -p "📦 プロジェクト名を入力してください（例: my-kotlin-app）: " PROJECT_NAME
read -p "📁 パッケージ名を入力してください（例: com.example）: " PACKAGE_NAME
read -p "🧪 使用する Java バージョンを入力してください（例: 17）: " JAVA_VERSION

# 入力チェック
if [ -z "$PROJECT_NAME" ] || [ -z "$PACKAGE_NAME" ] || [ -z "$JAVA_VERSION" ]; then
  echo "❌ プロジェクト名、パッケージ名、Javaバージョンはすべて必須です。"
  exit 1
fi

# --- プロジェクト作成先を定義 ---
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECTS_DIR="$SCRIPT_DIR/../../../projects"
DEST_DIR="$PROJECTS_DIR/$PROJECT_NAME"

# ディレクトリ作成と移動
mkdir -p "$DEST_DIR"
cd "$DEST_DIR" || exit 1

# --- Gradle 初期化 ---
echo "🛠️ Gradle プロジェクトを初期化中..."
gradle init \
  --type kotlin-application \
  --dsl kotlin \
  --project-name "$PROJECT_NAME" \
  --package "$PACKAGE_NAME" \
  --test-framework junit-jupiter \
  --java-version "$JAVA_VERSION" \
  --incubating

echo "✅ プロジェクトが作成されました: $DEST_DIR"

# --- 初期化後の案内 ---
echo
echo "📂 プロジェクト構成:"
tree -L 3 "$DEST_DIR" || ls -R "$DEST_DIR" | head

echo
echo "🚀 次のコマンドでビルドや実行ができます:"
echo "cd $DEST_DIR"
echo "./gradlew build"
echo "./gradlew run"
