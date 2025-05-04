#!/bin/bash

echo '--- Verificando si BitNinja está instalado ---'
if ! systemctl is-active --quiet bitninja; then
  echo '❌ BitNinja no está instalado o activo. Abortando por seguridad.'
  exit 1
fi
echo '✅ BitNinja está activo.'

echo '--- Verificando sistema operativo ---'
OS=$(grep '^ID=' /etc/os-release | cut -d= -f2 | tr -d '"')
echo "🖥️  Sistema detectado: $OS"

echo '--- Instalando firewalld si es necesario ---'
if [[ $OS == 'ubuntu' || $OS == 'debian' ]]; then
  apt-get update -qq && apt-get install -y firewalld > /dev/null
else
  yum install -y firewalld > /dev/null
fi

echo '--- Activando firewalld ---'
systemctl enable --now firewalld

echo '--- Configurando zona DROP ---'
firewall-cmd --set-default-zone=drop

# Puertos requeridos para WHM/cPanel, Netdata, correo, DNS, y acceso remoto opcional
REQUIRED_PORTS=(
  20/tcp 21/tcp 22/tcp 25/tcp 53/tcp 53/udp 80/tcp 110/tcp 143/tcp 443/tcp
  465/tcp 587/tcp 993/tcp 995/tcp 2082/tcp 2083/tcp 2086/tcp 2087/tcp
  2095/tcp 2096/tcp 3306/tcp 19999/tcp 60221/tcp 60222/tcp
)

echo '--- Agregando puertos permitidos a la zona drop ---'
for port in "${REQUIRED_PORTS[@]}"; do
  firewall-cmd --permanent --zone=drop --add-port="$port"
done

echo '--- Recargando firewalld ---'
firewall-cmd --reload

echo '--- Mostrando configuración actual de firewalld ---'
firewall-cmd --zone=drop --list-all

# Registrar en log
LOG_FILE="/var/log/firewalld-whm-drop.log"
{
  echo "[$(date)] Firewalld en modo DROP configurado con puertos necesarios para WHM/cPanel."
  echo "Puertos permitidos: ${REQUIRED_PORTS[*]}"
} >> "$LOG_FILE"

echo ""
echo "✅ Firewalld configurado en modo DROP. Solo los puertos necesarios están permitidos."
echo "📄 Log guardado en: $LOG_FILE"
