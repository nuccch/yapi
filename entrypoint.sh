#!/bin/sh

set -e

if [ ! -f "/home/yapi/data/init.lock" ]; then
    echo "Waiting for MongoDB to be ready..."
    sleep 10
    
    echo "Initializing YApi..."
    node server/install.js
    
    mkdir -p /home/yapi/data
    touch /home/yapi/data/init.lock
    echo "YApi initialized successfully"
else
    echo "YApi already initialized, skipping installation"
fi

echo "Starting YApi server..."
node server/app.js