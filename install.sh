#!/bin/bash

echo '--- Verificando puertos abiertos actualmente ---'
ss -tuln | grep LISTEN

echo '--- Verificando si BitNinja está instalado ---'
if systemctl is-active --quiet bitninja; then
  echo '✅ BitNinja está activo.'
else
  echo '⚠️ BitNinja NO está instalado o activo. Abortando configuración.'
  exit 1
fi

echo '--- Verificando conflictos con otros firewalls ---'
if systemctl is-active --quiet iptables; then
  echo '❌ iptables está activo. Puede causar conflictos con firewalld.'
  echo '➡️ Considera desactivarlo antes de continuar: systemctl stop iptables && systemctl disable iptables'
  exit 1
fi
if systemctl is-active --quiet ufw; then
  echo '❌ UFW está activo. Puede causar conflictos con firewalld.'
  echo '➡️ Considera desactivarlo antes de continuar: ufw disable'
  exit 1
fi

echo '--- Verificando sistema operativo ---'
OS=$(grep '^ID=' /etc/os-release | cut -d= -f2 | tr -d '"')
echo "🖥️ Sistema detectado: $OS"

echo '--- Instalando firewalld si no está presente ---'
if ! command -v firewall-cmd >/dev/null 2>&1; then
  if [[ $OS == 'almalinux' || $OS == 'centos' || $OS == 'rhel' || $OS == 'cloudlinux' ]]; then
    yum install -y firewalld > /dev/null
  elif [[ $OS == 'ubuntu' || $OS == 'debian' ]]; then
    apt-get update > /dev/null && apt-get install -y firewalld > /dev/null
  fi
fi

echo '--- Habilitando firewalld ---'
systemctl enable --now firewalld

echo '--- Configurando puertos para WHM/cPanel ---'
FIREWALL_PORTS=(20/tcp 21/tcp 22/tcp 25/tcp 53/tcp 53/udp 80/tcp 110/tcp 143/tcp 443/tcp 465/tcp 587/tcp \
 993/tcp 995/tcp 2082/tcp 2083/tcp 2086/tcp 2087/tcp 2095/tcp 2096/tcp 3306/tcp)

for PORT in "${FIREWALL_PORTS[@]}"; do
  if ! firewall-cmd --list-ports | grep -q "$PORT"; then
    firewall-cmd --permanent --add-port=$PORT
    echo "✅ Puerto $PORT agregado."
  else
    echo "⏭️ Puerto $PORT ya está permitido."
  fi
done

firewall-cmd --reload

echo '--- Configuración actual de firewalld ---'
firewall-cmd --list-all

LOG_FILE="/var/log/firewalld-whm-setup.log"
{
  echo "[$(date)] Firewalld configurado correctamente con los puertos necesarios para WHM/cPanel."
  echo "BitNinja detectado y considerado."
  echo "Verificación de conflictos con iptables y ufw completada."
} >> "$LOG_FILE"

echo ""
echo "✅ Firewalld está activo y configurado correctamente para WHM/cPanel."
echo "📄 Log guardado en: $LOG_FILE"
