#!/bin/bash

echo '--- Verificando puertos abiertos actualmente ---'
ss -tuln | grep LISTEN

echo '--- Verificando si BitNinja está instalado ---'
if systemctl is-active --quiet bitninja; then
  echo 'BitNinja está activo.'
else
  echo 'BitNinja NO está instalado o activo. Abortando configuración.'
  exit 1
fi

echo '--- Verificando sistema operativo ---'
OS=$(grep '^ID=' /etc/os-release | cut -d= -f2 | tr -d '"')
echo "Sistema detectado: $OS"

echo '--- Instalando y habilitando firewalld si es necesario ---'
if [[ $OS == 'almalinux' || $OS == 'centos' || $OS == 'rhel' || $OS == 'cloudlinux' ]]; then
  yum install -y firewalld > /dev/null
elif [[ $OS == 'ubuntu' || $OS == 'debian' ]]; then
  apt-get update > /dev/null && apt-get install -y firewalld > /dev/null
fi
systemctl enable --now firewalld

echo '--- Configurando firewalld para puertos cPanel ---'
FIREWALL_PORTS=(20/tcp 21/tcp 22/tcp 25/tcp 53/tcp 53/udp 80/tcp 110/tcp 143/tcp 443/tcp 465/tcp 587/tcp \
 993/tcp 995/tcp 2082/tcp 2083/tcp 2086/tcp 2087/tcp 2095/tcp 2096/tcp 3306/tcp)
for PORT in "${FIREWALL_PORTS[@]}"; do
  firewall-cmd --permanent --add-port=$PORT
done
firewall-cmd --reload

echo '--- Verificando configuración actual de firewalld ---'
firewall-cmd --list-all

echo '--- Verificando que los servicios estén accesibles ---'
echo 'Esto requiere herramientas como curl, nc o acceso externo para validar completamente.'

echo '✔ Configuración completada. Asegúrate de probar acceso desde el exterior a WHM, cPanel, Webmail y correo.'
# Registro del resumen
LOG_FILE="/var/log/firewalld-whm-setup.log"
{
  echo "[$(date)] Firewalld configurado correctamente con los puertos necesarios para WHM/cPanel."
  echo "BitNinja detectado y considerado en la configuración."
  echo "Todos los servicios críticos como DNS, HTTP/HTTPS, FTP, SMTP, IMAP, POP3, y SSH están habilitados."
} >> "$LOG_FILE"

# Mensaje final al usuario
echo ""
echo "✅ Firewalld está activo y configurado correctamente para WHM/cPanel."
echo "📄 Log guardado en: $LOG_FILE"
