#!/bin/bash

if [[ $1 == 'release' ]]; then
	BUILD_MODE="-DRELEASE -O3"
else
	BUILD_MODE="-DDEBUG -g"
fi

# Opts for mongoose HTTP server
MONGOOSE_OPTS="-DMG_MAX_RECV_SIZE=52428800 -DMG_IO_SIZE=1048576"

# Libraries to link with
LIBS="$(mariadb_config --include --libs) -lfmt -lcurl -lpoppler-cpp -lpthread"

time g++ -fmax-errors=1 $BUILD_MODE -std=c++20 -Wall -Wextra -Wpedantic -Wno-volatile -fno-rtti -I../XDHS_Bot/src/ $MONGOOSE_OPTS src/mongoose.c src/main.cpp $LIBS -o http_api_server
