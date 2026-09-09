#!/bin/bash
# ==============================================
# Mx Emulator - Setup Completo
# Root Terminal estilo Kali en rojo con Zsh
# Versión: 1.0.0
# ==============================================

set -e  # Detener en cualquier error

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# ==============================================
# FUNCIONES AUXILIARES
# ==============================================

print_banner() {
    echo -e "${RED}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                                                              ║"
    echo "║     ███╗   ███╗██╗  ██╗    ███████╗███╗   ███╗██╗   ██╗  ║"
    echo "║     ████╗ ████║╚██╗██╔╝    ██╔════╝████╗ ████║██║   ██║  ║"
    echo "║     ██╔████╔██║ ╚███╔╝     █████╗  ██╔████╔██║██║   ██║  ║"
    echo "║     ██║╚██╔╝██║ ██╔██╗     ██╔══╝  ██║╚██╔╝██║██║   ██║  ║"
    echo "║     ██║ ╚═╝ ██║██╔╝ ██╗    ███████╗██║ ╚═╝ ██║╚██████╔╝  ║"
    echo "║     ╚═╝     ╚═╝╚═╝  ╚═╝    ╚══════╝╚═╝     ╚═╝ ╚═════╝   ║"
    echo "║                                                              ║"
    echo "║              Mx Emulator - Root Terminal                    ║"
    echo "║              Versión: 1.0.0                                 ║"
    echo "║              Modo: Hacking Ético                            ║"
    echo "║                                                              ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

check_root() {
    if [ "$EUID" -eq 0 ]; then 
        echo -e "${YELLOW}[!] Ejecutando como root. Algunas herramientas se instalarán globalmente.${NC}"
    fi
}

detect_os() {
    if grep -q Microsoft /proc/version 2>/dev/null; then
        echo -e "${YELLOW}[!] Detectado WSL (Windows Subsystem for Linux)${NC}"
        IS_WSL=true
    else
        IS_WSL=false
    fi
    
    if command -v apt &> /dev/null; then
        PKG_MANAGER="apt"
    elif command -v yum &> /dev/null; then
        PKG_MANAGER="yum"
    elif command -v dnf &> /dev/null; then
        PKG_MANAGER="dnf"
    elif command -v pacman &> /dev/null; then
        PKG_MANAGER="pacman"
    else
        echo -e "${RED}[!] No se detectó un gestor de paquetes compatible.${NC}"
        exit 1
    fi
    echo -e "${GREEN}[✓] Gestor de paquetes: $PKG_MANAGER${NC}"
}

install_package() {
    local pkg="$1"
    echo -e "${YELLOW}[*] Instalando $pkg...${NC}"
    case $PKG_MANAGER in
        apt)
            sudo apt install -y "$pkg"
            ;;
        yum)
            sudo yum install -y "$pkg"
            ;;
        dnf)
            sudo dnf install -y "$pkg"
            ;;
        pacman)
            sudo pacman -S --noconfirm "$pkg"
            ;;
    esac
}

# ==============================================
# INSTALACIÓN PRINCIPAL
# ==============================================

