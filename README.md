# M122 Projekt Hacking einer VM

**README / Zusammenfassung für Abgabe**

### Beschreibung:

Dieses Projekt simuliert einen automatisierten Angreifer, der eine absichtlich verwundbare Ziel-VM Aufgesetzt in einem Docker Container angreift. Die Simulation nutzt klassische Pentesting-Tools (nmap, hydra) und durchläuft ein Script das ein portscan macht und mit hydra eine Brootforce Attacke startet. Bei Erfolg oder Misserfolg wir das in 3 unterschiedlichen Log dateien die resultate aufgezeichnet. Diese 3 dateien werden von einem Bash Script in einer Summary Datei zusammengefasst.

### Ablauf der Simulation:
- Recon → Scan der Ziel-VM
- Start des Scripts
- Angriff → Brute-Force
  - Wird gelogt
- Erfolg → Stop
  - Wird gelogt
- Misserfolg → Passwort nicht gefunden
   - Wird gelogt

![Screenshot](/Media/Bild_1.png)

### Technik:
- Linux-Server (Kali/Ubuntu)
- Python/Bash (Engine + Module)
-  Hydra, nmap,
- Zielsystem: Schwach konfiguriert (z. B. Metasploitable 2)
- Automatisierbar via CronJob

### Muss-Features (Produktiver Ablauf der Sicherheitssimulation)

- Hack The Box-artige Simulation, Angriffe durch Script und Auswertung durch Bash-Scripts.
- Alles auf VMs(Docker): Angreifer-VM, Server-VM

### Tests

- Stand 24.06.2025 Angriffe funktionieren ansatzweise kommen teils durch. Jedoch gibt es leider fehler und errors da die Scripte noch sehr low Budget sind.
 ![Screenshot](/Media/Lofile_1.0.png)
  
- Stand 01.07.2025 Angriffe kommen durch, Passwort wird gefunden die Passwörter und das richtige Passwort wird geloggt. Das Bash script ändert die Logs und schreibt die wichtigsten infos in eine Summary.txt.
 ![Screenshot](/Media/summary.png)
