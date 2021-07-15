#!/bin/bash

# Base images used for testing
docker build --build-arg BASE=dfsan-9.0 -f docker/Dockerfile.base -t spcleth/perf-taint:base-dfsan-9.0 .
docker build --build-arg BASE=cfsan-9.0 -f docker/Dockerfile.base -t spcleth/perf-taint:base-cfsan-9.0 .

# Build perf-taint
docker build -f docker/Dockerfile.perf-taint -t spcleth/perf-taint:0.1 .