main() {
    clear
    print_banner
    check_root
    detect_os
    
    echo -e "${GREEN}[+] Iniciando instalación de Mx Emulator...${NC}"
    
    # 1. Instalar dependencias básicas
    echo -e "\n${GREEN}[+] Instalando dependencias básicas...${NC}"
    BASIC_PKGS="zsh git curl wget net-tools"
    for pkg in $BASIC_PKGS; do
        if ! command -v "$pkg" &> /dev/null; then
            install_package "$pkg"
        else
            echo -e "${GREEN}[✓] $pkg ya está instalado${NC}"
        fi
    done
    
    # 2. Crear estructura de directorios
    echo -e "\n${GREEN}[+] Creando estructura de directorios...${NC}"
    mkdir -p ~/.config/mx-emulator
    mkdir -p ~/.local/share/mx-emulator/tools/{scanner,cracker,web,exploit,recon,wireless,utils,custom}
    mkdir -p ~/.local/share/mx-emulator/scripts
    mkdir -p ~/Mx-Emulator/logs
    echo -e "${GREEN}[✓] Estructura creada${NC}"
    
    # 3. Configurar Zsh
    echo -e "\n${GREEN}[+] Configurando Zsh...${NC}"
    if [ -f ~/.zshrc ]; then
        cp ~/.zshrc ~/.zshrc.backup.mx
        echo -e "${YELLOW}[!] Backup de .zshrc guardado como .zshrc.backup.mx${NC}"
    fi
    
    cat > ~/.zshrc << 'EOF'
# ==============================================
# Mx Emulator - Zsh Configuration
# Root Terminal estilo Kali en rojo
# ==============================================

# Plugins
autoload -Uz compinit
compinit

# Historial
HISTFILE=~/.zsh_history
HISTSIZE=5000
SAVEHIST=5000
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY

# Comportamiento
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt INTERACTIVE_COMMENTS

# Colores
autoload -Uz colors
colors

# Prompt ROJO estilo Kali
PROMPT='%F{red}┌─[%F{red}root@Mx%F{red}]─[%~]%f
%F{red}└─%F{red}#%f '

PROMPT2='%F{red}└─%F{red}→%f '
PROMPT3='%F{red}└─%F{red}?%f '

# Mensaje de bienvenida
echo -e "\033[31m"
echo "╔══════════════════════════════════════════════╗"
echo "║         Mx Emulator - Root Terminal         ║"
echo "║         Modo: Hacking Ético                 ║"
echo "║         Versión: 1.0.0                      ║"
echo "╚══════════════════════════════════════════════╝"
echo -e "\033[0m"

# Alias
alias ll='ls -la --color=auto'
alias la='ls -A --color=auto'
alias l='ls -CF --color=auto'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'
alias update='sudo apt update && sudo apt upgrade -y'
alias clean='sudo apt autoremove -y && sudo apt autoclean'
alias reload='source ~/.zshrc'
alias myip='curl -s ifconfig.me'
alias ping='ping -c 4'

# Variables de entorno
export MX_HOME=~/.local/share/mx-emulator
export MX_TOOLS=$MX_HOME/tools
export MX_SCRIPTS=$MX_HOME/scripts
export PATH=$MX_TOOLS/scanner:$MX_TOOLS/cracker:$MX_TOOLS/web:$MX_TOOLS/exploit:$MX_TOOLS/recon:$MX_TOOLS/wireless:$MX_TOOLS/utils:$MX_TOOLS/custom:$MX_SCRIPTS:$PATH

# Funciones personalizadas
list-tools() {
    echo -e "\033[31m╔══════════════════════════════════════════════╗\033[0m"
    echo -e "\033[31m║         HERRAMIENTAS DISPONIBLES           ║\033[0m"
    echo -e "\033[31m╚══════════════════════════════════════════════╝\033[0m"
    
    local categories=("scanner" "cracker" "web" "exploit" "recon" "wireless" "utils" "custom")
    local total=0
    
    for category in "${categories[@]}"; do
        if [ -d "$MX_TOOLS/$category" ]; then
            local tools=$(find "$MX_TOOLS/$category" -type f -executable 2>/dev/null | wc -l)
            if [ "$tools" -gt 0 ]; then
                echo -e "\033[36m[+] ${category^^}:\033[0m"
                for tool in $(ls -1 "$MX_TOOLS/$category" 2>/dev/null); do
                    if [ -x "$MX_TOOLS/$category/$tool" ]; then
                        echo -e "    \033[32m•\033[0m $tool"
                        ((total++))
                    fi
                done
                echo ""
            fi
        fi
    done
    echo -e "\033[32m[✓] Total: $total herramientas instaladas\033[0m"
}

install-tool() {
    if [ -z "$1" ]; then
        echo -e "\033[31m[!] Uso: install-tool <nombre>\033[0m"
        echo -e "\033[33m[!] Herramientas disponibles: nmap, masscan, hydra, john, hashcat, sqlmap, metasploit, aircrack-ng\033[0m"
        return 1
    fi
    
    echo -e "\033[31m[+] Instalando $1...\033[0m"
    sudo apt install -y "$1"
    echo -e "\033[32m[✓] $1 instalado correctamente\033[0m"
}

quick-scan() {
    if [ -z "$1" ]; then
        echo -e "\033[31m[!] Uso: quick-scan <IP>\033[0m"
        return 1
    fi
    echo -e "\033[31m[+] Escaneando $1...\033[0m"
    if command -v nmap &> /dev/null; then
        nmap -sV -p- --min-rate 1000 "$1"
    else
        echo -e "\033[31m[!] Nmap no instalado. Ejecuta: install-tool nmap\033[0m"
    fi
}

# Keybindings
bindkey '^R' history-incremental-search-backward
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

echo -e "\033[32m[✓] Mx Emulator cargado correctamente\033[0m"
echo -e "\033[33m[!] Escribe 'list-tools' para ver herramientas disponibles\033[0m"
echo -e "\033[33m[!] Escribe 'install-tool <nombre>' para instalar nuevas herramientas\033[0m"
EOF
    
    echo -e "${GREEN}[✓] .zshrc configurado${NC}"
    
    # 4. Crear script lanzador
    echo -e "\n${GREEN}[+] Creando script lanzador...${NC}"
    mkdir -p ~/.local/bin
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
    
    if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
        echo 'export PATH=$HOME/.local/bin:$PATH' >> ~/.bashrc
        echo 'export PATH=$HOME/.local/bin:$PATH' >> ~/.zshrc
    fi
    
    # 5. Crear script Python launcher
    echo -e "\n${GREEN}[+] Creando Mx Launcher Python...${NC}"
    mkdir -p ~/.local/share/mx-emulator/scripts
    cat > ~/.local/share/mx-emulator/scripts/mx-launcher.py << 'EOF'
#!/usr/bin/env python3
# Mx Emulator - Launcher
import os
import sys
import subprocess
import platform
import shutil

os_type = platform.system()
if os_type == 'Windows':
    subprocess.run(['wsl', 'zsh'], check=False)
else:
    subprocess.run(['zsh'], check=False)
EOF
    chmod +x ~/.local/share/mx-emulator/scripts/mx-launcher.py
    
    # 6. Instalar TOOLS
    echo -e "\n${GREEN}[+] Instalando herramientas de Mx Emulator...${NC}"
    
    # ============================================
    # SCANNER TOOLS
    # ============================================
    echo -e "${CYAN}[+] Instalando Scanner Tools...${NC}"
    
    # mx-nmap
    cat > ~/.local/share/mx-emulator/tools/scanner/mx-nmap << 'EOF'
#!/bin/bash
echo -e "\033[31m[+] Mx Nmap Scanner\033[0m"
if [ -z "$1" ]; then
    echo -e "\033[33m[!] Uso: mx-nmap <IP> [opciones]\033[0m"
    echo -e "\033[33m[!] Ejemplo: mx-nmap 192.168.1.1 -sV\033[0m"
    exit 1
fi
if ! command -v nmap &> /dev/null; then
    sudo apt install -y nmap
fi
nmap "$@"
EOF
    
    # mx-masscan
    cat > ~/.local/share/mx-emulator/tools/scanner/mx-masscan << 'EOF'
#!/bin/bash
echo -e "\033[31m[+] Mx Masscan Scanner\033[0m"
if [ -z "$1" ]; then
    echo -e "\033[33m[!] Uso: mx-masscan <IP/CIDR> [puertos]\033[0m"
    exit 1
fi
if ! command -v masscan &> /dev/null; then
    sudo apt install -y masscan
fi
PORTS=${2:-"1-65535"}
sudo masscan "$1" -p"$PORTS" --rate=10000
EOF
    
    # mx-net
    cat > ~/.local/share/mx-emulator/tools/scanner/mx-net << 'EOF'
#!/bin/bash
echo -e "\033[31m[+] Mx Net Scanner\033[0m"
case "$1" in
    hosts)
        if command -v arp-scan &> /dev/null; then
            sudo arp-scan --local
        else
            sudo apt install -y arp-scan
            sudo arp-scan --local
        fi
        ;;
    interfaces)
        ip -br addr show
        ;;
    *)
        echo -e "\033[33m[!] Comandos: hosts, interfaces\033[0m"
        ;;
