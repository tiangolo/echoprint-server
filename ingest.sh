#!/usr/bin/env bash

if [[ -d "/audio" ]]
then
  find /audio -name "*.mp3" -o -name "*.aac" -o -name "*.wav" > /audio/audio_to_ingest
  echoprint-codegen -s < /audio/audio_to_ingest > /audio/audiocodes.json
  cd $ECHOPRINT_PATH/echoprint-server/util
  python fastingest.py /audio/audiocodes.json
fi