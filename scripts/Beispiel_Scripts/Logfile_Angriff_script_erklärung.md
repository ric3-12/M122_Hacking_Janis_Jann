# Erklärung: Bash-Skript zur Erkennung von Brute-Force-Angriffen

Dieses Bash-Skript analysiert eine System-Logdatei (z. B. /var/log/auth.log) und erkennt mögliche Brute-Force-Angriffe, indem es fehlgeschlagene SSH-Anmeldeversuche filtert. Die Ergebnisse werden in einer Datei namens "Angriff" gespeichert.

---

## 🧠 Aufbau und Erklärung der Komponenten

### Interpreter-Zeile

Der sogenannte Shebang legt fest, dass das Skript mit dem Bash-Interpreter ausgeführt werden soll.

---

### 1. Ausgabe-Datei definieren

Die Variable "output_datei" enthält den Namen der Datei, in der die Angriffsversuche gespeichert werden.

---

### 2. Eingabe-Logdatei definieren

Hier wird die Logdatei festgelegt, aus der Daten gelesen werden. Typischerweise ist dies unter Linux die Datei, in der SSH-Anmeldeversuche protokolliert werden.

---

### 3. Existenzprüfung der Logdatei

Das Skript prüft, ob die Logdatei existiert. Falls nicht, wird eine Fehlermeldung ausgegeben und das Skript abgebrochen.

---

### 4. Suchen nach fehlgeschlagenen Logins

Das Skript filtert alle Zeilen aus dem Logfile, die fehlgeschlagene Anmeldeversuche (z. B. über SSH) anzeigen. Diese Zeilen gelten als Hinweise auf Brute-Force-Angriffe.

---

### 5. Speichern der Ergebnisse

Die gefilterten Zeilen werden in die Datei "Angriff" geschrieben. Bestehende Inhalte werden dabei überschrieben.

---

### 6. Zählen der gefundenen Angriffe

Am Ende wird ermittelt, wie viele Zeilen (also potenzielle Angriffe) in der Datei gespeichert wurden. Diese Anzahl wird am Schluss als Information ausgegeben.

---

## 📝 Beispielhafte Ausgabe

In der Datei "Angriff" könnten z. B. folgende Zeilen stehen:

Jun 11 12:34:56 server sshd[1234]: Failed password for root from 192.168.1.100 port 56789 ssh2  
Jun 11 12:35:01 server sshd[1234]: Failed password for invalid user admin from 192.168.1.101 port 56788 ssh2

---

## ⚠️ Sicherheitshinweis

Dieses Skript stellt nur eine einfache Erkennung dar. Für echte Sicherheit empfiehlt es sich, automatisierte Tools wie fail2ban oder Firewalls mit Login-Rate-Limiting zu verwenden.

