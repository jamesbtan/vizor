const std = @import("std");
const render = @import("render.zig");
const editor = @import("editor.zig");

pub fn main() anyerror!void {
    var win = render.Window{};
    try win.init();
    defer win.deinit();

    try win.create();
    try win.loadGlad();

    win.addCallbackHandles();

    win.renderLoop();
}
