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

$BROWSER https://clockify.me/
$BROWSER https://books.zoho.eu/
$BROWSER https://calendar.google.com/calendar/u/0/r
$BROWSER https://drive.google.com/drive/u/0/home
$BROWSER https://tasks.google.com
$BROWSER https://mail.google.com/mail/u/0/#inbox
$BROWSER https://web.whatsapp.com/
