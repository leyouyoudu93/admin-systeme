#!/bin/bash

SOURCE="$1"
DEST="${2:-$HOME/sauvegardes}"
GARDER="${3:-5}"

if [ -z "$SOURCE" ] || [ ! -d "$SOURCE" ]; then
    echo "Usage : $0 dossier_source [dossier_destination] [nombre_a_garder]"
    exit 1
fi

mkdir -p "$DEST"

NOM="$(basename "$SOURCE")"
DATE="$(date +%Y%m%d_%H%M%S)"
ARCHIVE="$DEST/${NOM}_${DATE}.tar.gz"

if tar -czf "$ARCHIVE" -C "$(dirname "$SOURCE")" "$NOM"; then
    echo "Sauvegarde créée : $ARCHIVE ($(du -h "$ARCHIVE" | cut -f1))"
else
    echo "Erreur : la sauvegarde a échoué"
    exit 1
fi

ls -1t "$DEST/${NOM}"_*.tar.gz | tail -n +$((GARDER + 1)) | while read -r vieux; do
    rm -- "$vieux"
    echo "Ancienne sauvegarde supprimée : $vieux"
done