#!/bin/bash

# プロジェクトルートへ移動
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$SCRIPT_DIR/../../../projects/kotlin-spring-boot-app"
cd "$PROJECT_ROOT" || exit 1

# パッケージ名の入力を促す
read -p "📦 OpenAPI YAML が存在するパッケージ名を入力してください（例: com.example.user）: " PACKAGE_NAME

# 入力チェック
if [[ -z "$PACKAGE_NAME" ]]; then
  echo "❌ パッケージ名が未入力です。処理を中止します。"
  exit 1
fi

echo "📄 OpenAPI 定義に基づきコードを生成します..."
./gradlew generateOpenApi -PpkgName="$PACKAGE_NAME" --no-configuration-cache
