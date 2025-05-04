#!/bin/bash

LOG_FILE="/var/log/firewalld-whm-setup.log"

echo '--- Verificando si BitNinja está instalado ---'
if ! systemctl is-active --quiet bitninja; then
  echo '❌ BitNinja NO está instalado o activo. Abortando configuración.'
  exit 1
fi

echo '--- Verificando sistema operativo ---'
OS=$(grep '^ID=' /etc/os-release | cut -d= -f2 | tr -d '"')
echo "Sistema detectado: $OS"

echo '--- Instalando firewalld si es necesario ---'
if [[ $OS == 'almalinux' || $OS == 'centos' || $OS == 'rhel' || $OS == 'cloudlinux' ]]; then
  yum install -y firewalld > /dev/null
elif [[ $OS == 'ubuntu' || $OS == 'debian' ]]; then
  apt-get update > /dev/null && apt-get install -y firewalld > /dev/null
fi

systemctl enable --now firewalld

# Configuramos zona por defecto y cambiamos target a DROP
firewall-cmd --set-default-zone=public
firewall-cmd --permanent --set-target=DROP

# Limpiamos reglas previas
firewall-cmd --permanent --remove-service=ssh || true
firewall-cmd --permanent --remove-service=ftp || true

# Lista de puertos requeridos (WHM/cPanel + Netdata + SMTP/IMAP/POP3)
PUERTOS=(
  20/tcp 21/tcp 22/tcp 25/tcp 53/tcp 53/udp 80/tcp 110/tcp 143/tcp
  443/tcp 465/tcp 587/tcp 993/tcp 995/tcp
  2082/tcp 2083/tcp 2086/tcp 2087/tcp 2095/tcp 2096/tcp 3306/tcp
  19999/tcp
)

echo '--- Aplicando reglas permanentes ---'
for PORT in "${PUERTOS[@]}"; do
  firewall-cmd --permanent --add-port=$PORT
done

# Aplicamos cambios
firewall-cmd --reload

# Verificación final
echo '--- Estado actual de firewalld ---'
firewall-cmd --list-all

# Registro del resumen
echo "[$(date)] Firewalld con DROP configurado correctamente." >> "$LOG_FILE"
echo "✅ Firewalld configurado con DROP y puertos WHM/Netdata permitidos." >> "$LOG_FILE"

# Mensaje final
echo "\n✅ Firewalld configurado correctamente con política DROP."
echo "📄 Log guardado en: $LOG_FILE"
echo "⚠️ IMPORTANTE: Accede a WHM, Webmail, Netdata desde el exterior para confirmar acceso."
echo "Si usarás Ansible, recuerda abrir temporalmente el puerto SSH (22/tcp) si está cerrado."
