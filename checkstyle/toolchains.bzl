load("@rules_java//java:repositories.bzl", "rules_java_dependencies", "rules_java_toolchains")
load("@rules_jvm_external//:defs.bzl", "maven_install")
load("@rules_jvm_external//:specs.bzl", "maven")

def rules_checkstyle_toolchains(checkstyle_version = "8.39"):
    """Invokes `rules_checkstyle` toolchains.

    Declaress toolchains that are dependencies of the `rules_checkstyle` workspace.
    This should be called with WORKSPACE.

    Args:
        checkstyle_version: "com.puppycrawl.tools:checkstyle" version used by rules.
    """
    rules_java_dependencies()
    rules_java_toolchains()

    maven_install(
        name = "rules_checkstyle_toolchains",
        artifacts = [
            maven.artifact("com.puppycrawl.tools", "checkstyle", checkstyle_version),
        ],
        repositories = [
            "https://repo1.maven.org/maven2",
            "https://repo.maven.apache.org/maven2/",
        ],
    )

