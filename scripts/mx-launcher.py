#!/usr/bin/env python3
# ==============================================
# Mx Emulator - Launcher Principal
# Root Terminal estilo Kali en rojo con Zsh
# Versión: 1.0.0
# ==============================================

import os
import sys
import subprocess
import platform
import readline
import shutil
from datetime import datetime

# Colores ANSI
RED = '\033[0;31m'
GREEN = '\033[0;32m'
YELLOW = '\033[1;33m'
BLUE = '\033[0;34m'
MAGENTA = '\033[0;35m'
CYAN = '\033[0;36m'
WHITE = '\033[1;37m'
NC = '\033[0m'  # No Color

class MxEmulator:
    def __init__(self):
        self.version = "1.0.0"
        self.home = os.path.expanduser("~")
        self.mx_home = os.path.join(self.home, ".local", "share", "mx-emulator")
        self.tools_dir = os.path.join(self.mx_home, "tools")
        self.scripts_dir = os.path.join(self.mx_home, "scripts")
        self.config_dir = os.path.join(self.home, ".config", "mx-emulator")
        self.logs_dir = os.path.join(self.home, "Mx-Emulator", "logs")
        self.os_type = platform.system()
        
    def clear_screen(self):
        """Limpiar pantalla"""
        os.system('cls' if self.os_type == 'Windows' else 'clear')
        
    def print_banner(self):
        """Mostrar banner de Mx Emulator"""
        banner = f"""
{RED}╔══════════════════════════════════════════════════════════════╗
║                                                                  ║
║     ███╗   ███╗██╗  ██╗    ███████╗███╗   ███╗██╗   ██╗      ║
║     ████╗ ████║╚██╗██╔╝    ██╔════╝████╗ ████║██║   ██║      ║
║     ██╔████╔██║ ╚███╔╝     █████╗  ██╔████╔██║██║   ██║      ║
║     ██║╚██╔╝██║ ██╔██╗     ██╔══╝  ██║╚██╔╝██║██║   ██║      ║
║     ██║ ╚═╝ ██║██╔╝ ██╗    ███████╗██║ ╚═╝ ██║╚██████╔╝      ║
║     ╚═╝     ╚═╝╚═╝  ╚═╝    ╚══════╝╚═╝     ╚═╝ ╚═════╝       ║
║                                                                  ║
║           {WHITE}Mx Emulator - Root Terminal{NC}{RED}                      ║
║           {WHITE}Versión: {self.version}{NC}{RED}                             ║
║           {WHITE}Modo: Hacking Ético{NC}{RED}                               ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝{NC}
        """
        print(banner)
        
    def print_menu(self):
        """Mostrar menú principal"""
        menu = f"""
{YELLOW}╔══════════════════════════════════════════════════════════════╗
║                     MENÚ PRINCIPAL                            ║
╠══════════════════════════════════════════════════════════════╣
║  {GREEN}1{NC}. Iniciar Mx Terminal (Zsh)                           {YELLOW}║
║  {GREEN}2{NC}. Listar herramientas disponibles                     {YELLOW}║
║  {GREEN}3{NC}. Instalar herramienta                                {YELLOW}║
║  {GREEN}4{NC}. Actualizar Mx Emulator                             {YELLOW}║
║  {GREEN}5{NC}. Crear backup de configuración                      {YELLOW}║
║  {GREEN}6{NC}. Limpiar sistema                                   {YELLOW}║
║  {GREEN}7{NC}. Información del sistema                            {YELLOW}║
║  {GREEN}8{NC}. Ejecutar comando personalizado                     {YELLOW}║
║  {GREEN}9{NC}. Configurar Mx Emulator                             {YELLOW}║
║  {GREEN}0{NC}. Salir                                              {YELLOW}║
╚══════════════════════════════════════════════════════════════════╝{NC}
        """
        print(menu)
        
    def launch_terminal(self):
        """Iniciar terminal Zsh"""
        print(f"{GREEN}[+] Iniciando Mx Terminal...{NC}")
        
        # Verificar si Zsh está instalado
        if not shutil.which('zsh'):
            print(f"{RED}[!] Zsh no está instalado. Ejecuta setup.sh primero.{NC}")
            return False
            
        # Verificar configuración
        zshrc = os.path.join(self.home, ".zshrc")
        if not os.path.exists(zshrc):
            print(f"{YELLOW}[!] .zshrc no encontrado. Usando configuración por defecto...{NC}")
            
        # Iniciar Zsh
        try:
            if self.os_type == 'Windows':
                # En Windows con WSL
                subprocess.run(['wsl', 'zsh'], check=True)
            else:
                # En Linux nativo
                subprocess.run(['zsh'], check=True)
            return True
        except subprocess.CalledProcessError as e:
            print(f"{RED}[!] Error al iniciar Zsh: {e}{NC}")
            return False
        except FileNotFoundError:
            print(f"{RED}[!] Zsh no encontrado en el sistema.{NC}")
            return False
            
    def list_tools(self):
        """Listar todas las herramientas disponibles"""
        print(f"\n{GREEN}╔══════════════════════════════════════════════════════════════╗")
        print(f"║                    HERRAMIENTAS DISPONIBLES                    ║")
        print(f"╚══════════════════════════════════════════════════════════════╝{NC}\n")
        
        if not os.path.exists(self.tools_dir):
            print(f"{YELLOW}[!] No hay herramientas instaladas.{NC}")
            print(f"{YELLOW}[!] Ejecuta setup.sh para instalar todas las tools.{NC}")
            return
            
        categories = ['scanner', 'cracker', 'web', 'exploit', 'recon', 'wireless', 'utils', 'custom']
        
        total_tools = 0
        for category in categories:
            category_path = os.path.join(self.tools_dir, category)
            if os.path.exists(category_path):
                tools = [f for f in os.listdir(category_path) if os.path.isfile(os.path.join(category_path, f)) and os.access(os.path.join(category_path, f), os.X_OK)]
                if tools:
                    print(f"{CYAN}[+] {category.upper()}:{NC}")
                    for tool in sorted(tools):
                        print(f"    {GREEN}•{NC} {tool}")
                        total_tools += 1
                    print("")
                    
        print(f"{GREEN}[✓] Total: {total_tools} herramientas instaladas{NC}\n")
        
    def install_tool(self):
        """Instalar herramienta específica"""
        print(f"\n{GREEN}╔══════════════════════════════════════════════════════════════╗")
        print(f"║                    INSTALAR HERRAMIENTA                        ║")
        print(f"╚══════════════════════════════════════════════════════════════╝{NC}\n")
        
        tool_name = input(f"{YELLOW}[?] Nombre de la herramienta a instalar: {NC}").strip()
        
        if not tool_name:
            print(f"{RED}[!] No se especificó ninguna herramienta.{NC}")
            return
            
        # Verificar si la herramienta existe en el sistema
        if shutil.which(tool_name):
            print(f"{YELLOW}[!] {tool_name} ya está instalado en el sistema.{NC}")
            return
            
        # Intentar instalar con apt
        if self.os_type != 'Windows':
            print(f"{GREEN}[+] Instalando {tool_name}...{NC}")
            try:
                subprocess.run(['sudo', 'apt', 'install', '-y', tool_name], check=True)
                print(f"{GREEN}[✓] {tool_name} instalado correctamente.{NC}")
            except subprocess.CalledProcessError:
                print(f"{RED}[!] No se pudo instalar {tool_name}.{NC}")
                print(f"{YELLOW}[!] Intenta instalarlo manualmente.{NC}")
        else:
            print(f"{YELLOW}[!] En Windows usa WSL para instalar herramientas.{NC}")
            print(f"{YELLOW}[!] Ejecuta: wsl sudo apt install {tool_name}{NC}")
            
    def update_mx(self):
        """Actualizar Mx Emulator"""
        print(f"\n{GREEN}╔══════════════════════════════════════════════════════════════╗")
        print(f"║                    ACTUALIZANDO MX EMULATOR                    ║")
        print(f"╚══════════════════════════════════════════════════════════════╝{NC}\n")
        
        repo_dir = os.path.join(self.home, "Mx-Emulator")
        
        if os.path.exists(repo_dir):
            print(f"{GREEN}[+] Repositorio encontrado en {repo_dir}{NC}")
            try:
                os.chdir(repo_dir)
                print(f"{YELLOW}[*] Haciendo pull de cambios...{NC}")
                subprocess.run(['git', 'pull'], check=True)
                print(f"{GREEN}[✓] Mx Emulator actualizado.{NC}")
                
                # Re-ejecutar setup
                if os.path.exists("setup.sh"):
                    print(f"{YELLOW}[*] Re-ejecutando setup...{NC}")
                    subprocess.run(['bash', 'setup.sh'], check=True)
                    
            except subprocess.CalledProcessError as e:
                print(f"{RED}[!] Error al actualizar: {e}{NC}")
        else:
            print(f"{YELLOW}[!] Repositorio no encontrado.{NC}")
            clone = input(f"{YELLOW}[?] ¿Clonar repositorio? (y/n): {NC}").strip().lower()
            if clone == 'y':
                try:
                    subprocess.run(['git', 'clone', 'https://github.com/tu-usuario/Mx-Emulator.git'], check=True)
                    print(f"{GREEN}[✓] Repositorio clonado.{NC}")
                except subprocess.CalledProcessError:
                    print(f"{RED}[!] Error al clonar repositorio.{NC}")
                    
    def backup_config(self):
        """Crear backup de configuración"""
        print(f"\n{GREEN}╔══════════════════════════════════════════════════════════════╗")
        print(f"║                    BACKUP DE CONFIGURACIÓN                    ║")
        print(f"╚══════════════════════════════════════════════════════════════╝{NC}\n")
        
        backup_dir = os.path.join(self.home, f"mx-backup-{datetime.now().strftime('%Y%m%d_%H%M%S')}")
        os.makedirs(backup_dir, exist_ok=True)
        
        print(f"{GREEN}[+] Creando backup en {backup_dir}{NC}")
        
        # Backup de archivos de configuración
        config_files = [
            (os.path.join(self.home, ".zshrc"), "zshrc"),
            (os.path.join(self.home, ".bashrc"), "bashrc"),
            (self.config_dir, "mx-config"),
            (self.tools_dir, "mx-tools"),
        ]
        
        for source, name in config_files:
            if os.path.exists(source):
                dest = os.path.join(backup_dir, name)
                try:
                    if os.path.isdir(source):
                        shutil.copytree(source, dest)
                    else:
                        shutil.copy2(source, dest)
                    print(f"{GREEN}[✓] Backup de {name}{NC}")
                except Exception as e:
                    print(f"{YELLOW}[!] Error al hacer backup de {name}: {e}{NC}")
                    
        print(f"{GREEN}[✓] Backup completado en {backup_dir}{NC}")
        
    def clean_system(self):
        """Limpiar el sistema"""
        print(f"\n{GREEN}╔══════════════════════════════════════════════════════════════╗")
        print(f"║                    LIMPIEZA DEL SISTEMA                       ║")
        print(f"╚══════════════════════════════════════════════════════════════╝{NC}\n")
        
        if self.os_type == 'Windows':
            print(f"{YELLOW}[!] Función de limpieza solo disponible en Linux/WSL{NC}")
            return
            
        confirm = input(f"{RED}[!] ¿Seguro que quieres limpiar el sistema? (y/n): {NC}").strip().lower()
        if confirm != 'y':
            print(f"{YELLOW}[!] Operación cancelada.{NC}")
            return
            
        print(f"{GREEN}[+] Limpiando caché de apt...{NC}")
        subprocess.run(['sudo', 'apt', 'clean'], check=False)
        subprocess.run(['sudo', 'apt', 'autoclean'], check=False)
        
        print(f"{GREEN}[+] Eliminando paquetes innecesarios...{NC}")
        subprocess.run(['sudo', 'apt', 'autoremove', '-y'], check=False)
        
        print(f"{GREEN}[+] Eliminando logs viejos...{NC}")
        subprocess.run(['sudo', 'journalctl', '--vacuum-time=7d'], check=False)
        
        print(f"{GREEN}[✓] Limpieza completada.{NC}")
        
    def system_info(self):
        """Mostrar información del sistema"""
        print(f"\n{GREEN}╔══════════════════════════════════════════════════════════════╗")
        print(f"║                    INFORMACIÓN DEL SISTEMA                    ║")
        print(f"╚══════════════════════════════════════════════════════════════╝{NC}\n")
        
        print(f"{CYAN}Sistema Operativo:{NC} {platform.system()} {platform.release()}")
        print(f"{CYAN}Arquitectura:{NC} {platform.machine()}")
        print(f"{CYAN}Procesador:{NC} {platform.processor()}")
        print(f"{CYAN}Hostname:{NC} {platform.node()}")
        print(f"{CYAN}Python:{NC} {platform.python_version()}")
        print(f"{CYAN}Mx Emulator:{NC} {self.version}")
        
        # Información de memoria (Linux)
        if self.os_type != 'Windows':
            try:
                with open('/proc/meminfo', 'r') as f:
                    meminfo = f.readlines()
                for line in meminfo[:3]:
                    print(f"{CYAN}{line.split(':')[0]}:{NC} {line.split(':')[1].strip()}")
            except:
                pass
                
        # Espacio en disco
        print(f"{CYAN}Directorio home:{NC} {self.home}")
        try:
            total, used, free = shutil.disk_usage(self.home)
            print(f"{CYAN}Espacio en disco:{NC} {free // (2**30)} GB disponibles")
        except:
            pass
            
        print("")
        
    def run_custom_command(self):
        """Ejecutar comando personalizado"""
        print(f"\n{GREEN}╔══════════════════════════════════════════════════════════════╗")
        print(f"║                    COMANDO PERSONALIZADO                      ║")
        print(f"╚══════════════════════════════════════════════════════════════╝{NC}\n")
        
        command = input(f"{YELLOW}[?] Comando a ejecutar: {NC}").strip()
        
        if not command:
            print(f"{RED}[!] No se especificó ningún comando.{NC}")
            return
            
        print(f"{GREEN}[+] Ejecutando: {command}{NC}")
        try:
            if self.os_type == 'Windows':
                subprocess.run(command, shell=True)
            else:
                subprocess.run(command, shell=True, executable='/bin/bash')
            print(f"{GREEN}[✓] Comando ejecutado correctamente.{NC}")
        except Exception as e:
            print(f"{RED}[!] Error al ejecutar comando: {e}{NC}")
            
    def configure_mx(self):
        """Configurar Mx Emulator"""
        print(f"\n{GREEN}╔══════════════════════════════════════════════════════════════╗")
        print(f"║                    CONFIGURACIÓN DE MX EMULATOR               ║")
        print(f"╚══════════════════════════════════════════════════════════════╝{NC}\n")
        
        print(f"{CYAN}Configuraciones disponibles:{NC}")
        print(f"  1. Cambiar color del prompt")
        print(f"  2. Cambiar hostname del prompt")
        print(f"  3. Instalar plugins de Zsh")
        print(f"  4. Resetear configuración")
        print(f"  5. Volver al menú")
        
        option = input(f"\n{YELLOW}[?] Selecciona una opción: {NC}").strip()
        
        zshrc = os.path.join(self.home, ".zshrc")
        
        if not os.path.exists(zshrc):
            print(f"{RED}[!] .zshrc no encontrado.{NC}")
            return
            
        with open(zshrc, 'r') as f:
            content = f.read()
            
        if option == '1':
            color = input(f"{YELLOW}[?] Color del prompt (red/green/blue/yellow/magenta/cyan): {NC}").strip().lower()
            colors = {
                'red': 'red',
                'green': 'green',
                'blue': 'blue',
                'yellow': 'yellow',
                'magenta': 'magenta',
                'cyan': 'cyan'
            }
            if color in colors:
                new_content = content.replace('%F{red}', f'%F{{{colors[color]}}}')
                new_content = new_content.replace('%F{red', f'%F{{{colors[color]}}')
                with open(zshrc, 'w') as f:
                    f.write(new_content)
                print(f"{GREEN}[✓] Color del prompt cambiado a {color}{NC}")
            else:
                print(f"{RED}[!] Color no válido.{NC}")
                
        elif option == '2':
            hostname = input(f"{YELLOW}[?] Nuevo hostname: {NC}").strip()
            if hostname:
                new_content = content.replace('root@Mx', f'root@{hostname}')
                with open(zshrc, 'w') as f:
                    f.write(new_content)
                print(f"{GREEN}[✓] Hostname cambiado a {hostname}{NC}")
                
        elif option == '3':
            print(f"{GREEN}[+] Instalando plugins de Zsh...{NC}")
            plugins_dir = os.path.join(self.home, ".zsh", "plugins")
            os.makedirs(plugins_dir, exist_ok=True)
            
            # Git plugin
            git_plugin = os.path.join(plugins_dir, "git.zsh")
            with open(git_plugin, 'w') as f:
                f.write("""# Git aliases
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log'
""")
            
            print(f"{GREEN}[✓] Plugins instalados.{NC}")
            
        elif option == '4':
            confirm = input(f"{RED}[!] ¿Resetear configuración? (y/n): {NC}").strip().lower()
            if confirm == 'y':
                os.remove(zshrc)
                print(f"{GREEN}[✓] Configuración reseteada.{NC}")
                print(f"{YELLOW}[!] Ejecuta setup.sh para reinstalar.{NC}")
                
        else:
            print(f"{YELLOW}[!] Volviendo al menú...{NC}")
            
    def check_dependencies(self):
        """Verificar dependencias"""
        print(f"{GREEN}[+] Verificando dependencias...{NC}")
        
        dependencies = ['zsh', 'git', 'curl', 'wget']
        missing = []
        
        for dep in dependencies:
            if not shutil.which(dep):
                missing.append(dep)
                
        if missing:
            print(f"{YELLOW}[!] Dependencias faltantes: {', '.join(missing)}{NC}")
            if self.os_type != 'Windows':
                install = input(f"{YELLOW}[?] ¿Instalar dependencias? (y/n): {NC}").strip().lower()
                if install == 'y':
                    for dep in missing:
                        try:
                            subprocess.run(['sudo', 'apt', 'install', '-y', dep], check=True)
                            print(f"{GREEN}[✓] {dep} instalado.{NC}")
                        except:
                            print(f"{RED}[!] Error al instalar {dep}{NC}")
            else:
                print(f"{YELLOW}[!] En Windows instala WSL y ejecuta setup.sh{NC}")
        else:
            print(f"{GREEN}[✓] Todas las dependencias están instaladas.{NC}")
            
    def run(self):
        """Ejecutar el launcher principal"""
        self.clear_screen()
        self.print_banner()
        
        # Verificar dependencias
        self.check_dependencies()
        
        # Crear estructura de directorios
        os.makedirs(self.tools_dir, exist_ok=True)
        os.makedirs(self.scripts_dir, exist_ok=True)
        os.makedirs(self.config_dir, exist_ok=True)
        os.makedirs(self.logs_dir, exist_ok=True)
        
        while True:
            self.print_menu()
            option = input(f"\n{YELLOW}[?] Selecciona una opción: {NC}").strip()
            
            if option == '1':
                self.launch_terminal()
            elif option == '2':
                self.list_tools()
            elif option == '3':
                self.install_tool()
            elif option == '4':
                self.update_mx()
            elif option == '5':
                self.backup_config()
            elif option == '6':
                self.clean_system()
            elif option == '7':
                self.system_info()
            elif option == '8':
                self.run_custom_command()
            elif option == '9':
                self.configure_mx()
            elif option == '0':
                print(f"{GREEN}[+] ¡Hasta luego, rey! 👊{NC}")
                sys.exit(0)
            else:
                print(f"{RED}[!] Opción no válida. Intenta de nuevo.{NC}")
                
            input(f"\n{YELLOW}[!] Presiona Enter para continuar...{NC}")
            self.clear_screen()
            self.print_banner()

if __name__ == "__main__":
    try:
        emulator = MxEmulator()
        emulator.run()
    except KeyboardInterrupt:
        print(f"\n{GREEN}[+] ¡Hasta luego! 👊{NC}")
        sys.exit(0)
    except Exception as e:
        print(f"{RED}[!] Error crítico: {e}{NC}")
        sys.exit(1)