esac
EOF
    
    # ============================================
    # CRACKER TOOLS
    # ============================================
    echo -e "${CYAN}[+] Instalando Cracker Tools...${NC}"
    
    # mx-hydra
    cat > ~/.local/share/mx-emulator/tools/cracker/mx-hydra << 'EOF'
#!/bin/bash
echo -e "\033[31m[+] Mx Hydra - Fuerza Bruta\033[0m"
if ! command -v hydra &> /dev/null; then
    sudo apt install -y hydra
fi
if [ $# -lt 4 ]; then
    echo -e "\033[33m[!] Uso: mx-hydra <IP> <servicio> <userlist> <passlist>\033[0m"
    exit 1
fi
hydra -L "$3" -P "$4" "$1" "$2"
EOF
    
    # mx-john
    cat > ~/.local/share/mx-emulator/tools/cracker/mx-john << 'EOF'
#!/bin/bash
echo -e "\033[31m[+] Mx John - Cracker de Hashes\033[0m"
if ! command -v john &> /dev/null; then
    sudo apt install -y john
fi
if [ -z "$1" ]; then
    echo -e "\033[33m[!] Uso: mx-john <hashfile> [wordlist]\033[0m"
    exit 1
fi
john "$1"
EOF
    
    # mx-hashcat
    cat > ~/.local/share/mx-emulator/tools/cracker/mx-hashcat << 'EOF'
#!/bin/bash
echo -e "\033[31m[+] Mx Hashcat - Cracker GPU\033[0m"
if ! command -v hashcat &> /dev/null; then
    sudo apt install -y hashcat
fi
if [ $# -lt 2 ]; then
    echo -e "\033[33m[!] Uso: mx-hashcat <hashfile> <tipo>\033[0m"
    echo "  0  - MD5"
    echo "  100 - SHA1"
    echo "  1400 - SHA256"
    exit 1
fi
hashcat -m "$2" "$1" /usr/share/wordlists/rockyou.txt
EOF
    
    # ============================================
    # WEB TOOLS
    # ============================================
    echo -e "${CYAN}[+] Instalando Web Tools...${NC}"
    
    # mx-sqlmap
    cat > ~/.local/share/mx-emulator/tools/web/mx-sqlmap << 'EOF'
#!/bin/bash
echo -e "\033[31m[+] Mx SQLMap - Inyección SQL\033[0m"
if ! command -v sqlmap &> /dev/null; then
    sudo apt install -y sqlmap
fi
if [ -z "$1" ]; then
    echo -e "\033[33m[!] Uso: mx-sqlmap <URL> [opciones]\033[0m"
    exit 1
fi
sqlmap -u "$1" --random-agent --batch "${@:2}"
EOF
    
    # mx-xss
    cat > ~/.local/share/mx-emulator/tools/web/mx-xss << 'EOF'
#!/bin/bash
echo -e "\033[31m[+] Mx XSS - Escáner de XSS\033[0m"
if [ -z "$1" ]; then
    echo -e "\033[33m[!] Uso: mx-xss <URL>\033[0m"
    exit 1
fi
PAYLOADS=("<script>alert('XSS')</script>" "\"><script>alert('XSS')</script>" "<img src=x onerror=alert('XSS')>")
for payload in "${PAYLOADS[@]}"; do
    if curl -s "$1" | grep -q "$payload"; then
        echo -e "\033[31m[!] XSS encontrado con payload: $payload\033[0m"
    fi
done
EOF
    
    # mx-dirb
    cat > ~/.local/share/mx-emulator/tools/web/mx-dirb << 'EOF'
#!/bin/bash
echo -e "\033[31m[+] Mx Dirb - Escáner de Directorios\033[0m"
if ! command -v dirb &> /dev/null; then
    sudo apt install -y dirb
fi
if [ -z "$1" ]; then
    echo -e "\033[33m[!] Uso: mx-dirb <URL> [wordlist]\033[0m"
    exit 1
fi
dirb "$1" "${2:-/usr/share/wordlists/dirb/common.txt}"
EOF
    
    # ============================================
    # EXPLOIT TOOLS
    # ============================================
    echo -e "${CYAN}[+] Instalando Exploit Tools...${NC}"
    
    # mx-msf
    cat > ~/.local/share/mx-emulator/tools/exploit/mx-msf << 'EOF'
#!/bin/bash
echo -e "\033[31m[+] Mx Metasploit Framework\033[0m"
if ! command -v msfconsole &> /dev/null; then
    sudo apt install -y metasploit-framework
fi
case "$1" in
    console) msfconsole ;;
    search) shift; msfconsole -q -x "search $@; exit" ;;
    *) echo -e "\033[33m[!] Comandos: console, search\033[0m" ;;
