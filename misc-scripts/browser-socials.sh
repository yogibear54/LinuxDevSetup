#!/bin/bash
echo "Which browser would you like to use?"
echo "1) Chrome"
echo "2) Brave"
read -p "Enter choice (1/2): " choice

BROWSER=""
case $choice in
  1) BROWSER="google-chrome" ;;
  2) BROWSER="brave-browser" ;;
  *) echo "Invalid choice, using Chrome by default"; BROWSER="google-chrome" ;;
esac

$BROWSER https://x.com
$BROWSER https://linkedin.com
$BROWSER https://facebook.com
$BROWSER https://reddit.com
