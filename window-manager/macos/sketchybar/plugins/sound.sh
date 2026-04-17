#!/bin/bash
# Current default sound output device (requires brew install switchaudio-osx).
if command -v SwitchAudioSource >/dev/null 2>&1; then
    device="$(SwitchAudioSource -c 2>/dev/null)"
else
    device="?"
fi
sketchybar --set "$NAME" label="${device:-—}"
