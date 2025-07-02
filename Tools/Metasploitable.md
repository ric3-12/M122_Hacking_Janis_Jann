# Metasploitable

**Metasploitable** ist ein absichtlich unsicher konfiguriertes virtuelles System, das für **Lern-, Test- und Trainingszwecke** im Bereich IT-Sicherheit und Penetrationstests verwendet wird.

---

## 🔍 Übersicht

- **Herausgeber:** Rapid7 (auch bekannt für das Metasploit Framework)
- **Zweck:** Simulierung realer Schwachstellen zum Üben von:
  - Penetrationstests
  - Sicherheitsscans
  - Ausnutzung von Sicherheitslücken mit Tools wie Metasploit

---

## 🧱 Typische Inhalte

- Veraltete und verwundbare Softwareversionen
- Unsichere Dienste:
  - FTP, SSH, Telnet
  - MySQL, Apache, Tomcat
- Verwundbare Webanwendungen:
  - DVWA (Damn Vulnerable Web Application)
  - Mutillidae
  - WebDAV
  - phpMyAdmin
- Schwache Zugangsdaten (z. B. `msfadmin:msfadmin`)

---

## ⚠️ Wichtige Hinweise

- **Nur in einer isolierten Testumgebung verwenden**, z. B. in einer virtuellen Maschine ohne Internetzugang.
- **Nicht im produktiven Netzwerk oder öffentlich einsetzen**, da das System absichtlich viele Sicherheitslücken enthält.