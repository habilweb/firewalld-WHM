# Firewalld para WHM/cPanel + BitNinja

Este repositorio contiene dos scripts diseñados para configurar `firewalld` de forma segura en servidores que ejecutan **WHM/cPanel** y utilizan **BitNinja**, **Netdata**, y servicios comunes de correo electrónico y monitoreo.

---

## 🚀 Archivos disponibles

### 1. `install.sh` – Modo **permisivo**
Este script habilita firewalld y **permite todos los puertos necesarios para WHM/cPanel**, sin bloquear el resto. Útil si deseas una configuración segura pero compatible con múltiples servicios personalizados.

**Instalación:**
```bash
curl -sSL https://raw.githubusercontent.com/habilweb/firewalld-WHM/main/install.sh | bash
```

---

### 2. `install-drop.sh` – Modo **restrictivo (DROP)**
Este script configura `firewalld` en **modo DROP**, bloqueando todo el tráfico excepto los puertos explícitamente necesarios para:

- WHM/cPanel
- Webmail
- BitNinja (puertos internos)
- Netdata (puerto 19999)
- Acceso remoto opcional vía SSH o Ansible (puerto 22)

**Instalación:**
```bash
curl -sSL https://raw.githubusercontent.com/habilweb/firewalld-WHM/main/install-drop.sh | bash
```

---

## 🧪 Verificar puertos abiertos

Después de aplicar cualquiera de los scripts, puedes verificar los puertos abiertos con:

```bash
firewall-cmd --list-all
ss -tuln
```

---

## 🛑 Importante

- Ambos scripts detectan automáticamente si **BitNinja** está instalado.
- El modo DROP es más seguro pero **puede bloquear servicios que usen puertos personalizados**, como algunas instalaciones de Moodle, Node.js, etc.
- Asegúrate de probar acceso a WHM, Webmail, y cPanel desde un navegador después de aplicar los cambios.

---

Actualizado: 2025-05-04
