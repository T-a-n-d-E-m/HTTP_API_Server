#!/bin/bash

# Opts for mongoose HTTP server
MONGOOSE_OPTS="-DMG_MAX_RECV_SIZE=52428800 -DMG_IO_SIZE=1048576"

# Libraries to link with
LIBS="$(mariadb_config --include --libs) -lfmt -lcurl -lpoppler-cpp -lpthread"

time g++ -O3 -fmax-errors=1 -std=c++20 -Wall -Wextra -Wpedantic -Wno-volatile -fno-rtti -I../EventBot/src/ $MONGOOSE_OPTS src/mongoose.c src/main.cpp $LIBS -o http_api_server
