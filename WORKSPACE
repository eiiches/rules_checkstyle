workspace(name = "rules_checkstyle")

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

## Dependencies
load("//checkstyle:dependencies.bzl", "rules_checkstyle_dependencies")
rules_checkstyle_dependencies()

load("//checkstyle:toolchains.bzl", "rules_checkstyle_toolchains")
rules_checkstyle_toolchains()

## Skylib

skylib_version = "1.0.2"

skylib_sha = "97e70364e9249702246c0e9444bccdc4b847bed1eb03c5a3ece4f83dfe6abc44"
