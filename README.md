# firewalld-WHM

Este script automatiza la instalación y configuración segura de `firewalld` en servidores WHM/cPanel, verificando compatibilidad con BitNinja y evitando conflictos con otros firewalls como `iptables` o `ufw`.

## 🔐 ¿Qué hace este script?

- Verifica puertos abiertos en el sistema
- Detecta si BitNinja está activo
- Instala y habilita `firewalld` solo si no está instalado
- Verifica que no haya conflictos con `iptables` o `ufw`
- Abre únicamente los puertos requeridos para WHM/cPanel
- Evita reglas duplicadas
- Registra el estado de la configuración en `/var/log/firewalld-whm-setup.log`

## ✅ Puertos abiertos por el script

| Servicio        | Puertos                                 |
|-----------------|------------------------------------------|
| SSH             | 22/tcp                                   |
| FTP             | 20/tcp, 21/tcp                           |
| DNS             | 53/tcp, 53/udp                           |
| HTTP/S          | 80/tcp, 443/tcp                          |
| SMTP/IMAP/POP3  | 25/tcp, 465/tcp, 587/tcp, 110/tcp, 143/tcp, 993/tcp, 995/tcp |
| WHM/cPanel      | 2082-2083/tcp, 2086-2087/tcp, 2095-2096/tcp |
| MySQL remoto    | 3306/tcp                                 |

---

## 🚀 Instalación rápida

```bash
bash <(curl -s https://raw.githubusercontent.com/habilweb/firewalld-WHM/main/install.sh)
