#!/usr/bin/env bash

if [[ -d "/audiotest" ]]
then
  find /audiotest -name "*.mp3" -o -name "*.aac" -o -name "*.wav" > /audiotest/audio_files
  echoprint-codegen -s < /audiotest/audio_files > /audiotest/audiocodes.json
fi