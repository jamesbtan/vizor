const std = @import("std");
const window = @import("window.zig");
const editor = @import("editor.zig");

pub fn main() anyerror!void {
    var win = window.Window{};
    try win.init();
    defer win.deinit();

    try win.create();
    try win.loadGlad();
}
