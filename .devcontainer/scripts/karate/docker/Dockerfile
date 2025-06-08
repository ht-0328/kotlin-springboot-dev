# ベースイメージ：軽量なJDK 17
FROM openjdk:17-slim

# プロンプトの抑制（APT使用時に必要）
ENV DEBIAN_FRONTEND=noninteractive

# 必要なツールのみをインストール
RUN set -eux && \
    apt-get update && \
    apt-get install -y \
    curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

###### Karate CLIのダウンロード・インストール ######

# Karate JARのバージョン: https://github.com/karatelabs/karate/releases
ARG KARATE_VERSION=1.5.1

# Karate JARのダウンロードURL
ARG KARATE_JAR_URL=https://github.com/karatelabs/karate/releases/download/v${KARATE_VERSION}/karate-${KARATE_VERSION}.jar

# Karate JARの配置
RUN set -eux && \
    mkdir -p /opt/karate && \
    curl -L -o /opt/karate/karate.jar ${KARATE_JAR_URL}

# 環境変数設定
ENV KARATE_HOME=/opt/karate
ENV PATH="${KARATE_HOME}:${PATH}"