#!/bin/bash

docker run -ti --rm -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -v myautority:/root/.Xauthority -v /home/andrei/projects:/home/andrei/projects qtcreator:latest
