# Firewalld para WHM/cPanel + BitNinja

Este script configura automáticamente el firewall `firewalld` para que solo abra los puertos necesarios en servidores con WHM/cPanel, considerando también que BitNinja esté instalado (sin interferir con `PortHoneypot`).

## ✅ ¿Qué hace este script?

- Instala y activa `firewalld` si no está presente.
- Abre únicamente los puertos requeridos por WHM/cPanel, Webmail, correo y DNS.
- Evita conflictos con BitNinja (puertos trampa).
- Muestra el estado final de `firewalld`.
- Registra la configuración en `/var/log/firewalld-whm-setup.log`.

## ⚙️ Requisitos

- WHM/cPanel en CentOS, AlmaLinux, CloudLinux o Ubuntu.
- Acceso como `root`.
- Se recomienda tener BitNinja ya instalado.

## 🚀 Instalación rápida

Ejecuta directamente:

```bash
bash <(curl -s https://raw.githubusercontent.com/habilweb/firewalld-WHM/main/install.sh)
