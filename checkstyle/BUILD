load("@rules_java//java:defs.bzl", "java_binary")

java_binary(
    name = "checkstyle",
    main_class = "com.puppycrawl.tools.checkstyle.Main",
    visibility = ["//visibility:public"],
    runtime_deps = ["@rules_checkstyle_toolchains//:com_puppycrawl_tools_checkstyle"],
)
