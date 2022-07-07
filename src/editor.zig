const std = @import("std");

pub const Color = struct {
    r: u8,
    g: u8,
    b: u8,
    a: u8,
};

const Point = struct {
    x: u16,
    y: u16,
};

const Rectangle = struct {
    p1: Point,
    p2: Point,
};

pub const Direction = enum {
    left,
    up,
    right,
    down,
};

pub const Editor = struct {
    buffer: []Color,
    size: Point,
    select: Rectangle,
    color: Color,

    const Self = @This();

    // HJKLYUBN motions planned
    //
    //         p1.y -= n .
    //                   ^
    //    p1.x -= n .  .---.
    //              <- |   | ->
    //                 .---.  . p2.x += n
    //                   v
    //                   . p2.y += n

    pub fn adj_sel(self: *Self, dir: Direction, n: i32) void {
        const sel = &self.select;
        const p = switch (dir) {
            .left, .up => &sel.p1,
            .right, .down => &sel.p2,
        };
        switch (dir) {
            .left, .right => p.*.x = self.clamp_offset(p, dir, n),
            .up, .down => p.*.y = self.clamp_offset(p, dir, n),
        }
        rectify_sel(sel, p);
    }

    fn clamp_offset(self: *Self, point: *Point, dir: Direction, offset: i32) u16 {
        const horiz = dir == .left or dir == .right;
        const p = switch (horiz) {
            true => point.x,
            false => point.y,
        };
        const m = switch (horiz) {
            true => self.size.x,
            false => self.size.y,
        };
        return @intCast(u16, std.math.clamp(@intCast(i32, p) + offset, 0, m - 1));
    }

    fn rectify_sel(sel: *Rectangle, upd: *Point) void {
        const p1 = &sel.p1;
        const p2 = &sel.p2;
        if (p1.x > p2.x) {
            upd.*.x = p1.x ^ p2.x ^ upd.x;
        }
        if (p1.y > p2.y) {
            upd.*.y = p1.y ^ p2.y ^ upd.y;
        }
    }

    // TODO: write buffer (qoi/ppm?)
    // fn write(path: []const u8, Encoder: anytype) !void

    // TODO: open new file
    // fn read(Decoder, Reader) !void
};

test "test adjusting selections" {
    var e = Editor{
        .buffer = std.mem.zeroes([]Color),
        .size = .{ .x = 10, .y = 10 },
        .select = .{ .p1 = .{ .x = 1, .y = 1 }, .p2 = .{ .x = 1, .y = 1 } },
        .color = std.mem.zeroes(Color),
    };
    e.adj_sel(.right, 1);
    try std.testing.expectEqual(e.select, .{ .p1 = .{ .x = 1, .y = 1 }, .p2 = .{ .x = 2, .y = 1 } });
    e.adj_sel(.right, -1);
    try std.testing.expectEqual(e.select, .{ .p1 = .{ .x = 1, .y = 1 }, .p2 = .{ .x = 1, .y = 1 } });
    e.adj_sel(.right, 10);
    try std.testing.expectEqual(e.select, .{ .p1 = .{ .x = 1, .y = 1 }, .p2 = .{ .x = 9, .y = 1 } });
    e.adj_sel(.right, -10);
    try std.testing.expectEqual(e.select, .{ .p1 = .{ .x = 1, .y = 1 }, .p2 = .{ .x = 1, .y = 1 } });
    e.adj_sel(.left, 10);
    try std.testing.expectEqual(e.select, .{ .p1 = .{ .x = 1, .y = 1 }, .p2 = .{ .x = 1, .y = 1 } });
    e.adj_sel(.left, -10);
    try std.testing.expectEqual(e.select, .{ .p1 = .{ .x = 0, .y = 1 }, .p2 = .{ .x = 1, .y = 1 } });
}
