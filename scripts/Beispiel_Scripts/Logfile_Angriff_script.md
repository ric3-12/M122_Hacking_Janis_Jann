
# Brute-Force Angriffserkennung per Bash (Es handelt sich hier nur um ein Beispiel-Script)

Dieses Bash-Skript analysiert ein Authentifizierungs-Logfile (z. B. `/var/log/auth.log`) und filtert verdächtige Login-Versuche heraus – speziell fehlgeschlagene SSH-Passwortversuche. Diese werden in einer Datei namens `Angriff` gespeichert.

---

## Bash-Skript inkl. Email-Versendung

```bash
#!/bin/bash

# Datei, in die die erkannten Angriffe gespeichert werden
output_datei="Angriff"

# Log-Datei, die überwacht wird (z. B. SSH-Log)
log_datei="/var/log/auth.log"

# Prüfen, ob die Log-Datei existiert
if [ ! -f "$log_datei" ]; then
    echo "Logdatei $log_datei nicht gefunden!"
    exit 1
fi

# Fehlversuche filtern (Beispiel: SSH Login)
echo "Suche nach möglichen Brute-Force-Attacken..."
grep "Failed password" "$log_datei" > "$output_datei"

# Zeige die Anzahl gefundener Einträge
anzahl=$(wc -l < "$output_datei")
echo "$anzahl verdächtige Einträge wurden in der Datei '$output_datei' gespeichert."

# In ZIP-Archiv packen
zip "$zip_datei" "$output_datei"

# Per E-Mail versenden (mit mailutils)
empfaenger="deine@emailadresse.de"
betreff="Brute-Force Logbericht"
nachricht="Im Anhang findest du die aktuellen SSH-Angriffe (${anzahl} Einträge)."

echo "$nachricht" | mail -s "$betreff" -A "$zip_datei" "$empfaenger"

