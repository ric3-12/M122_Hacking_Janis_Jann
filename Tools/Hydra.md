# Hydra

**Hydra** (auch bekannt als **THC-Hydra**) ist ein leistungsfähiges und flexibles **Brute-Force-Tool** zum Knacken von Passwörtern über das Netzwerk. Es wird häufig in Penetrationstests verwendet, um die Stärke von Zugangsdaten zu überprüfen.

---

## 🔍 Übersicht

- **Name:** THC-Hydra
- **Zweck:** Automatisiertes Erraten (Brute-Forcing) von Benutzernamen/Passwörtern über verschiedene Netzwerkprotokolle
- **Lizenz:** Open Source (GPLv3)
- **Plattform:** Linux, macOS, Windows (über Cygwin oder WSL)

---

## ⚙️ Unterstützte Protokolle

Hydra unterstützt eine Vielzahl von Protokollen, z. B.:

- FTP
- SSH
- Telnet
- HTTP / HTTPS (Form und Basic Auth)
- SMB
- RDP
- VNC
- MySQL, PostgreSQL, MSSQL
- LDAP
- uvm.

---

## 🛠️ Beispielnutzung

```bash
hydra -l admin -P passwortliste.txt ftp://192.168.1.10
