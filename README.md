# swayReadCursorEvalLoop.sh
An awesome script to move cursor around without mouse in Sway. 

## Features
* The script is running constantly to receive inputs from a named pipe file. It then reads the input, eval to run cursor actions, and loop again for next input.

  - It works better by putting it in background & having bound as keybindings in Sway.

* The most exciting feature is the incremental speed of cursor movements. Curor moves faster when an action is pressed on, and the speed is reset after the action is released off.

  - For example, the *cursor left* action is bound to `$mod+Control+h`, pressing the key to keep moving cursor left increases the speed, even if you just release the `h` key, the speed is still reset. So you can subtly move cursor wildly or mildly :)

* An action to "reset" cursor at the center of the screen, it needs to specify screen resolution in the script to make it work correctly.

* All of the above features are configurable mostly in the script, while little tweaking on the Sway conf.

## Configuration
In script:
```
### Configure cursor movement parameters ###
# Initial cursor speed when an action stars.
cursorSpeed=4
# Increment cursor speed while an action continues.
cursorSpeedIncrement=4
# Stop speed increments at maximum cursor speed.
cursorSpeedMax=50
# Reset back speed to original
cursorSpeedDefault=${cursorSpeed}

### Configure to calculate to set cursor at center of the screen ###
# Resolution* are resolution of the screen specs.
resolutionX=1920
resolutionY=1080
xHalf=$((resolutionX / 2))
yHalf=$((resolutionY / 2))

# the name pipe’s path, used to receive inputs.
pipeFilePath="/tmp/swayScriptsTmpDir"
pipeFile="${pipeFilePath}/swayReadCursorEvalLoop.pipe"

```

In sway conf(as an example):
```
bindsym $mod+Control+h exec "echo 'move left' > /tmp/swayScriptsTmpDir/swayReadCursorEvalLoop.pipe"
bindsym $mod+Control+l exec "echo 'move right' > /tmp/swayScriptsTmpDir/swayReadCursorEvalLoop.pipe"
bindsym $mod+Control+k exec "echo 'move up' > /tmp/swayScriptsTmpDir/swayReadCursorEvalLoop.pipe"
bindsym $mod+Control+j exec "echo 'move down' > /tmp/swayScriptsTmpDir/swayReadCursorEvalLoop.pipe"

bindsym --release $mod+Control+h exec "echo 'reset speed' > /tmp/swayScriptsTmpDir/swayReadCursorEvalLoop.pipe"
bindsym --release $mod+Control+l exec "echo 'reset speed' > /tmp/swayScriptsTmpDir/swayReadCursorEvalLoop.pipe"
bindsym --release $mod+Control+k exec "echo 'reset speed' > /tmp/swayScriptsTmpDir/swayReadCursorEvalLoop.pipe"
bindsym --release $mod+Control+j exec "echo 'reset speed' > /tmp/swayScriptsTmpDir/swayReadCursorEvalLoop.pipe"

bindsym $mod+Control+Escape exec "echo 'set center' > /tmp/swayScriptsTmpDir/swayReadCursorEvalLoop.pipe"

bindsym --no-repeat $mod+Control+q seat - cursor press   BTN_LEFT
bindsym --release   $mod+Control+q seat - cursor release BTN_LEFT
bindsym --no-repeat $mod+Control+e seat - cursor press   BTN_RIGHT
bindsym --release   $mod+Control+e seat - cursor release BTN_RIGHT

# bindsym $mod+Control+w exec 'echo wheel   1 | dotoolc'
# bindsym $mod+Control+s exec 'echo wheel  -1 | dotoolc'
# bindsym $mod+Control+a exec 'echo hwheel -1 | dotoolc'
# bindsym $mod+Control+d exec 'echo hwheel  1 | dotoolc'
```

## Debugging
You can turn on echoed messages to print in the terminal by uncommenting those `echo` lines in the script to see what happens.

I don't wanna add an option for that to decrease the performance of the script, since it's very simple to uncomment them, they're a few lines.