const std = @import("std");

pub fn build(b: *std.build.Builder) void {
    // Standard target options allows the person running `zig build` to choose
    // what target to build for. Here we do not override the defaults, which
    // means any target is allowed, and the default is native. Other options
    // for restricting supported target set are available.
    const target = b.standardTargetOptions(.{});

    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const mode = b.standardReleaseOptions();

    const exe = b.addExecutable("vizor", "src/main.zig");
    exe.setTarget(target);
    exe.setBuildMode(mode);
    exe.addIncludePath("include");
    exe.addLibraryPath("lib");
    exe.linkSystemLibrary("glfw3");
    exe.linkSystemLibrary("GL");
    exe.linkSystemLibrary("X11");
    exe.linkSystemLibrary("pthread");
    exe.linkSystemLibrary("Xrandr");
    exe.linkSystemLibrary("Xi");
    exe.linkSystemLibrary("dl");
    //exe.linkSystemLibrary("glad");
    exe.addCSourceFile("src/glad.c", &.{});
    exe.linkLibC();
    exe.install();

    const run_cmd = exe.run();
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    const editor_tests = b.addTest("src/editor.zig");
    editor_tests.setTarget(target);
    editor_tests.setBuildMode(mode);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&editor_tests.step);
}
