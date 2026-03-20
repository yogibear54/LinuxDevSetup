#!/usr/bin/env bash
# printer-manager.sh - Interactive menu driven tool for managing print jobs
# Requires: CUPS command line utilities (lpstat, lpq, cancel, lpremove)
#
# Features:
#   1) View the print queue and current jobs
#   2) List configured printers
#   3) Cancel a job (shows numbered job list for selection)
#   4) Remove a job (completed/stopped)
#   5) Show help / exit
#
# Usage: simply run the script; it presents a numbered menu.
# Example:
#   $ ./printer-manager.sh
#   Select an option:
#     1) View queue
#     2) List printers
#     3) Cancel a job
#     4) Remove a job
#     5) Help
#   Enter choice: 3

set -euo pipefail

# --------------------------- Functions ---------------------------

show_help() {
    # Print the header comment from this script
    grep '^#' "$0" | cut -c4-
    exit 0
}

list_printers() {
    echo "=== Configured Printers ==="
    lpstat -p
}

show_queue() {
    echo "=== Print Queue (lpstat -o) ==="
    lpstat -o
    echo "=== Current Jobs (lpq -a) ==="
    lpq -a
}

cancel_job() {
    local jobid="${1:-}"
    if [[ -z "$jobid" ]]; then
        echo "Error: No job ID supplied."
        return 1
    fi
    echo "Cancelling job $jobid..."
    cancel -x "$jobid" 2>/dev/null && echo "Job $jobid cancelled." || echo "Failed to cancel job $jobid."
}

remove_job() {
    local jobid="${1:-}"
    if [[ -z "$jobid" ]]; then
        echo "Error: No job ID supplied."
        return 1
    fi
    echo "Removing job $jobid..."
    if command -v lpremove >/dev/null 2>&1; then
        lpremove -j "$jobid" && echo "Job $jobid removed." || echo "Failed to remove job $jobid (lpremove)."
    else
        cancel -x "$jobid" && echo "Job $jobid cancelled (fallback)." || echo "Failed to remove job $jobid (no lpremove)."
    fi
}

# --------------------------- Menu Loop ---------------------------

while true; do
    clear
    echo "=== Printer Manager Menu ==="
    echo "1) View queue"
    echo "2) List printers"
    echo "3) Cancel a job"
    echo "4) Remove a job"
    echo "5) Help"
    echo "0) Exit"
    echo

    read -rp "Enter choice [0-5]: " choice
    case "$choice" in
        1) show_queue; read -rp "Press Enter to continue..." ;;
        2) list_printers; read -rp "Press Enter to continue..." ;;
        3)
            echo "=== Current Jobs ==="
            # Show each job on its own line with a leading number
            lpq -a | tail -n +2 | nl -v1 -w2 -s'. ' | sed 's/^/    /'
            read -rp "Enter job number to cancel (or press Enter to abort): " jobnum
            # If the user just pressed Enter, abort without affecting any job
            if [[ -z "$jobnum" ]]; then
                echo "Cancelled."
                read -rp "Press Enter to continue..."
                continue
            fi
            # Extract the raw line that corresponds to the chosen number
            selected_line=$(lpq -a | tail -n +2 | sed -n "${jobnum}p")
            # The job ID is the third whitespace‑separated field
            selected_jobid=$(echo "$selected_line" | awk '{print $3}')
            if [[ -z "$selected_jobid" ]]; then
                echo "Invalid selection."
                read -rp "Press Enter to continue..."
            else
                cancel_job "$selected_jobid"
                read -rp "Press Enter to continue..."
            fi
            ;;
        4)
            echo "=== Current Jobs ==="
            lpq -a | tail -n +2 | nl -v1 -w2 -s'. ' | sed 's/^/    /'
            read -rp "Enter job number to remove (or press Enter to abort): " jobnum
            # If the user just pressed Enter, abort without affecting any job
            if [[ -z "$jobnum" ]]; then
                echo "Cancelled."
                read -rp "Press Enter to continue..."
                continue
            fi
            selected_line=$(lpq -a | tail -n +2 | sed -n "${jobnum}p")
            selected_jobid=$(echo "$selected_line" | awk '{print $3}')
            if [[ -z "$selected_jobid" ]]; then
                echo "Invalid selection."
                read -rp "Press Enter to continue..."
            else
                remove_job "$selected_jobid"
                read -rp "Press Enter to continue..."
            fi
            ;;
        5) show_help ;;
        0|*) exit 0 ;;
    esac
done