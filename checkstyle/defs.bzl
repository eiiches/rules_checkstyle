"""
Checkstlye rule source
"""

def _impl(ctx):
    name = ctx.label.name
    srcs = ctx.files.srcs

    #deps = ctx.files.deps
    #config = ctx.files.config
    #properties = ctx.file.properties
    #suppressions = ctx.file.suppressions
    #opts = ctx.attr.opts
    #sopts = ctx.attr.string_opts
    inputs = []
    outputs = []

    arguments = ctx.actions.args()

    arguments.add("-f", ctx.attr.format)

    report_file = ctx.actions.declare_file("{name}_checkstyle_report.{extension}".format(
        name = ctx.label.name,
        extension = _report_extension.get(ctx.attr.format),
    ))

    arguments.add("-o", report_file)
    outputs.append(report_file)

    arguments.add("-c", ctx.file.config.path)
    inputs.append(ctx.file.config)

    if ctx.attr.debug:
        arguments.add("-d")

    if len(ctx.files.srcs) != 0:
        arguments.add_all(ctx.files.srcs)
        inputs.extend(ctx.files.srcs)

    ctx.actions.run(
        mnemonic = "Checkstlye",
        executable = ctx.executable._executable,
        inputs = inputs,
        outputs = outputs,
        arguments = [arguments],
    )

    return [DefaultInfo(files = depset(outputs))]

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
        "srcs": attr.label_list(allow_files = [".java"]),
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
    },
    provides = [DefaultInfo],
)
