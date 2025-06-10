plugins {
    // Spring Boot のプラグイン（アプリの起動や JAR の作成を簡単にする）
    id("org.springframework.boot") version "3.4.3"
    // Spring Boot の依存関係を一括管理するプラグイン
    id("io.spring.dependency-management") version "1.1.4"
    // コードフォーマットやスタイルを整えるためのプラグイン: https://github.com/diffplug/spotless/releases
    id("com.diffplug.spotless") version "6.25.0"
    // Kotlin を JVM で動作させるためのプラグイン
    kotlin("jvm") version "2.1.10"
    // Spring Boot を Kotlin で使う際の最適化プラグイン（`open` 不要など）
    kotlin("plugin.spring") version "2.1.10"
    // CLI アプリケーションを作成するためのプラグイン
    application
}

repositories {
    // ライブラリを取得するリポジトリとして Maven Central を使用
    mavenCentral()
}

dependencies {
    // Spring Boot の基本スターター（Spring Boot を使うための必須ライブラリ）
    implementation("org.springframework.boot:spring-boot-starter:3.4.3")
    // HTTP リクエストのルーティングや REST API を実装するためのライブラリ
    implementation("org.springframework.boot:spring-boot-starter-web:3.4.3")
    // Kotlin の JUnit 5 統合テストライブラリ
    testImplementation("org.junit.jupiter:junit-jupiter-api:5.11.1")
    // Spring Boot のテスト用ライブラリ（これが必要！）
    testImplementation("org.springframework.boot:spring-boot-starter-test:3.4.3")
    // JUnit 5 のエンジン（JUnit 5 のテストを実行するために必要）
    testImplementation("org.junit.jupiter:junit-jupiter-engine:5.11.1")
    // MockKのライブラリ: https://github.com/mockk/mockk/releases
    testImplementation("io.mockk:mockk:1.14.0")
    // JUnit 5 のランチャー（テストフレームワークを動作させるために必要）
    testRuntimeOnly("org.junit.platform:junit-platform-launcher:1.11.0")
}

// Java 17 の環境を指定（バージョンを統一するため）
java {
    toolchain {
        languageVersion.set(JavaLanguageVersion.of(17))
    }
}

application {
    // Spring Boot のエントリーポイントとなるクラスを指定
    mainClass.set("com.app.AppKt")
}

// JUnit 5 を使うようにテスト設定
tasks.named<Test>("test") {
    useJUnitPlatform()
}

spotless {
    kotlin {
        // https://pinterest.github.io/ktlint/latest/
        ktlint("1.6.0") 
        
        target("src/**/*.kt")
    }
}