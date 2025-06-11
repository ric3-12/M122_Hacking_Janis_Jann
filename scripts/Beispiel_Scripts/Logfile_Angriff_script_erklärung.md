
# 🔐 Zusammenfassung – Brute-Force-Erkennung & E-Mail-Versand (Bash)

Dieses Skript erkennt Brute-Force-Angriffe (z. B. fehlgeschlagene SSH-Logins) aus dem Systemlog `/var/log/auth.log`, speichert die Ergebnisse in einer strukturierten Ordnerhierarchie und versendet die Daten regelmäßig per E-Mail.

---

## ✅ Funktionen

- Erstellt automatisch ein Hauptverzeichnis `Brute-Force_Angriff` im Home-Verzeichnis.
- Bei jedem Durchlauf wird ein Unterordner mit Zeitstempel erstellt, z. B. `Brute-Force_Angriff/2025-06-11_14-00`.
- Sucht in der Logdatei nach Zeilen mit `Failed password` (SSH-Brute-Force-Indikator).
- Speichert gefundene Einträge in einer Datei `Angriff`.
- Erstellt ein ZIP-Archiv der Datei (`Angriff_YYYY-MM-DD_HH-MM.zip`).
- Versendet das Archiv per E-Mail an eine angegebene Adresse.
- Protokolliert jeden Durchlauf in einer Logdatei `cronlog.txt`.
- Beim ersten Ausführen wird festgehalten, dass das Hauptverzeichnis erstellt wurde (in `brute_force_init.log`).

---

## 🔁 Automatisierung

Die Ausführung kann über `cron` erfolgen, z. B. alle 2 Stunden:

```
0 */2 * * * /bin/bash /pfad/zum/skript.sh
```

---

## 📦 Voraussetzungen

- Installierte Pakete: `zip`, `mailutils`
- Zugriff auf `/var/log/auth.log` (meist nur mit `sudo`)
- Konfigurierter Mailversand (z. B. über `mail`, `sendmail`, `msmtp` oder Relay)

---

## 📂 Beispielhafte Verzeichnisstruktur

```
Brute-Force_Angriff/
├── 2025-06-11_12-00/
│   ├── Angriff
│   └── Angriff_2025-06-11_12-00.zip
├── 2025-06-11_14-00/
│   ├── Angriff
│   └── Angriff_2025-06-11_14-00.zip
├── cronlog.txt
└── ~/brute_force_init.log
```
