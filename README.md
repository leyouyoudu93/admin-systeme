# admin-systeme : boîte à outils d'administration Linux

Petite collection de scripts Bash pour la gestion d'un parc informatique :
inventaire des machines, détection des machines hors ligne, diagnostic système,
analyse de logs SSH et sauvegardes avec rotation.

Projet réalisé en B3 AIS (Administrateur d'Infrastructures Sécurisées) pour
comprendre comment fonctionnent des outils comme GLPI (inventaire) et
Zabbix (supervision).

## Prérequis

- Linux (testé sous Ubuntu 26.04 via WSL2)
- Bash, `ping`, `tar`, `awk`, `sed`, `grep`

Rendre les scripts exécutables :

```
chmod +x *.sh
```

## Les outils

### `inventaire.sh` : le registre des machines

Gère un fichier `inventaire.csv` (nom;ip;os;utilisateur).

```
./inventaire.sh ajouter pc-compta 192.168.1.10 Windows11 alice
./inventaire.sh lister
./inventaire.sh chercher windows
./inventaire.sh supprimer pc-compta
```

Refuse les doublons et vérifie le nombre d'arguments.

### `scan.sh` : quelles machines répondent ?

Lit l'inventaire, teste chaque machine avec `ping`, et vérifie
éventuellement un port TCP.

```
./scan.sh          # ping uniquement
./scan.sh 22       # ping + test du port 22 (SSH)
```

Affiche UP/DOWN pour chaque machine et un total en fin de rapport.

### `sysinfo.sh` : diagnostic de la machine locale

Affiche nom, système, noyau, uptime, IP, CPU, RAM et disque.

```
./sysinfo.sh
```

### `logs.sh` : analyse des connexions SSH

Compte les connexions réussies et les échecs, puis affiche les 5 IP et les
5 comptes les plus ciblés (repérage d'un brute force).

```
./logs.sh                  # lit /var/log/auth.log
./logs.sh fichier.log      # lit un autre fichier
```

### `sauvegarde.sh` : sauvegarde avec rotation

Crée une archive `tar.gz` datée et ne garde que les N plus récentes.

```
./sauvegarde.sh dossier_source [destination] [nombre_a_garder]
./sauvegarde.sh "$(pwd)" ~/sauvegardes 5
```

Planification quotidienne à 2h00 avec cron (chemins absolus) :

```
0 2 * * * /chemin/sauvegarde.sh /chemin/source /chemin/destination 7
```

Restauration (à tester régulièrement) :

```
tar -xzf archive.tar.gz -C /dossier/de/restauration
```

## Limites connues

- `scan.sh` indique seulement si une machine répond, pas son état interne.
- `sysinfo.sh` ne lit que la machine locale (pas de collecte à distance).
- `inventaire.sh` ne protège pas les noms contenant des caractères spéciaux
  dans `grep` et `sed`.
- Les sauvegardes sont locales : pas de copie vers une autre machine.

## Pistes d'amélioration

- Script `parc.sh` : lancer `sysinfo.sh` en SSH sur les machines UP et
  générer un rapport avec alertes (disque > 80 %, machine DOWN)
- Équivalent PowerShell de `sysinfo` pour les postes Windows
- Copie des sauvegardes vers un autre serveur avec `rsync`
- Blocage automatique des IP agressives avec fail2ban

## Bonus : mini-shell en C

`mini_shell.c` est un petit shell écrit en C (lecture, découpage,
`fork` + `execvp` + `waitpid`, builtins `cd` et `exit`). Il m'a servi à
comprendre le fonctionnement des processus sous Linux.

```
gcc -Wall -Wextra -g -o mysh mini_shell.c
./mysh
```

## Compétences travaillées

Scripting Bash, manipulation de texte (`grep`, `awk`, `sed`, `sort`, `uniq`),
réseau (`ping`, ports TCP), sécurité (analyse de logs, brute force SSH),
sauvegarde et restauration, planification (`cron`), gestion de versions (git).
