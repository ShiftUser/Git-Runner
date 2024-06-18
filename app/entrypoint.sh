#!/bin/bash

# Start Xvfb
echo "Starting Xvfb on display :99"
/usr/bin/Xvfb :99 -ac -screen 0 1280x1024x16 >/dev/null 2>&1 &

# Start VNC server
echo "Starting VNC server on display :99"
x11vnc -display :99 -nopw -forever >/dev/null 2>&1 &

# Start Selenium test
echo "Starting Selenium test"
if [ "$1" = "--headless" ]; then
    dotnet SeleniumDocker.dll --headless
else
    dotnet SeleniumDocker.dll
fi
