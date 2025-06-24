FROM kalilinux/kali-rolling

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y \
    python3 python3-pip curl wget git \
    hydra \
    sqlmap \
    nikto \
    dirb \
    nmap \
    john \
    gobuster \
    netcat-openbsd \
    metasploit-framework \
    nuclei \
    seclists \
    whois \
    dnsutils \
    smbclient \
    crackmapexec \
    python3-requests

RUN mkdir -p /logs

COPY attack.sh /attack.sh

CMD ["/attack.sh"]
