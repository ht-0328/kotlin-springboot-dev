#!/bin/bash

echo "=== WireMock スタブ一覧取得スクリプト ==="

# --- 実行処理 ---
echo "📋 WireMock に登録されているスタブ一覧を取得しています..."
curl -s http://wiremock:8080/__admin/mappings | jq .

echo "✅ 取得完了"
