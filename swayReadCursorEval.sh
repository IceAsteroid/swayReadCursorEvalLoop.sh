#!/bin/bash

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

# The name pipe’s path, used to receive inputs.
pipeFilePath="/tmp/swayScriptsTmpDir"
pipeFile="${pipeFilePath}/swayReadCursorEvalLoop.pipe"

printUsage_() {
  cat <<EOF
Usage:
  $(basename "$0") [OPTION]
  -h Print this usage note
  # Redirect one of following actions to the named pipe,
  # "${pipeFile}"
Actions:
  'move left'
  'move right'
  'move up'
  'move down'
  'set center'
  'reset speed'
EOF
}

[[ "${1}" == "-h" || "${1}" == "--help" ]] && { printUsage_; exit 1; }

# Create the named pipe if not existent.
[ -p ${pipeFile} ] || { mkfifo ${pipeFile}; chmod 744 ${pipeFile}; }

while read -r line < ${pipeFile}; do
  # echo $line sss
  case ${line} in
    "move left")
      # echo speed $cursorSpeed
      if [ ${cursorSpeed} -gt ${cursorSpeedMax} ]; then
        swaymsg "seat - cursor move -${cursorSpeedMax} 0"
      else
        swaymsg "seat - cursor move -$((cursorSpeed+=cursorSpeedIncrement)) 0"
      fi;;
    "move right")
      # echo speed $cursorSpeed
      if [ ${cursorSpeed} -gt ${cursorSpeedMax} ]; then
        swaymsg "seat - cursor move +${cursorSpeedMax} 0"
      else
        swaymsg "seat - cursor move +$((cursorSpeed+=cursorSpeedIncrement)) 0"
      fi;;
    "move up")
      # echo speed $cursorSpeed
      if [ ${cursorSpeed} -gt ${cursorSpeedMax} ]; then
        swaymsg "seat - cursor move 0 -${cursorSpeedMax}"
      else
        swaymsg "seat - cursor move 0 -$((cursorSpeed+=cursorSpeedIncrement))"
      fi;;
    "move down")
      # echo speed $cursorSpeed
      if [ ${cursorSpeed} -gt ${cursorSpeedMax} ]; then
        swaymsg "seat - cursor move 0 +${cursorSpeedMax}"
      else
        swaymsg "seat - cursor move 0 +$((cursorSpeed+=cursorSpeedIncrement))"
      fi;;
    "set center")
      swaymsg "seat - cursor set ${xHalf} ${yHalf}";;
    "reset speed")
      cursorSpeed=${cursorSpeedDefault};;
  esac
done
