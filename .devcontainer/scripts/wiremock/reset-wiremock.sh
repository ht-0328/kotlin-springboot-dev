#!/bin/bash

echo "=== WireMock スタブリセットスクリプト ==="

# --- 実行処理 ---
echo "🧹 WireMock のスタブをリセットしています..."
curl -X POST http://wiremock:8080/__admin/reset

echo "✅ リセット完了"
