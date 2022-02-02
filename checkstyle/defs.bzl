"""
Checkstlye rule source
"""

def _impl(ctx):
    outputs = []

    arguments = []
    arguments.append(ctx.executable._executable.short_path)

    if ctx.file.suppressions:
        arguments.append("--jvm_flag=-Dcheckstyle.suppressions.file=" + ctx.file.suppressions.path)

    if ctx.attr.runtime_deps:
        classpaths = ":".join([runtime_dep.short_path for runtime_dep in ctx.files.runtime_deps])
        arguments.append("--main_advice_classpath={}".format(classpaths))

    arguments.append("-f")
    arguments.append(ctx.attr.format)

    arguments.append("-c")
    arguments.append(ctx.file.config.path)

    if ctx.attr.debug:
        arguments.append("-d")

    arguments.extend([src.path for src in ctx.files.srcs])

    script_file = ctx.actions.declare_file(ctx.label.name)
    ctx.actions.write(
        output = script_file,
        content = " ".join(arguments),
        is_executable = True,
    )

    runfiles = ctx.runfiles(files = [script_file, ctx.executable._executable, ctx.file.config] + ctx.files.srcs + ctx.files.runtime_deps)
    runfiles = runfiles.merge_all([
        target[DefaultInfo].default_runfiles for target in (ctx.attr.srcs + [ctx.attr._executable, ctx.attr.config] + ctx.attr.runtime_deps)
    ])
    if ctx.file.suppressions:
        runfiles = runfiles.merge_all([
            ctx.runfiles(files = [ctx.file.suppressions]),
            ctx.attr.suppressions[DefaultInfo].default_runfiles,
        ])
    return [DefaultInfo(files = depset(outputs), runfiles = runfiles, executable = script_file)]

_report_extension = {
    "plain": "txt",
    "xml": "xml",
}

_checkstyle_test = rule(
    implementation = _impl,
    attrs = {
        "_executable": attr.label(
            default = "//checkstyle:checkstyle",
            executable = True,
            cfg = "host",
        ),
        "srcs": attr.label_list(allow_files = [".java"], allow_empty=False),
        "config": attr.label(
            allow_single_file = True,
            mandatory = True,
            doc = "Specifies the location of the file that defines the configuration modules. The location can either be a filesystem location, or a name passed to the ClassLoader.getResource() method.",
        ),
        "debug": attr.bool(
            doc = "Prints all debug logging of CheckStyle utility.",
        ),
        "format": attr.string(
            default = "plain",
            doc = "Specifies the output format. Valid values: xml, plain for XMLLogger and DefaultLogger respectively. Defaults to plain.",
            values = ["plain", "xml"],
        ),
        "suppressions": attr.label(
            allow_single_file=True,
        ),
        "runtime_deps": attr.label_list(
            providers = [JavaInfo],
            doc = "List of java_library that contain classes necessary for custom checks.",
        ),
    },
    test = True,
)

def checkstyle_test(name, srcs = [], **kwargs):
  _checkstyle_test(name=name, srcs=srcs, **kwargs)

checkstyle = rule(
    implementation = _impl,
    attrs = {
        "_executable": attr.label(
            default = "//checkstyle:checkstyle",
            executable = True,
            cfg = "host",
        ),
        "srcs": attr.label_list(allow_files = True),
        "config": attr.label(
            allow_single_file = True,
            mandatory = True,
            doc = "Specifies the location of the file that defines the configuration modules. The location can either be a filesystem location, or a name passed to the ClassLoader.getResource() method.",
        ),
        "debug": attr.bool(
            doc = "Prints all debug logging of CheckStyle utility.",
        ),
        "format": attr.string(
            default = "plain",
            doc = "Specifies the output format. Valid values: xml, plain for XMLLogger and DefaultLogger respectively. Defaults to plain.",
            values = ["plain", "xml"],
        ),
        "suppressions": attr.label(
            allow_single_file=True,
        ),
        "runtime_deps": attr.label_list(
            providers = [JavaInfo],
            doc = "List of java_library that contain classes necessary for custom checks.",
        ),
    },
    provides = [DefaultInfo],
)