esac
EOF
    
    # mx-searchsploit
    cat > ~/.local/share/mx-emulator/tools/exploit/mx-searchsploit << 'EOF'
#!/bin/bash
echo -e "\033[31m[+] Mx SearchSploit - Exploit DB\033[0m"
if ! command -v searchsploit &> /dev/null; then
    sudo apt install -y exploitdb
fi
if [ -z "$1" ]; then
    echo -e "\033[33m[!] Uso: mx-searchsploit <keyword>\033[0m"
    exit 1
fi
searchsploit "$@"
EOF
    
    # ============================================
    # RECON TOOLS
    # ============================================
    echo -e "${CYAN}[+] Instalando Recon Tools...${NC}"
    
    # mx-info
    cat > ~/.local/share/mx-emulator/tools/recon/mx-info << 'EOF'
#!/bin/bash
echo -e "\033[31m[+] Mx Info - Recolección de Info\033[0m"
if [ -z "$1" ]; then
    echo -e "\033[33m[!] Uso: mx-info <dominio/IP>\033[0m"
    exit 1
fi
echo -e "\033[36m[+] WHOIS:\033[0m"
whois "$1" | head -n 10
echo -e "\033[36m[+] DNS:\033[0m"
dig "$1" ANY +short | head -n 5
EOF
    
    # mx-dns
    cat > ~/.local/share/mx-emulator/tools/recon/mx-dns << 'EOF'
