#!/bin/bash

FICHIER="inventaire.csv"
PORT="$1"

if [ ! -f "$FICHIER" ]; then
    echo "Erreur : $FICHIER introuvable. Lance d'abord inventaire.sh"
    exit 1
fi

total=0
up=0

printf "%-15s %-16s %-6s %s\n" "NOM" "IP" "PING" "PORT ${PORT}"

while IFS=';' read -r nom ip os utilisateur; do
    total=$((total + 1))

    if ping -c 1 -W 1 "$ip" > /dev/null 2>&1; then
        etat="UP"
        up=$((up + 1))
    else
        etat="DOWN"
    fi

    etat_port="-"
    if [ -n "$PORT" ]; then
        if timeout 1 bash -c "</dev/tcp/$ip/$PORT" 2> /dev/null; then
            etat_port="ouvert"
        else
            etat_port="fermé"
        fi
    fi

    printf "%-15s %-16s %-6s %s\n" "$nom" "$ip" "$etat" "$etat_port"
done < <(tail -n +2 "$FICHIER")

echo "---"
echo "$up machine(s) en ligne sur $total"