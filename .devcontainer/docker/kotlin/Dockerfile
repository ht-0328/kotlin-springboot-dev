# ベースイメージ: Eclipse Temurin（Adoptium）JDK 17 + Ubuntu Jammy
# 公式リリース: https://hub.docker.com/_/eclipse-temurin
FROM eclipse-temurin:17.0.13_11-jdk-jammy

# パッケージのインストール時に対話的なプロンプトが表示されないように設定する
ENV DEBIAN_FRONTEND=noninteractive

# タイムゾーン・ロケール設定
ENV TZ=Asia/Tokyo
ENV LANG=C.UTF-8

# 必要なパッケージのインストール
RUN set -eux && \
    apt-get update && \
    apt-get install -y \
    # bashコマンド補完
    bash-completion \
    # treeコマンド
    tree \
    # URLからデータを転送するためのツール
    curl \
    # ファイル取得のための代替ツール
    wget \
    # バージョン管理システム
    git \
    # テキストエディタ  
    vim \
    # JSON整形ツール
    jq \
    # 圧縮・解凍ツール
    zip \
    unzip \
    tar \
    gzip \
    # 最小限のビルドツール（Javaビルドに必要）
    build-essential \
    # PostgreSQLクライアント(psql)
    postgresql-client \
    # ターミナル操作補助
    less \
    # タイムゾーン設定用パッケージ
    tzdata && \
    # タイムゾーンを日本（東京）に設定
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone && \
    # APTキャッシュのクリーンアップ
    apt-get clean && \
    # APTリポジトリのメタデータを削除してディスクスペースを節約
    rm -rf /var/lib/apt/lists/*

###### Kotlinコンパイラのダウンロードとインストール ######

# Kotlinコンパイラのバージョン
ARG KOTLIN_VERSION=2.1.10

# Kotlinコンパイラのダウンロード先URL: https://github.com/JetBrains/kotlin/releases
ARG BASE_URL_KOTLIN=https://github.com/JetBrains/kotlin/releases/download/

# 環境変数の設定
ENV KOTLIN_HOME=/opt/kotlin/kotlin-compiler-${KOTLIN_VERSION}
ENV PATH="${KOTLIN_HOME}/bin:${PATH}"

# Kotlinのダウンロードと展開
RUN set -eux && \
    # Kotlinコンパイラを指定されたURLからダウンロードし、一時ディレクトリに保存
    curl -L -o /tmp/kotlin-compiler.zip ${BASE_URL_KOTLIN}/v${KOTLIN_VERSION}/kotlin-compiler-${KOTLIN_VERSION}.zip && \
    # ダウンロードしたZIPファイルを解凍し、指定ディレクトリに展開
    unzip /tmp/kotlin-compiler.zip -d /opt/kotlin && \
    # 解凍後、一時ファイルを削除
    rm /tmp/kotlin-compiler.zip

###### Gradleのダウンロードとインストール ######

# Gradleのバージョン
ARG GRADLE_VERSION=8.13

# Gradleのダウンロード先URL: https://services.gradle.org/distributions/
ARG BASE_URL_GRADLE=https://services.gradle.org/distributions

# 環境変数の設定
ENV GRADLE_HOME=/opt/gradle/gradle-${GRADLE_VERSION}
ENV PATH="${GRADLE_HOME}/bin:${PATH}"

# Gradleのダウンロードと展開
RUN set -eux && \
    # Gradleを指定されたURLからダウンロードし、一時ディレクトリに保存
    curl -L -o /tmp/gradle.zip ${BASE_URL_GRADLE}/gradle-${GRADLE_VERSION}-bin.zip && \
    # ダウンロードしたZIPファイルを解凍し、指定ディレクトリに展開
    unzip /tmp/gradle.zip -d /opt/gradle && \
    # 解凍後、一時ファイルを削除
    rm /tmp/gradle.zip

# 作業ディレクトリの設定
WORKDIR /workspace

# VSCode DevContainer 用の環境変数
ENV DEVCONTAINER=true
