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

## Ablauf der Simulation:

### 🔧 1. Container `ssh-target`

- Startet **Apache mit SSL** und **OpenSSH-Server**
- Stellt eine **Zielmaschine für Angriffe** bereit  
  → Zugangsdaten: `admin:password`
- **DVWA** (Damn Vulnerable Web Application) ist vorinstalliert

---

### 🔨 2. Container `red-attacker`

- Startet automatisch das Skript `attack.sh`
- Führt **drei Angriffsphasen** durch:
  1. **Nmap-Scan** (Ports und Versionen)
  2. **Hydra-Bruteforce-Angriff** auf SSH
  3. **Passwort-Extraktion**
- Alle Ausgaben werden gespeichert in:
  - `logs/attack.log`
  - `logs/nmap.txt`
  - `logs/hydra.txt`

---

### 📊 3. Analyse-Skript `analyze.sh`

- Wird **direkt nach dem Angriff oder manuell** ausgeführt
- Erstellt eine **logische Zusammenfassung**:
  - Offene Ports und Dienste
  - Erfolgreiches Login mit Benutzername und Passwort
  - Start- und Endzeit des Angriffs
- Ausgabe: `logs/summary.txt` (klar und übersichtlich)




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


- Stand 01.07.2025 Angriffe werden erfolgreich geloggt

![Screenshot](/Media/Attack_Log.png.png)

- Dazu wird noch eine Analyse erstellt

![Screenshot](/Media/Analyse.png)

- Script Testing