#!/bin/bash
echo -e "\033[31m[+] Mx DNS - Herramientas DNS\033[0m"
if [ -z "$1" ]; then
    echo -e "\033[33m[!] Uso: mx-dns <dominio> [tipo]\033[0m"
    exit 1
fi
dig "$1" "${2:-ANY}"
EOF
    
    # mx-whois
    cat > ~/.local/share/mx-emulator/tools/recon/mx-whois << 'EOF'
#!/bin/bash
echo -e "\033[31m[+] Mx Whois - Información de Dominio\033[0m"
if [ -z "$1" ]; then
    echo -e "\033[33m[!] Uso: mx-whois <dominio>\033[0m"
    exit 1
fi
whois "$1" | grep -E "Domain|Name|Registrar|Creation|Expiration|Name Server"
EOF
    
    # ============================================
    # WIRELESS TOOLS
    # ============================================
    echo -e "${CYAN}[+] Instalando Wireless Tools...${NC}"
    
    # mx-wifi
    cat > ~/.local/share/mx-emulator/tools/wireless/mx-wifi << 'EOF'
#!/bin/bash
echo -e "\033[31m[+] Mx WiFi - Herramientas WiFi\033[0m"
case "$1" in
    scan)
        if command -v nmcli &> /dev/null; then
            nmcli dev wifi list
        else
            sudo apt install -y network-manager
            nmcli dev wifi list
        fi
        ;;
    info)
        iwconfig 2>/dev/null | grep -E "ESSID|Mode|Frequency|Quality"
        ;;
    *)
        echo -e "\033[33m[!] Comandos: scan, info\033[0m"
        ;;
