# Keybinds Summary (tentative)

`vizor` will have 4 modes.

* [Normal Mode](#normal-mode)
* [Visual Mode](#visual-mode)
* [Colorselect Mode](#colorselect-mode)
* [Command Mode](#command-mode)

## Normal Mode

```
y u
 h j k l
b n

y - up left, u - up right, b - down left, n - down right
```

| **key**               | **desc**                                                                                           |
|-----------------------|----------------------------------------------------------------------------------------------------|
| h,j,k,l               | move selection as in vi                                                                            |
| y,u,b,n               | diagonal motions (originating from roguelikes I think?)                                            |
| g + {h,j,k,l,y,u,b,n} | move selection until it can move no further in the appropriate direction                           |
| P                     | copy                                                                                               |
| p                     | paste (starts in top-left of current selection, and extends to match size of the copied selection) |
| f                     | fill selection with color (set with [colorselect mode](#colorselect-mode))                         |
| m`[a-z]`              | save selection                                                                                     |
| '`[a-z]`              | restore selection                                                                                  |
| q`[a-z]`              | record macro                                                                                       |
| @`[a-z]`              | play macro                                                                                         |
| +/-/=                 | Zoom in/out/fill screen                                                                            |
| C                     | Colorpick current color (top-left corner of selection if bigger than 1 px)                         |
| c                     | enter [colorselect mode](#colorselect-mode)                                                        |
| v                     | enter [visual mode](#visual-mode)                                                                  |
| :                     | enter [command mode](#command-mode)                                                                |

## Visual Mode

This mode is used to grow and shrink the selection.

| **key**                   | **desc**                                                                               |
|---------------------------|----------------------------------------------------------------------------------------|
| h,j,k,l,y,u,b,n           | adjust selection by moving bottom-right corner according to the motion key             |
| Shift + {h,j,k,l,y,u,b,n} | adjust selection by moving top-left corner according to the motion key                 |
| Alt + {h,j,k,l,y,u,b,n}   | adjust selection by moving bottom-right corner (top-left corner follows symmetrically) |
| Escape, q                 | enter [normal mode](#normal-mode)                                                      |

## Colorselect Mode

| **key**   | **desc**                          |
|-----------|-----------------------------------|
| {j, k}    | cycle current field up and down   |
| {h, l}    | go to prev, next field            |
| m         | change color model (RGB, HWB)     |
| Escape, q | enter [normal mode](#normal-mode) | 

## Command mode

In this mode, you are prompted for a command, which you execute by pressing `Enter`.
`Escape` and `Control-G` cancel without running anything.

Commands:

* q[uit]
* w[rite]
* e[dit]
* set
    * Image Size related
        * (shrinking an image keeps the top left corner)
        * (growing an image adds black pixels to the bottom right)
        * may be customizable in the future
        * size `<width>` `<height>`
        * width `<width>`
        * height `<height>`
    * encoding (ppm) (more formats later)
        * format to use when saving
