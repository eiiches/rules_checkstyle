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

    report_file = ctx.actions.declare_file("{name}_checkstyle_report.txt".format(
        name = ctx.label.name,
    ))

    arguments.add("-o", report_file)
    outputs.append(report_file)

    arguments.add("-c", ctx.file.config.path)
    inputs.append(ctx.file.config)

    if ctx.attr.debug:
        arguments.add("-d")

    arguments.add("-f", "xml")

    if len(ctx.files.srcs) != 0:
        srcs_file = _write_files_list(ctx, ctx.files.srcs, "srcs.txt")

        arguments.add_all(ctx.files.srcs)
        inputs.append(srcs_file)
        inputs.extend(ctx.files.srcs)

    src_file = ctx.actions.declare_file("srcs.txt")

    ctx.actions.run(
        mnemonic = "Checkstlye",
        executable = ctx.executable._executable,
        inputs = inputs,
        outputs = outputs,
        arguments = [arguments],
    )

    return [DefaultInfo(files = depset(outputs))]

def _write_files_list(ctx, files, file_name):
    file = ctx.actions.declare_file(file_name)
    file_content = ",".join([src.path for src in files])

    ctx.actions.write(file, file_content, is_executable = False)

    return file

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
    },
    provides = [DefaultInfo],
)
