plugins {
    `kotlin-dsl`
    id("com.diffplug.spotless") version "6.25.0"
}

repositories {
    mavenCentral()
}

dependencies {
    // 👇 これを追加することで GenerateTask を使えるようにする
    implementation("org.openapitools:openapi-generator-gradle-plugin:7.13.0")
}

spotless {
    kotlin {
        ktlint("1.6.0")
        target("src/main/kotlin/**/*.kt")
    }
}