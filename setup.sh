#!/bin/bash
# ==============================================
# Mx Emulator - Setup para Linux
# Root Terminal estilo Kali en rojo con Zsh
# ==============================================

set -e  # Detener en cualquier error

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${RED}"
echo "╔══════════════════════════════════════════════╗"
echo "║         Mx Emulator - Setup Linux           ║"
echo "║         Root Terminal en rojo               ║"
echo "╚══════════════════════════════════════════════╝"
echo -e "${NC}"

# Detectar si es WSL
if grep -q Microsoft /proc/version 2>/dev/null; then
    echo -e "${YELLOW}[!] Detectado WSL (Windows Subsystem for Linux)${NC}"
    IS_WSL=true
else
    IS_WSL=false
fi

# 1. Instalar Zsh si no existe
echo -e "${GREEN}[+] Verificando Zsh...${NC}"
if ! command -v zsh &> /dev/null; then
    echo -e "${YELLOW}[!] Zsh no encontrado. Instalando...${NC}"
    if command -v apt &> /dev/null; then
        sudo apt update && sudo apt install -y zsh
    elif command -v yum &> /dev/null; then
        sudo yum install -y zsh
    elif command -v dnf &> /dev/null; then
        sudo dnf install -y zsh
    elif command -v pacman &> /dev/null; then
        sudo pacman -S --noconfirm zsh
    else
        echo -e "${RED}[!] No se pudo instalar Zsh. Instálalo manualmente.${NC}"
        exit 1
    fi
else
    echo -e "${GREEN}[✓] Zsh ya está instalado${NC}"
fi

# 2. Crear directorios
echo -e "${GREEN}[+] Creando estructura de directorios...${NC}"
mkdir -p ~/.config/mx-emulator
mkdir -p ~/.local/share/mx-emulator/tools
mkdir -p ~/.local/share/mx-emulator/scripts
mkdir -p ~/Mx-Emulator/logs

# 3. Configurar Zsh
echo -e "${GREEN}[+] Configurando Zsh para Mx Emulator...${NC}"
if [ -f ~/.zshrc ]; then
    cp ~/.zshrc ~/.zshrc.backup.mx
    echo -e "${YELLOW}[!] Backup de .zshrc guardado como .zshrc.backup.mx${NC}"
fi

# Copiar configuración personalizada
cat > ~/.zshrc << 'EOF'
# ==============================================
# Mx Emulator - Zsh Configuration
# Root Terminal estilo Kali en rojo
# ==============================================

# Plugins (sin Oh-My-Zsh para ahorrar peso)
autoload -Uz compinit
compinit

# Historial
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000

# Opciones
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt SHARE_HISTORY

# Colores rojo estilo Kali
autoload -Uz colors
colors

# Prompt personalizado ROJO
PROMPT='%F{red}┌─[%F{red}root@Mx%F{red}]─[%~]%f
%F{red}└─%F{red}#%f '

# Prompt cuando estamos en directorio raíz
PROMPT2='%F{red}└─%F{red}#%f '

# Mensaje de bienvenida
echo -e "\033[31m"
echo "╔══════════════════════════════════════════════╗"
echo "║         Mx Emulator - Root Terminal         ║"
echo "║         Modo: Hacking Ético                 ║"
echo "╚══════════════════════════════════════════════╝"
echo -e "\033[0m"

# Alias útiles
alias ll='ls -la'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias update='sudo apt update && sudo apt upgrade -y'

# Variables de entorno
export MX_HOME=~/.local/share/mx-emulator
export PATH=$MX_HOME/tools:$PATH

# Función para listar herramientas
list-tools() {
    echo -e "\033[31m[+] Herramientas disponibles:\033[0m"
    ls -1 $MX_HOME/tools 2>/dev/null || echo "  (ninguna instalada aún)"
}

# Función para instalar herramientas
install-tool() {
    if [ -z "$1" ]; then
        echo -e "\033[31m[!] Uso: install-tool <nombre>\033[0m"
        return 1
    fi
    echo -e "\033[31m[+] Instalando $1...\033[0m"
    # Aquí iría la lógica de instalación
}

echo -e "\033[32m[✓] Mx Emulator cargado correctamente\033[0m"
echo -e "\033[33m[!] Escribe 'list-tools' para ver herramientas disponibles\033[0m"
EOF

# 4. Crear script lanzador
echo -e "${GREEN}[+] Creando script lanzador...${NC}"
cat > ~/.local/bin/mx << 'EOF'
#!/bin/bash
# Lanzador Mx Emulator
if [ -f ~/.zshrc ]; then
    exec zsh
else
    echo "Error: ~/.zshrc no encontrado"
    exit 1
fi
EOF
chmod +x ~/.local/bin/mx

# Asegurar que ~/.local/bin está en PATH
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    echo 'export PATH=$HOME/.local/bin:$PATH' >> ~/.bashrc
    echo 'export PATH=$HOME/.local/bin:$PATH' >> ~/.zshrc
fi

# 5. Crear herramientas de ejemplo (ligeras)
echo -e "${GREEN}[+] Instalando herramientas básicas...${NC}"
mkdir -p $HOME/.local/share/mx-emulator/tools

# Script de ejemplo: escaneo simple
cat > $HOME/.local/share/mx-emulator/tools/mx-scan << 'EOF'
#!/bin/bash
echo -e "\033[31m[+] Escaneando red local...\033[0m"
if command -v nmap &> /dev/null; then
    nmap -sn 192.168.1.0/24
else
    echo -e "\033[31m[!] Nmap no instalado. Instala con: sudo apt install nmap\033[0m"
fi
EOF
chmod +x $HOME/.local/share/mx-emulator/tools/mx-scan

# 6. Instalar dependencias mínimas (opcional)
echo -e "${GREEN}[+] ¿Instalar herramientas comunes? (nmap, curl, wget) [S/n]${NC}"
read -r answer
if [[ "$answer" =~ ^[Ss]$ ]] || [[ -z "$answer" ]]; then
    if command -v apt &> /dev/null; then
        sudo apt install -y nmap curl wget net-tools
    elif command -v yum &> /dev/null; then
        sudo yum install -y nmap curl wget net-tools
    elif command -v dnf &> /dev/null; then
        sudo dnf install -y nmap curl wget net-tools
    fi
    echo -e "${GREEN}[✓] Herramientas instaladas${NC}"
fi

# 7. Mensaje final
echo -e "${RED}"
echo "╔══════════════════════════════════════════════╗"
echo "║         ¡INSTALACIÓN COMPLETADA!            ║"
echo "║                                             ║"
echo "║  Para iniciar Mx Emulator escribe:          ║"
echo "║     mx                                      ║"
echo "║                                             ║"
echo "║  O ejecuta directamente:                    ║"
echo "║     zsh                                     ║"
echo "╚══════════════════════════════════════════════╝"
echo -e "${NC}"

# Cambiar a Zsh si se desea
if [[ "$SHELL" != *"zsh"* ]]; then
    echo -e "${YELLOW}[!] Tu shell actual es $SHELL${NC}"
    echo -e "${YELLOW}[!] Para hacer Zsh tu shell por defecto: chsh -s $(which zsh)${NC}"
fi

echo -e "${GREEN}[✓] Listo. ¡Disfruta Mx Emulator!${NC}"
