#!/bin/bash
# Start python HTTP server to show test page on port 8000
# Run in background discarding output
cd /var/myApp/appData/
nohup python -m SimpleHTTPServer &>/dev/null &

