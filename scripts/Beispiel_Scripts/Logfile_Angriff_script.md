
# Brute-Force Angriffserkennung per Bash 

Dieses Bash-Skript analysiert ein Authentifizierungs-Logfile (z. B. `/var/log/auth.log`) und filtert verdächtige Login-Versuche heraus – speziell fehlgeschlagene SSH-Passwortversuche. Diese werden in einer Datei namens `Angriff` gespeichert.

---

## Bash-Skript inkl. Email-Versendung, Ordner erstellung, Zeitstempeln etc.

```bash
#!/bin/bash

empfaenger="deine@emailadresse.de"  # <--- HIER E-MAIL EINTRAGEN
basisordner="$HOME/Brute-Force_Angriff"
log_datei="/var/log/auth.log"

zeitstempel=$(date "+%Y-%m-%d_%H-%M")
durchlaufordner="$basisordner/$zeitstempel"
output_datei="$durchlaufordner/Angriff"
zip_datei="$durchlaufordner/Angriff_${zeitstempel}.zip"

if [ ! -d "$basisordner" ]; then
    mkdir -p "$basisordner"
    echo "[$(date)] Hauptverzeichnis wurde erstellt: $basisordner" | tee -a "$HOME/brute_force_init.log"
fi

mkdir -p "$durchlaufordner"

if [ ! -f "$log_datei" ]; then
    echo "Logdatei $log_datei nicht gefunden!"
    exit 1
fi

echo "Suche nach möglichen Brute-Force-Attacken..."
grep "Failed password" "$log_datei" > "$output_datei"

anzahl=$(wc -l < "$output_datei")
echo "$anzahl verdächtige Einträge gespeichert unter '$output_datei'."

zip -j "$zip_datei" "$output_datei"

echo "Anzahl verdächtiger SSH-Logins: $anzahl" | mail -s "Brute-Force Bericht $zeitstempel" -A "$zip_datei" "$empfaenger"

echo "[$zeitstempel] Durchlauf abgeschlossen – $anzahl Einträge." >> "$basisordner/cronlog.txt"

