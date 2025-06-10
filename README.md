# M122 Projekt Hacking eines VM

***README / Zusammenfassung für Abgabe**

### Beschreibung:

Dieses Projekt simuliert einen automatisierten Angreifer, der eine absichtlich verwundbare Ziel-VM angreift. Die Engine nutzt klassische Pentesting-Tools (nmap, hydra, metasploit) und entscheidet selbstständig, welche Angriffstechnik als Nächstes eingesetzt wird. Bei Erfolg wird ein Report erstellt, Payloads archiviert und eine Admin-Benachrichtigung ausgelöst.

### Ablauf der Simulation:
- Recon → Scan der Ziel-VM
- Entscheidungslogik → Auswahl passender Angriffsmethode
- Angriff → Brute-Force, Exploit oder Payload
- Erfolg → Punktevergabe + Flag-Erfassung + Report
- Misserfolg → Nächster Angriffsweg

### Technik:
- Linux-Server (Kali/Ubuntu)
- Python/Bash (Engine + Module)
- Metasploit, Hydra, nmap, etc.
- Zielsystem: Schwach konfiguriert (z. B. Metasploitable 2)
- Automatisierbar via CronJob

 
