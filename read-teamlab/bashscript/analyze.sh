#!/bin/bash

# ========================
# Log-Analyse-Skript
# ========================

LOG_DIR="./logs"
ATTACK_LOG="$LOG_DIR/attack.log"
NMAP_LOG="$LOG_DIR/nmap.txt"
HYDRA_LOG="$LOG_DIR/hydra.txt"
SUMMARY_FILE="$LOG_DIR/summary.txt"

# Leere Summary-Datei vorbereiten
mkdir -p "$LOG_DIR"
> "$SUMMARY_FILE"

# Logging-Funktion
log_to_summary() {
    local msg="$1"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $msg" >> "$SUMMARY_FILE"
}

# Prüfung auf vorhandene Logs
if [ ! -f "$ATTACK_LOG" ] || [ ! -f "$NMAP_LOG" ] || [ ! -f "$HYDRA_LOG" ]; then
    log_to_summary "❌ Fehler: Eine oder mehrere Log-Dateien fehlen."
    exit 1
fi

# Header
log_to_summary "=== Angriffsübersicht ==="
log_to_summary "Generiert am: $(date '+%Y-%m-%d %H:%M:%S')"

# --- Nmap ---
log_to_summary "--- Nmap-Scan-Ergebnisse ---"
while IFS= read -r line; do
    if [[ $line =~ ^[0-9]+/tcp ]]; then
        port=$(echo "$line" | awk '{print $1}' | cut -d'/' -f1)
        service=$(echo "$line" | awk '{print $3}')
        version=$(echo "$line" | awk '{$1=$2=$3=""; print substr($0,4)}' | sed 's/^ //')
        log_to_summary "Port $port/tcp: $service $version"
    fi
done < <(grep "^[0-9]\+/tcp" "$NMAP_LOG")

# --- Hydra ---
log_to_summary "--- Hydra-Bruteforce-Ergebnisse ---"
if grep -q "password:" "$HYDRA_LOG"; then
    login=$(grep "login:" "$HYDRA_LOG" | head -1 | sed -n 's/.*login: \([^ ]*\).*/\1/p')
    password=$(grep "password:" "$HYDRA_LOG" | head -1 | sed -n 's/.*password: \([^ ]*\).*/\1/p')
    log_to_summary "Erfolgreicher Login: Benutzer: $login, Passwort: $password"
else
    log_to_summary "❌ Kein erfolgreicher Login gefunden."
fi

# --- Angriffszeit ---
log_to_summary "--- Angriffsdetails ---"
start_time=$(grep "Starte Angriff" "$ATTACK_LOG" | head -1 | awk '{print $1 " " $2}')
end_time=$(grep "Angriff abgeschlossen" "$ATTACK_LOG" | tail -1 | awk '{print $1 " " $2}')
log_to_summary "Startzeit: $start_time"
log_to_summary "Endzeit: $end_time"
log_to_summary "Dauer: (berechne manuell anhand Start/Endzeit)"

log_to_summary "=== Analyse abgeschlossen ==="
echo "✅ Zusammenfassung erstellt: $SUMMARY_FILE"
