const c = @cImport({
    @cInclude("glad/glad.h");
    @cInclude("GLFW/glfw3.h");
});

const std = @import("std");

pub const Window = struct {
    window: *c.GLFWwindow = undefined,

    const Self = @This();
    const Error = error{ GlfwInitError, GladInitError, CreateWinFail };

    pub fn init(_: *const Self) Error!void {
        if (c.glfwInit() == c.GLFW_FALSE) {
            return Error.GlfwInitError;
        }
        c.glfwWindowHint(c.GLFW_CONTEXT_VERSION_MAJOR, 3);
        c.glfwWindowHint(c.GLFW_CONTEXT_VERSION_MINOR, 3);
        c.glfwWindowHint(c.GLFW_OPENGL_PROFILE, c.GLFW_OPENGL_CORE_PROFILE);
    }

    pub fn create(self: *Self) Error!void {
        self.window = c.glfwCreateWindow(800, 600, "vizor", null, null) orelse {
            return Error.CreateWinFail;
        };
    }

    pub fn loadGlad(_: *const Self) Error!void {
        const ret = c.gladLoadGLLoader(@ptrCast(c.GLADloadproc, c.glfwGetProcAddress));
        if (ret != 1) {
            std.debug.print("{}\n", .{ret});
            return Error.GladInitError;
        }
    }

    pub fn deinit(_: *const Self) void {
        c.glfwTerminate();
    }
};
