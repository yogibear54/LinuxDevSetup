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

$BROWSER https://replicate.com/
$BROWSER https://platform.minimax.io/user-center/payment/token-plan
$BROWSER https://opencode.ai/workspace/wrk_01KCKHXQ7BJEF0BDPX1SJD38AW/go
$BROWSER https://cursor.com/dashboard/spending
$BROWSER https://z.ai/manage-apikey/subscription
$BROWSER https://openrouter.ai/settings/credits
$BROWSER https://docs.google.com/spreadsheets/d/1gXIJX5D2WOI-rGWEnAJUv0sp14_ZZ4woQsMDDBAlQnk/edit?gid=0#gid=0
