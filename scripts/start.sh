#!/bin/bash

SESSION="minecraft"
SERVER_DIR="/home/brianlidesign/mc-fabric"
JAVA="/usr/bin/java"
JAR="fabric-server-launch.jar"

if pgrep -f "$JAR" >/dev/null; then
    echo "A Minecraft server is already running:"
    pgrep -af "$JAR"
    exit 1
fi

if tmux has-session -t "$SESSION" 2>/dev/null; then
    echo "Tmux session '$SESSION' already exists."
    exit 1
fi

cd "$SERVER_DIR" || exit 1

tmux new-session -d -s "$SESSION" \
"$JAVA -Xms512M -Xmx2500M -Djava.net.preferIPv4Stack=true -jar $JAR nogui"

sleep 2

if tmux has-session -t "$SESSION" 2>/dev/null; then
    echo "Server started in tmux session: $SESSION"
    echo "Attach with: tmux attach -t $SESSION"
else
    echo "Server failed to stay running."
    echo "Check logs with: tail -n 50 $SERVER_DIR/logs/latest.log"
    exit 1
fi