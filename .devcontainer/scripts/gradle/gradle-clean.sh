#!/bin/bash

# スクリプトが置かれているディレクトリの絶対パスを取得
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$SCRIPT_DIR/../../../projects/kotlin-spring-boot-app"

# プロジェクトディレクトリの存在確認
if [ ! -d "$PROJECT_ROOT" ]; then
  echo "❌ プロジェクトディレクトリが存在しません: $PROJECT_ROOT"
  exit 1
fi

# プロジェクトルートに移動
cd "$PROJECT_ROOT" || exit 1

# Gradleのcleanを実行
./gradlew clean
