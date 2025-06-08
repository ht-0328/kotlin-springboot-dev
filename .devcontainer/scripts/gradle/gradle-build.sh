#!/bin/bash

cd "$(dirname "$0")/../../../projects/kotlin-spring-boot-app" || exit

# 説明付きのオプション一覧
OPTIONS=(
  "通常ビルド（オプションなし）"
  "詳細ログを出力する（--info）"
  "デバッグログを出力する（--debug）"
  "エラー時にスタックトレースを表示（--stacktrace）"
  "テストをスキップする（-x test）"
  "選択を終了"
)

# 実際のGradleオプションを保持
GRADLE_OPTIONS=(
  ""
  "--info"
  "--debug"
  "--stacktrace"
  "-x test"
  "-x integrationTest"
  "exit"
)

SELECTED_OPTIONS=()

echo "Gradle build に追加したいオプションを選んでください（複数選択可能）"
echo "番号を選び、最後に「選択を終了」を選んでください"

while true; do
  echo
  select opt in "${OPTIONS[@]}"; do
    idx=$((REPLY-1))
    if [[ "${GRADLE_OPTIONS[$idx]}" == "exit" ]]; then
      break 2
    elif [[ -n "${GRADLE_OPTIONS[$idx]}" || "${GRADLE_OPTIONS[$idx]}" == "" ]]; then
      if [[ -z "${GRADLE_OPTIONS[$idx]}" ]]; then
        echo "✅ 通常ビルドを選びました（他のオプションは無視されます）"
        SELECTED_OPTIONS=()  # 他のオプションをクリア
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
echo "🛠 実行するコマンド:"
echo "./gradlew build ${SELECTED_OPTIONS[*]}"
echo

./gradlew build "${SELECTED_OPTIONS[@]}"
