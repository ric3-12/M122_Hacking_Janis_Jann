# M122 Projekt Hacking eines VM

**README / Zusammenfassung für Abgabe**

### Beschreibung:

Dieses Projekt simuliert einen automatisierten Angreifer, der eine absichtlich verwundbare Ziel-VM angreift. Die Engine nutzt klassische Pentesting-Tools (nmap, hydra, metasploit) und entscheidet selbstständig, welche Angriffstechnik als Nächstes eingesetzt wird. Bei Erfolg wird ein Report erstellt, Payloads archiviert und eine Admin-Benachrichtigung ausgelöst.

### Ablauf der Simulation:
- Recon → Scan der Ziel-VM
- Entscheidungslogik → Auswahl passender Angriffsmethode
- Angriff → Brute-Force, Exploit oder Payload
  - Wird gelogt
- Erfolg → Flag-Erfassung + Report
  - Wird gelogt
- Misserfolg → Nächster Angriffsweg
   - Wird gelogt

![Screenshot](/Media/Bild_1.png)

### Technik:
- Linux-Server (Kali/Ubuntu)
- Python/Bash (Engine + Module)
- Metasploit, Hydra, nmap, etc.
- Zielsystem: Schwach konfiguriert (z. B. Metasploitable 2)
- Automatisierbar via CronJob

### Muss-Features (Produktiver Ablauf der Sicherheitssimulation)

- Hack The Box-artige Simulation, Angriffe durch Scripts und Auswertung durch Bash-Scripts der Angriffe mit Benachrichtigung
- Alles auf VMs: Angreifer-VM, Server-VM

### Tests

- Erfolgreiche Angriffe mit Logs
- Script Testing

### Wunsch-Features (Varianten, Kreativität)

- Punktesystem, um das beste und effizienteste Script zu finden
- UI-Übersicht
