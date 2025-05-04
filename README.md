# 🔥 firewalld-WHM: Configuración segura de firewall para WHM/cPanel

Este repositorio contiene dos scripts diseñados para proteger servidores WHM/cPanel configurando el firewall `firewalld` de forma segura y compatible con herramientas como BitNinja, Netdata, SpamExperts y Ansible AWX.

---

## 📜 Archivos disponibles

### ✅ `install.sh` – Modo permisivo

Configura `firewalld` abriendo los puertos necesarios para WHM/cPanel **sin bloquear otros puertos** del sistema. Ideal si tienes aplicaciones web que usan puertos personalizados.

**Uso recomendado para:**
- Servidores compartidos con WordPress, Moodle u otras apps que usan puertos externos.
- Usuarios que quieren seguridad pero sin restricciones estrictas.

**Instalación:**
```bash
curl -sSL https://raw.githubusercontent.com/habilweb/firewalld-WHM/main/install.sh | bash



⸻

🔐 install-drop.sh – Modo seguro con política restrictiva

Configura firewalld en modo DROP por defecto, permitiendo solo los puertos esenciales para WHM/cPanel, BitNinja, Netdata y automatización por SSH (Ansible).

Uso recomendado para:
	•	Servidores dedicados solo a hosting WHM/cPanel.
	•	Usuarios que priorizan seguridad.
	•	Ambientes gestionados remotamente.

Instalación:

curl -sSL https://raw.githubusercontent.com/habilweb/firewalld-WHM/main/install-drop.sh | bash



⸻

🔓 Puertos permitidos por defecto en ambos scripts

Servicio	Puertos abiertos
SSH (Ansible)	22/tcp
DNS	53/tcp, 53/udp
Web (HTTP/HTTPS)	80/tcp, 443/tcp
FTP	20/tcp, 21/tcp
Correo	25/tcp, 465/tcp, 587/tcp
POP3/IMAP	110/tcp, 143/tcp, 993/tcp, 995/tcp
WHM/cPanel	2082–2083/tcp, 2086–2087/tcp
Webmail	2095–2096/tcp
MySQL remoto	3306/tcp
Netdata	19999/tcp



⸻

🛠 Requisitos
	•	Acceso como root
	•	Tener BitNinja instalado (ambos scripts lo detectan)
	•	firewalld se instalará y habilitará automáticamente si no está presente

⸻

📄 Registro de cambios

Cada ejecución crea o actualiza el log:

/var/log/firewalld-whm-setup.log



⸻

⚠️ Notas importantes
	•	Si usas aplicaciones con puertos personalizados (ej. Moodle con WebSocket, APIs REST, etc.), elige install.sh o agrega manualmente esos puertos tras ejecutar install-drop.sh.
	•	Revisa el acceso externo a WHM, cPanel, Webmail y servicios de correo tras aplicar cualquier configuración de firewall.

⸻

👨‍💻 Autor

Habilweb.com
Servicios de hosting y seguridad en Bolivia
🌐 https://www.habilweb.com
