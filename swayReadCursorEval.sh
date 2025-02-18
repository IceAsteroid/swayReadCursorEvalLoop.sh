#!/bin/bash
# This script is based & modified from wl-ReadCursorEval.sh.
# The reason to specifically fork from that script is that
#, swaymsg "seat - cursor move ..." has better performance than dotool.
# If in sway than other wayland managers, it's better to use this script instead.

# Exit immediately if a command returns non-zero exit status code.
set -e
# Exit & Return error if referencing to an unset variable.
set -u

# Define global variables. Global variables start with capital. Exported Variables with full uppercase.
declare -g ResolutionX ResolutionY XHalf YHalf CursorSpeedDefaultX CursorSpeedDefaultY PipeDir PipeFile

### Configure to calculate to set cursor at center of the screen ###
# Resolution* are resolution of the screen specs.
ResolutionX=1920
ResolutionY=1080
XHalf="$((ResolutionX / 2))"
YHalf="$((ResolutionY / 2))"

printHelp_() {
  cat <<EOF
Usage:
  $(basename "$0") [OPTIONS] # All options are mandatory.
Options:
  -s Assigned to variable \$cursorSpeedX
     Initial cursor speed when an action stars.
  -i Assigned to variable \$cursorSpeedIncrementX
     Increment cursor speed while an action continues.
  -m Assigned to variable \$cursorSpeedMaxX
     Stop speed increments at maximum cursor speed.
  -S Assigned to variable \$cursorSpeedY
     Initial cursor speed when an action stars.
  -I Assigned to variable \$cursorSpeedIncrementY
     Increment cursor speed while an action continues.
  -M Assigned to variable \$cursorSpeedMaxY
     Stop speed increments at maximum cursor speed.
  -e Assigned to variable \$PipeFileSuffix
  -h Print this usage note.
Note:
  To use the script, redirect one of following Actions
  ,to the named pipe: "\${PipeFile}" in the script.
Actions:
  'move left'
  'move right'
  'move up'
  'move down'
  'set center'
  'reset speed'
EOF
}

function testArgs_() {
  # Test if any of the mandatory options are not specified.
  declare -A optsMustArray
  declare -i isOptionMissing
  optsMustArray=(
    ["cursorSpeedX"]="-s"
    ["cursorSpeedIncrementX"]="-i"
    ["cursorSpeedMaxX"]="-m"
    ["cursorSpeedY"]="-S"
    ["cursorSpeedIncrementY"]="-I"
    ["cursorSpeedMaxY"]="-M"
    ["PipeFileSuffix"]="-e"
  )
  for i in "${!optsMustArray[@]}"; do
    if ! [ -v "${i}" ]; then
      echo "#!Mandatory Option ${optsMustArray[$i]} Not Specified!"
      isOptionMissing=1
    fi
  done
  if ! [[ -v isOptionMissing ]]; then
    return 0
  elif (( "${isOptionMissing}" )); then
    exit 2
  fi
}

# Print usage info if zero arguments or first argument is not an option.
# Argumental options without arguments are handled by ‘*) printHelp_’ below.
if ! [[ -v 1 ]]; then
  printHelp_; exit 1
elif ! [[ "${1}" =~ -s|-i|-m|-S|-I|-M|-e ]]; then
  printHelp_; exit 1
fi

while getopts :s:i:m:S:I:M:e: OPT; do
  case "${OPT}" in
    s) declare -g cursorSpeedX="${OPTARG}";;
    i) declare -g cursorSpeedIncrementX="${OPTARG}";;
    m) declare -g cursorSpeedMaxX="${OPTARG}";;
    S) declare -g cursorSpeedY="${OPTARG}";;
    I) declare -g cursorSpeedIncrementY="${OPTARG}";;
    M) declare -g cursorSpeedMaxY="${OPTARG}";;
    e) declare -g PipeFileSuffix="${OPTARG}";;
    *) printHelp_; exit 1;;
  esac
done

testArgs_

