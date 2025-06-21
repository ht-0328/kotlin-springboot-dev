package helper.openapi

import org.gradle.api.GradleException
import org.gradle.api.Project
import org.gradle.api.tasks.TaskProvider
import org.openapitools.generator.gradle.plugin.tasks.GenerateTask

/**
 * OpenAPI Generator プラグインをプロジェクトに適用します。
 *
 * build.gradle.kts で `openApiGeneratorSetup()` を呼び出すことで、
 * `org.openapi.generator` プラグインを適用できます。
 */
fun Project.openApiGeneratorSetup() {
    plugins.apply("org.openapi.generator")
}

/**
 * `-PpkgName=com.example.xxx` のように指定されたパッケージ名から、OpenAPI 定義ファイルのパスを取得します。
 *
 * @return パッケージ名と OpenAPI YAML ファイルのパスのペア
 * @throws GradleException パッケージ名が未指定、またはYAMLファイルが存在しない場合
 */
fun Project.resolvePackageAndSpec(): Pair<String, String> {
    val inputPackage =
        findProperty("pkgName")?.toString()?.ifBlank { null }
            ?: throw GradleException("❌ パッケージ名が未指定です。-PpkgName=com.example.xxx の形式で指定してください")

    val sanitizedPackage = inputPackage.replace('/', '.').replace("..", ".")
    val resourcePath = sanitizedPackage.replace('.', '/') + "/api.yaml"
    val specPath = "${this.projectDir}/src/main/resources/$resourcePath"

    if (!this.file(specPath).exists()) {
        throw GradleException("❌ YAMLファイルが見つかりません: $specPath")
    }

    println("✅ 定義ファイル: $specPath")
    println("✅ パッケージ名: $sanitizedPackage")

    return Pair(sanitizedPackage, specPath)
}

/**
 * パッケージ名のみ取得します。
 */
fun Project.resolvePackage(): String =
    findProperty("pkgName")
        ?.toString()
        ?.ifBlank { null }
        ?.replace('/', '.')
        ?.replace("..", ".")
        ?: throw GradleException("❌ パッケージ名が未指定です。-PpkgName=com.example.xxx の形式で指定してください")

/**
 * YAMLファイルのフルパスを返します（存在チェックなし）。
 */
fun Project.buildSpecPath(pkg: String): String {
    val path = pkg.replace('.', '/') + "/api.yaml"
    return "${this.projectDir}/src/main/resources/$path"
}

/**
 * OpenAPI Generator のタスク `openApiGenerate` に対して設定を行います。
 *
 * `resolvePackageAndSpec()` で取得したパッケージ名と YAML ファイルパスをもとに、
 * APIコントローラ・DTOクラスの出力先を指定します。
 *
 * @param pkg 出力用のベースパッケージ名（例: com.example.user）
 * @param specPath OpenAPI定義ファイル（api.yaml）のファイルパス
 */
fun Project.configureOpenApiGenerateTask(
    pkg: String,
    specPath: String,
): TaskProvider<GenerateTask> =
    tasks.named("openApiGenerate", GenerateTask::class.java) {
        generatorName.set("kotlin-spring")
        inputSpec.set(specPath)
        outputDir.set("${project.projectDir}")
        apiPackage.set("$pkg.controller")
        modelPackage.set("$pkg.dto")
        configOptions.set(
            mapOf(
                "useSpringBoot3" to "true",
                "interfaceOnly" to "true",
            ),
        )
        globalProperties.set(
            mapOf(
                "apis" to "",
                "models" to "",
            ),
        )
    }

/**
 * 指定されたプロパティからパッケージを取得し、そのパスに OpenAPI 雛形ファイルを生成する Gradle タスクを登録します。
 *
 * 注意：`templatePath` は rootProject を起点とした相対パスとして扱われます。
 *
 * @param templatePath 雛形として利用するテンプレートファイルのパス（デフォルト: buildSrc/templates/api-template.yaml）
 *
 * 例えばこのタスクを実行すると：
 * -PpkgName=com.example.user を指定した場合、
 * プロジェクトの `src/main/resources/com/example/user/api.yaml` にファイルが生成されます。
 */
fun Project.generateApiYamlTask(templatePath: String = "buildSrc/templates/api-template.yaml") {
    tasks.register("generateApiYaml") {
        group = "openapi"
        description = "指定したパッケージ配下に OpenAPI 雛形 api.yaml を作成（-PpkgName=... 形式）"

        doLast {
            val inputPackage = resolvePackage()
            val relativePath = inputPackage.replace('.', '/')
            val resourceDir = file("src/main/resources/$relativePath")
            val yamlFile = resourceDir.resolve("api.yaml")

            if (yamlFile.exists()) {
                println("⚠️ 既に存在します: ${yamlFile.path}")
                return@doLast
            }

            resourceDir.mkdirs()

            val templateFile = rootProject.file(templatePath)
            if (!templateFile.exists()) {
                throw GradleException("テンプレートファイルが存在しません: ${templateFile.path}")
            }

            yamlFile.writeText(templateFile.readText())
            println("✅ 雛形ファイルを作成しました: ${yamlFile.path}")
        }
    }
}

/**
 * `generateOpenApi` タスクを登録する。事前に `openApiGenerate` を設定し、依存として登録する。
 */
fun Project.registerOpenApiGenerateTask() {
    // Gradleの全タスクのうち、generateOpenApiを実行する場合だけ処理を進める
    if (gradle.startParameter.taskNames.any { it.contains("generateOpenApi") }) {
        val pkg = resolvePackage()
        val specPath = buildSpecPath(pkg)
        configureOpenApiGenerateTask(pkg, specPath)

        tasks.register("generateOpenApi") {
            group = "openapi"
            description = "OpenAPI 定義に基づきコードを生成する（-PpkgName=... 形式）"
            dependsOn("openApiGenerate")
        }
    }
}
