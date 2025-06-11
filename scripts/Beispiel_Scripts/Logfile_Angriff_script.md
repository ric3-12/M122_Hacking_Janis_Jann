
# Brute-Force Angriffserkennung per Bash 

Dieses Bash-Skript analysiert ein Authentifizierungs-Logfile (z. B. `/var/log/auth.log`) und filtert verdächtige Login-Versuche heraus – speziell fehlgeschlagene SSH-Passwortversuche. Diese werden in einer Datei namens `Angriff` gespeichert.

---

## Bash-Skript inkl. Email-Versendung, Ordner erstellung, Zeitstempeln etc.

```bash
#!/bin/bash

basisordner="$HOME/Brute-Force_Angriff"

if [ ! -d "$basisordner"]; then
	mkdir -p "$basisordner"
	echo "[$(date)] Hauptverzeichnis '$basisordner' wurde neu erstellt" | tee -a "$HOME/brute_force_init.log"
fi 

zeitstempel=$(date "+&Y-%m-%d-%H-%M")
durchlaufordner="$basisordner/$zeitstempel"

log_datei="/car/log/auth.log"
output_datei="$durchlaufordner/Angriff"
zip_datei="$durchlaufordner/Angriff_${zeitstempel}.zip"
empfaenger="fortnite.gaming@gmx.de"

mkdir -p "$durchlaufordner"

if [-f "$log_datei"]; then
	echo "Logdatei $log_datei nicht gefunden!"
	exit 1
fi

echo "Suche nach Möglichen Attacken wird fortgeführt"
grep "Failed password" "$log_datei" > "$output_datei"

anzahl$(wc -1 < "$output_date")
echo ""$anzahl verdächtiger Einträge gespeichert unter '$output_datei'."

zip -j "$zip_datei" "$output_datei"

echo "Anzahl verdächtiger Einträge: $anzahl" | mail -s "Brute-Force Logbericht $zeitstempel" -A "$zip_datei" "empfaenger"

echo "[$zeitstempel] Durchlauf abgeschlossen - $anzahl Einträge." >> "$basisordner/cronlog.txt