# Needed when resetting speed to its default
CursorSpeedDefaultX="${cursorSpeedX}"
CursorSpeedDefaultY="${cursorSpeedY}"

# The name pipe’s path, used to receive inputs.
# PipeDir="/tmp/wl-ScriptsTmpDir"
# PipeFile="${PipeDir}/wl-ReadCursorEvalLoop${PipeFileSuffix}.pipe"
PipeDir="/tmp/swayScriptsTmpDir"
PipeFile="${PipeDir}/swayReadCursorEvalLoop${PipeFileSuffix}.pipe"

# Delete any same name file and previous named pipe to solve potential issues.
[ -f "${PipeFile}" ] && rm "${PipeFile}"

# Create the named pipe if not existent.
[ -d "${PipeDir}" ] || { mkdir "${PipeDir}"; chmod 744 "${PipeDir}"; }
[ -p "${PipeFile}" ] || { mkfifo "${PipeFile}"; chmod 744 "${PipeFile}"; }

while read -r line < "${PipeFile}"; do
  echo "${line} sss"
  case "${line}" in
    "move left")
      echo speedX $cursorSpeedX
      if (( $(bc <<<"${cursorSpeedX} > ${cursorSpeedMaxX}") )); then
        # dotoolc <<<"mousemove -${cursorSpeedMaxX} 0"
        swaymsg "seat - cursor move -${cursorSpeedMaxX} 0"
      else
        # dotoolc <<<"mousemove -${cursorSpeedX} 0"
        swaymsg "seat - cursor move -${cursorSpeedX} 0"
        cursorSpeedX=$(bc <<<"${cursorSpeedX} + ${cursorSpeedIncrementX}")
      fi;;
    "move right")
      echo speedX $cursorSpeedX
      if (( $(bc <<<"${cursorSpeedX} > ${cursorSpeedMaxX}") )); then
        # dotoolc <<<"mousemove +${cursorSpeedMaxX} 0"
        swaymsg "seat - cursor move +${cursorSpeedMaxX} 0"
      else
        # dotoolc <<<"mousemove +${cursorSpeedX} 0"
        swaymsg "seat - cursor move +${cursorSpeedX} 0"
        cursorSpeedX=$(bc <<<"${cursorSpeedX} + ${cursorSpeedIncrementX}")
      fi;;
    "move up")
      echo speedY $cursorSpeedY
      if (( $(bc <<<"${cursorSpeedY} > ${cursorSpeedMaxY}") )); then
        # dotoolc <<<"mousemove 0 -${cursorSpeedMaxY}"
        swaymsg "seat - cursor move 0 -${cursorSpeedMaxY}"
      else
        # dotoolc <<<"mousemove 0 -${cursorSpeedY}"
        swaymsg "seat - cursor move 0 -${cursorSpeedY}"
        cursorSpeedY=$(bc <<<"${cursorSpeedY} + ${cursorSpeedIncrementY}")
      fi;;
    "move down")
      echo speedY $cursorSpeedY
      if (( $(bc <<<"${cursorSpeedY} > ${cursorSpeedMaxY}") )); then
        # dotoolc <<<"mousemove 0 +${cursorSpeedMaxY}"
        swaymsg "seat - cursor move 0 +${cursorSpeedMaxY}"
      else
        # dotoolc <<<"mousemove 0 +${cursorSpeedY}"
        swaymsg "seat - cursor move 0 +${cursorSpeedY}"
        cursorSpeedY=$(bc <<<"${cursorSpeedY} + ${cursorSpeedIncrementY}")
      fi;;
    "set center")
      # dotoolc <<<"mouseto ${XHalf} ${YHalf}";;
      swaymsg "seat - cursor set ${XHalf} ${YHalf}";;
    "reset speed")
      cursorSpeedX="${CursorSpeedDefaultX}"
      cursorSpeedY="${CursorSpeedDefaultY}";;
    *)
      echo "!Wrong Motion; Exceptional Motion!";;
    esac
done

