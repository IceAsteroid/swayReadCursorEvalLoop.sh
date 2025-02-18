# swayReadCursorEvalLoop.sh
An awesome script to move cursor around without mouse in Sway. 

## Features
* The script is running constantly to receive inputs from a named pipe file. It then reads the input, evals to run cursor actions, and loops again for next input.

  - It works better by putting it in background & having its actions bound as keybindings in Sway.

* The most exciting feature is the incremental speed of cursor movements. Curor moves faster when an action is pressed on, and the speed is reset after the action is released off.

  - For example, the *cursor left* action is bound to `$mod+Control+h`, pressing the key to keep moving cursor to the left, increases the speed. Even if you just release the `h` key while "$mod+Control" is still pressed, the speed is reset. So you can subtly move cursor wildly or mildly :)

* An action to "reset" cursor to be at the center of the screen, it needs to specify screen resolution in the script to make it work correctly.

* All of the above features are configurable mostly in the script, while little tweaking on the Sway conf.

## Combine with other tools in Sway
Mouse clicks & scrolls can be simulated by the built-in Sway features or with tools like `dotool` or `wtype` in Sway.

## Print the help text
`$: swayReadCursorEval.sh -h` or with `--help` argument.

```
Usage:
  swayReadCursorEval_2.sh [OPTIONS] # All options are mandatory.
Options:
  -s Assigned to variable $cursorSpeedX
     Initial cursor speed when an action stars.
  -i Assigned to variable $cursorSpeedIncrementX
     Increment cursor speed while an action continues.
  -m Assigned to variable $cursorSpeedMaxX
     Stop speed increments at maximum cursor speed.
  -S Assigned to variable $cursorSpeedY
     Initial cursor speed when an action stars.
  -I Assigned to variable $cursorSpeedIncrementY
     Increment cursor speed while an action continues.
  -M Assigned to variable $cursorSpeedMaxY
     Stop speed increments at maximum cursor speed.
  -e Assigned to variable $PipeFileSuffix
  -h Print this usage note.
Note:
  To use the script, redirect one of following Actions
  ,to the named pipe: "${PipeFile}" in the script.
Actions:
  'move left'
  'move right'
  'move up'
  'move down'
  'set center'
  'reset speed'
```

In sway conf(as an example):
```
# Unfinished.
```

## Debugging
You can turn on echo messages to print in the terminal by uncommenting those `echo` lines in the script to see what happens.

There's no need to add an option for that, which would decrease the performance of the script a bit, since it's very simple to uncomment them, they're only a few lines.

## Contribution
If you have anything to discuss, just open an issue, don't blindly push a PR, it won't be accepted unless it's discussed first.

Since it's a small script mostly for personal use, if no essential or very useful features are required, you can feel free to just folk and modify it:)
