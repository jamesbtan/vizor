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

    pub fn loadGlad(self: *const Self) Error!void {
        c.glfwMakeContextCurrent(self.window);
        if (c.gladLoadGLLoader(@ptrCast(c.GLADloadproc, c.glfwGetProcAddress)) == 0) {
            return Error.GladInitError;
        }
    }

    pub fn addCallbackHandles(self: *const Self) void {
        self.handleKeypress();
        self.handleResize();
    }

    fn handleResize(self: *const Self) void {
        _ = c.glfwSetFramebufferSizeCallback(self.window, framebufferSizeCallback);
    }

    fn framebufferSizeCallback(window: ?*c.GLFWwindow, width: c_int, height: c_int) callconv(.C) void {
        _ = window;
        c.glViewport(0, 0, width, height);
        std.debug.print("test\n", .{});
    }

    fn handleKeypress(self: *const Self) void {
        _ = c.glfwSetKeyCallback(self.window, keyCallback);
    }

    fn keyCallback(window: ?*c.GLFWwindow, key: c_int, scancode: c_int, action: c_int, mods: c_int) callconv(.C) void {
        _ = scancode;
        _ = mods;
        if (key == c.GLFW_KEY_ESCAPE and action == c.GLFW_PRESS) {
            c.glfwSetWindowShouldClose(window, 1);
        }
    }

    pub fn renderLoop(self: *const Self) void {
        while (c.glfwWindowShouldClose(self.window) == 0) {
            c.glfwSwapBuffers(self.window);
            c.glfwWaitEvents();
        }
    }

    pub fn deinit(_: *const Self) void {
        c.glfwTerminate();
    }
};
