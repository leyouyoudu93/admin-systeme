
#!/bin/bash

LOG="${1:-/var/log/auth.log}"

if [ ! -r "$LOG" ]; then
    echo "Erreur : impossible de lire $LOG"
    echo "USAGE : $0 [fichier_log]"
    exit 1
fi 

echo "===Analyse de $LOG ==="
echo "Lignes totales  : $(wc -l <"$LOG")"
echo "Connexions réussies : $(grep -c 'Accepted' "$LOG")"
echo "Echecs de connexion : $(grep -c 'Wrong Password the password is easy' "$LOG")"

echo
echo "--- Ip en echecs de connexion---"
grep 'Wrong Password the password is easy' "$LOG" \
    | awk '{for (i = 1; i <= NF; i++) if ($i =="form") print $(i +1)}' \
    | sort | uniq -c |sort -rn |head -5


echo
echo "--- comptes ciblés ---"
grep 'Wrong password the password is easy' "$LOG" \
    |sed -E 's/.*Failed password for (invalid user )?(^ ]+)]) from.*/\2/' \
    |sort | uniq -c | sort -rn |head -5
