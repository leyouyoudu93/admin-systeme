#!/bin/bash

echo "=== Informations système ==="
echo "Machine  : $(hostname)"
echo "Date     : $(date '+%d/%m/%Y %H:%M')"
echo "Système  : $(. /etc/os-release && echo "$PRETTY_NAME")"
echo "Noyau    : $(uname -r)"
echo "Uptime   : $(uptime -p)"
echo "IP       : $(hostname -I | awk '{print $1}')"
echo "CPU      : $(nproc) coeurs"
echo "RAM      : $(free -h | awk '/Mem/ {print $3 " utilisés sur " $2}')"
echo "Disque   : $(df -h / | awk 'NR==2 {print $3 " utilisés sur " $2 " (" $5 ")"}')"