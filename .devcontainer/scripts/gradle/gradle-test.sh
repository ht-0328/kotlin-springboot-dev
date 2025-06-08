#!/bin/bash

# gradlew のあるプロジェクトへ移動（スクリプトの場所から相対）
cd "$(dirname "$0")/../../../projects/kotlin-spring-boot-app" || exit

# オプション一覧とその説明
OPTIONS=(
  "通常テスト実行（オプションなし）"
  "詳細ログを出力する（--info）"
  "デバッグログを出力する（--debug）"
  "エラー時にスタックトレースを表示（--stacktrace）"
  "dry-run（実行せず処理内容だけ表示）"
  "選択を終了"
)

# 対応する Gradle オプション
GRADLE_OPTIONS=(
  ""
  "--info"
  "--debug"
  "--stacktrace"
  "--dry-run"
  "exit"
)

SELECTED_OPTIONS=()

echo "Gradle test に追加したいオプションを選んでください（複数選択可能）"
echo "番号を順に選び、最後に「選択を終了」を選んでください"

while true; do
  echo
  select opt in "${OPTIONS[@]}"; do
    idx=$((REPLY-1))
    if [[ "${GRADLE_OPTIONS[$idx]}" == "exit" ]]; then
      break 2
    elif [[ -n "${GRADLE_OPTIONS[$idx]}" || "${GRADLE_OPTIONS[$idx]}" == "" ]]; then
      if [[ -z "${GRADLE_OPTIONS[$idx]}" ]]; then
        echo "✅ 通常のテストを選びました（他のオプションは無視されます）"
        SELECTED_OPTIONS=()
        break 2
      else
        SELECTED_OPTIONS+=("${GRADLE_OPTIONS[$idx]}")
        echo "✅ 追加: ${GRADLE_OPTIONS[$idx]}"
        break
      fi
    else
      echo "❌ 無効な選択です。"
    fi
  done
done

echo
echo "🧪 実行するコマンド:"
echo "./gradlew test ${SELECTED_OPTIONS[*]}"
echo

./gradlew test "${SELECTED_OPTIONS[@]}"
