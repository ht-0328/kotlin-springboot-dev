#!/bin/bash

# プロジェクトルートへ移動
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$SCRIPT_DIR/../../../projects/kotlin-spring-boot-app"
cd "$PROJECT_ROOT" || exit 1

# ユーザーにパッケージ名を対話的に入力させる
read -p "📦 パッケージ名を入力してください（例: com.example.hello）: " PACKAGE_NAME

# 入力チェック
if [[ -z "$PACKAGE_NAME" ]]; then
  echo "❌ パッケージ名が未入力です。処理を中止します。"
  exit 1
fi

# Gradle に正しいプロパティ名で渡す（pkgName）
./gradlew generateApiYaml -PpkgName="$PACKAGE_NAME" --no-configuration-cache
