#!/bin/bash

# スクリプトの場所からプロジェクトルート（kotlin-spring-boot-app）へ移動
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$SCRIPT_DIR/../../../projects/kotlin-spring-boot-app"

# ディレクトリが存在しない場合はエラー終了
if [ ! -d "$PROJECT_ROOT" ]; then
  echo "❌ プロジェクトディレクトリが存在しません: $PROJECT_ROOT"
  exit 1
fi

cd "$PROJECT_ROOT" || exit 1

# Spotless を実行
./gradlew spotlessApply
