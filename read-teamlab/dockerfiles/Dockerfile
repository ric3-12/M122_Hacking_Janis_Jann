# -------------------------------
# Dockerfile
# Erzeugt einen Container für das Read-Team-Lab
# Dieser Container enthält Tools für Angriffe und eine Wordlist
# -------------------------------
# Author: Jann (Janis)
FROM kalilinux/kali-rolling:latest

# Installiere Tools
RUN apt update && apt install -y \
    nmap \
    hydra \
    && apt clean

# Erstelle Verzeichnisse für Wordlists und Logs
RUN mkdir -p /usr/share/wordlists
COPY rockyou.txt /usr/share/wordlists/
RUN mkdir -p /logs && chmod 777 /logs

# Kopiere und mache das Skript ausführbar
COPY attack.sh /attack.sh
RUN chmod +x /attack.sh

# Halte den Container am Laufen (kein sofortiges Skript-Ausführen)
CMD tail -f /dev/null

COPY attack.sh /attack.sh
RUN chmod +x /attack.sh
CMD ["/attack.sh"]

COPY analyze.sh /analyze.sh
RUN chmod +x /analyze.sh
