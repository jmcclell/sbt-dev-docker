#!/bin/bash

docker run -it --rm \
  -v $(pwd):/workspace \
  -v "$HOME/.ivy2:/root/.ivy2" \
  -v "$HOME/.sbt:/root/.sbt" \
  -v "$HOME/.coursier:/root/.coursier" \
  jmcclell/docker-sbt:latest \
  "$@"
  