esac
EOF
    
    # mx-aircrack
    cat > ~/.local/share/mx-emulator/tools/wireless/mx-aircrack << 'EOF'
#!/bin/bash
echo -e "\033[31m[+] Mx Aircrack - Auditoría WiFi\033[0m"
if ! command -v aircrack-ng &> /dev/null; then
    sudo apt install -y aircrack-ng
fi
case "$1" in
    start) sudo airmon-ng start "$2" ;;
    stop) sudo airmon-ng stop "$2" ;;
    scan) sudo airodump-ng "$2" ;;
    *) echo -e "\033[33m[!] Comandos: start, stop, scan\033[0m" ;;
esac
EOF
    
    # ============================================
    # UTILS TOOLS
    # ============================================
    echo -e "${CYAN}[+] Instalando Utils Tools...${NC}"
    
    # mx-clean
    cat > ~/.local/share/mx-emulator/tools/utils/mx-clean << 'EOF'
#!/bin/bash
echo -e "\033[31m[+] Mx Clean - Limpieza del Sistema\033[0m"
sudo apt clean
sudo apt autoclean
sudo apt autoremove -y
sudo journalctl --vacuum-time=7d
rm -rf /tmp/* 2>/dev/null
echo -e "\033[32m[✓] Limpieza completada\033[0m"
EOF
    
    # mx-update
    cat > ~/.local/share/mx-emulator/tools/utils/mx-update << 'EOF'
#!/bin/bash
echo -e "\033[31m[+] Mx Update - Actualización\033[0m"
sudo apt update
sudo apt upgrade -y
echo -e "\033[32m[✓] Actualización completada\033[0m"
EOF
    
    # mx-backup
    cat > ~/.local/share/mx-emulator/tools/utils/mx-backup << 'EOF'
#!/bin/bash
echo -e "\033[31m[+] Mx Backup - Backup de Config\033[0m"
BACKUP_DIR="$HOME/mx-backup-$(date +%Y%m%d)"
mkdir -p "$BACKUP_DIR"
cp ~/.zshrc "$BACKUP_DIR/" 2>/dev/null
cp ~/.bashrc "$BACKUP_DIR/" 2>/dev/null
cp -r ~/.config/mx-emulator "$BACKUP_DIR/" 2>/dev/null
echo -e "\033[32m[✓] Backup completado en $BACKUP_DIR\033[0m"
EOF
    
    # ============================================
    # CUSTOM TOOLS
    # ============================================
    echo -e "${CYAN}[+] Instalando Custom Tools...${NC}"
    
    # mx-auto
    cat > ~/.local/share/mx-emulator/tools/custom/mx-auto << 'EOF'
#!/bin/bash
echo -e "\033[31m[+] Mx Auto - Automatización\033[0m"
if [ -z "$1" ]; then
    echo -e "\033[33m[!] Uso: mx-auto <IP>\033[0m"
    exit 1
fi
echo -e "\033[32m[+] Escaneando $1...\033[0m"
nmap -sV -p 22,80,443,3306,8080 "$1"
if command -v dirb &> /dev/null; then
    dirb "http://$1" /usr/share/wordlists/dirb/common.txt
fi
EOF
    
    # mx-bypass
    cat > ~/.local/share/mx-emulator/tools/custom/mx-bypass << 'EOF'
#!/bin/bash
echo -e "\033[31m[+] Mx Bypass - Bypass de Seguridad\033[0m"
if [ -z "$1" ]; then
    echo -e "\033[33m[!] Uso: mx-bypass <URL>\033[0m"
    exit 1
fi
for dir in admin administrator login wp-admin cpanel phpmyadmin; do
    URL="$1/$dir"
    STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$URL")
    if [ "$STATUS" = "200" ] || [ "$STATUS" = "302" ]; then
        echo -e "\033[31m[!] Encontrado: $URL (HTTP $STATUS)\033[0m"
    fi
done
EOF
    
    # mx-pwn
    cat > ~/.local/share/mx-emulator/tools/custom/mx-pwn << 'EOF'
#!/bin/bash
echo -e "\033[31m[+] Mx Pwn - Pwn Toolkit\033[0m"
case "$1" in
    scan) shift; mx-nmap "$@" ;;
    web) shift; mx-sqlmap "$@"; mx-xss "$@" ;;
    crack) shift; mx-john "$@" ;;
    wifi) mx-wifi scan ;;
    info) shift; mx-info "$@" ;;
    *) echo -e "\033[33m[!] Modos: scan, web, crack, wifi, info\033[0m" ;;
esac
EOF
    
    # Dar permisos de ejecución a todas las tools
    echo -e "\n${GREEN}[+] Dando permisos de ejecución...${NC}"
    chmod +x ~/.local/share/mx-emulator/tools/**/* 2>/dev/null || true
    
    # ============================================
    # INSTALAR HERRAMIENTAS OPCIONALES
    # ============================================
    echo -e "\n${GREEN}[+] ¿Instalar herramientas comunes? (nmap, sqlmap, hydra) [S/n]${NC}"
    read -r answer
    if [[ "$answer" =~ ^[Ss]$ ]] || [[ -z "$answer" ]]; then
        echo -e "${YELLOW}[*] Instalando herramientas comunes...${NC}"
        for tool in nmap sqlmap hydra john dirb; do
            if ! command -v "$tool" &> /dev/null; then
                install_package "$tool"
            else
                echo -e "${GREEN}[✓] $tool ya está instalado${NC}"
            fi
        done
    fi
    
    # ============================================
    # MENSAJE FINAL
    # ============================================
    echo -e "\n${RED}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                                                              ║"
    echo "║              ¡INSTALACIÓN COMPLETADA!                       ║"
    echo "║                                                              ║"
    echo "║  Para iniciar Mx Emulator:                                  ║"
    echo "║     mx                                                      ║"
    echo "║                                                              ║"
    echo "║  O ejecuta directamente:                                    ║"
    echo "║     zsh                                                     ║"
    echo "║                                                              ║"
    echo "║  Herramientas disponibles:                                  ║"
    echo "║     list-tools  - Ver herramientas instaladas              ║"
    echo "║     install-tool <nombre> - Instalar herramienta           ║"
    echo "║                                                              ║"
    echo "║  Ejemplos:                                                  ║"
    echo "║     mx-nmap 192.168.1.1 -sV                                ║"
    echo "║     mx-sqlmap http://target.com/page?id=1 --dbs           ║"
    echo "║     mx-pwn scan 192.168.1.1                                ║"
    echo "║                                                              ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    # Cambiar a Zsh si se desea
    if [[ "$SHELL" != *"zsh"* ]]; then
        echo -e "${YELLOW}[!] Tu shell actual es $SHELL${NC}"
        echo -e "${YELLOW}[!] Para hacer Zsh tu shell por defecto: chsh -s $(which zsh)${NC}"
    fi
    
    echo -e "${GREEN}[✓] Listo. ¡Disfruta Mx Emulator! 👊${NC}"
}

# ==============================================
# EJECUTAR INSTALACIÓN
# ==============================================

main "$@"
