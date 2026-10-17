
#!/bin/bash

FICHIER="inventaire.csv"

if [ ! -f "$FICHIER" ]; then
    echo "nom;ip;os;utilisateur" > "$FICHIER"
fi

usage() {
    echo "Usage : $0 {ajouter|lister|chercher|supprimer}"
    echo "  ajouter nom ip os utilisateur"
    echo "  lister"
    echo "  chercher motif"
    echo "  supprimer nom"
}

case "$1" in
    ajouter)
        if [ $# -ne 5 ]; then
            usage
            exit 1
        fi
        if grep -q "^$2;" "$FICHIER"; then
            echo "Erreur : $2 existe déjà"
            exit 1
        fi
        echo "$2;$3;$4;$5" >> "$FICHIER"
        echo "Machine $2 ajoutée"
        ;;
    lister)
        column -t -s ';' "$FICHIER"
        ;;
    chercher)
        if [ -z "$2" ]; then
            usage
            exit 1
        fi
        grep -i -- "$2" "$FICHIER" | column -t -s ';'
        ;;
    supprimer)
        if [ -z "$2" ]; then
            usage
            exit 1
        fi
        if grep -q "^$2;" "$FICHIER"; then
            sed -i "/^$2;/d" "$FICHIER"
            echo "Machine $2 supprimée"
        else
            echo "Erreur : $2 introuvable"
            exit 1
        fi
        ;;
    *)
        usage
        exit 1
        ;;
esac