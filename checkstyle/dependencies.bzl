load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

def rules_checkstyle_dependencies():
    """Fetches `checkstyle_java` dependencies.

    Declares dependencies of the `checkstyle_java` workspace.
    Call this macro in WORKSPACE.
    """

    # Java
    RULES_JAVA_VERSION = "4.0.0"
    RULES_JAVA_SHA = "34b41ec683e67253043ab1a3d1e8b7c61e4e8edefbcad485381328c934d072fe"

    maybe(
        repo_rule = http_archive,
        name = "rules_java",
        url = "https://github.com/bazelbuild/rules_java/releases/download/{v}/rules_java-{v}.tar.gz".format(v = RULES_JAVA_VERSION),
        sha256 = RULES_JAVA_SHA,
    )

    # JVM External
    RULES_JVM_EXTERNAL_TAG = "4.0"
    RULES_JVM_EXTERNAL_SHA = "31701ad93dbfe544d597dbe62c9a1fdd76d81d8a9150c2bf1ecf928ecdf97169"

    maybe(
        repo_rule = http_archive,
        name = "rules_jvm_external",
        strip_prefix = "rules_jvm_external-%s" % RULES_JVM_EXTERNAL_TAG,
        sha256 = RULES_JVM_EXTERNAL_SHA,
        url = "https://github.com/bazelbuild/rules_jvm_external/archive/%s.zip" % RULES_JVM_EXTERNAL_TAG,
    )
