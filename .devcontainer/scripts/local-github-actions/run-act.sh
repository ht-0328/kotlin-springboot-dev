#!/bin/bash

set -e

# スクリプトの実行場所に依存せずプロジェクトルートへ移動
cd "$(dirname "$0")/../../../"

# act用のGitHub Actions互換イメージをPull（初回だけ必要）
docker pull catthehacker/ubuntu:act-latest

# .envが存在すれば読み込む（無くてもスキップ）
if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs)
fi

# act実行
act -P ubuntu-latest=catthehacker/ubuntu:act-latest --env-file .env
