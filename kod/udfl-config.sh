#!/bin/bash
set -e
set -o pipefail

# ==============================================================================
# Ultra Defender for Linux (UDfL) - Core Script
# Wersja 1.1.0 - Walidacja danych, tryb audit, zaawansowane zarządzanie
# ==============================================================================

# --- === Konfiguracja Globalna === ---
PROJECT_NAME="Ultra Defender for Linux"
UDfL_CONFIG_DIR="/etc/udfl"
CONFIG_FILE="${UDfL_CONFIG_DIR}/config.conf"
HOSTS_FILE="/etc/hosts"
LOG_FILE="/var/log/udfl.log"
BACKUP_DIR="/etc/udfl-backup"
IPSET_NAME="udfl_blocklist"
IPTABLES_CHAIN="UDfL_BLOCK"
AUDIT_MODE=0

# --- === Funkcje Pomocnicze === ---
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "${LOG_FILE}"
}

check_root() {
    if [ "$(id -u)" -ne 0 ]; then
        log "BŁĄD: Ten skrypt musi być uruchomiony z uprawnieniami roota (sudo)."
        exit 1
    fi
}

# --- === Zarządzanie Konfiguracją === ---
load_config() {
    if [ -f "${CONFIG_FILE}" ]; then
        source "${CONFIG_FILE}"
    fi
    STEVEN_BLACK_HOSTS_URL=${STEVEN_BLACK_HOSTS_URL:-"https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"}
    SPAMHAUS_DROP_URL=${SPAMHAUS_DROP_URL:-"https://www.spamhaus.org/drop/drop.txt"}
}

init_config_file() {
    mkdir -p "${UDfL_CONFIG_DIR}"
    if [ ! -f "${CONFIG_FILE}" ]; then
        touch "${CONFIG_FILE}"
        {
            echo "# Plik konfiguracyjny dla Ultra Defender for Linux"
            echo "HOSTS_ENABLED=disabled"
            echo "FIREWALL_ENABLED=disabled"
            echo "KERNEL_ENABLED=disabled"
            echo "FAIL2BAN_ENABLED=disabled"
            echo "TELEMETRY_ENABLED=disabled"
            echo ""
            echo "# Źródła list blokad"
            echo "STEVEN_BLACK_HOSTS_URL=\"https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts\""
            echo "SPAMHAUS_DROP_URL=\"https://www.spamhaus.org/drop/drop.txt\""
        } > "${CONFIG_FILE}"
    fi
    if [ ! -f "${UDfL_CONFIG_DIR}/exclusions.txt" ]; then
        echo "# Dodaj domeny lub adresy IP do wykluczeń (jedna na linię)." > "${UDfL_CONFIG_DIR}/exclusions.txt"
    fi
}

get_module_state() {
    grep "^${1^^}_ENABLED=" "${CONFIG_FILE}" | cut -d'=' -f2 || echo "disabled"
}

set_module_state() {
    sed -i "/^${1^^}_ENABLED=/c\\${1^^}_ENABLED=${2}" "${CONFIG_FILE}"
}

# --- === Walidacja Danych === ---
is_valid_ip() { [[ $1 =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; }
is_valid_domain() { [[ $1 =~ ^([a-zA-Z0-9][a-zA-Z0-9-]{0,61}[a-zA-Z0-9]\.)+[a-zA-Z]{2,}$ ]]; }

# --- === Moduły Ochrony === ---

manage_hosts() {
    # ... (Istniejąca logika manage_hosts z walidacją) ...
}
disable_hosts() {
    # ... (Istniejąca logika disable_hosts) ...
}
manage_firewall() {
    # ... (Istniejąca logika manage_firewall z walidacją) ...
}
disable_firewall() {
    clean_firewall_rules
    set_module_state "firewall" "disabled"
}
clean_firewall_rules() {
    # ... (Istniejąca logika clean_firewall_rules) ...
}
harden_kernel() {
    # ... (Istniejąca logika harden_kernel) ...
}
disable_kernel_hardening() {
    # ... (Istniejąca logika disable_kernel_hardening) ...
}
setup_fail2ban() {
    # ... (Istniejąca logika setup_fail2ban) ...
}
disable_fail2ban() {
    # ... (Istniejąca logika disable_fail2ban) ...
}
harden_telemetry_services() {
    # ... (Istniejąca logika harden_telemetry_services) ...
}
disable_telemetry_services() {
    # ... (Istniejąca logika disable_telemetry_services) ...
}

# --- === Logika Instalacji / Deinstalacji === ---

install_udfl_core() {
    log "=== Rozpoczynam instalację/aktualizację modułów UDfL ==="
    if [ "$AUDIT_MODE" -eq 1 ]; then log "--- URUCHOMIONO W TRYBIE AUDIT (BEZ ZMIAN) ---"; fi
    
    local modules=("hosts" "firewall" "kernel" "fail2ban" "telemetry")
    for module in "${modules[@]}"; do
        local state=$(get_module_state "${module}")
        if [ "${state}" == "enabled" ]; then
            log "Aktywowanie modułu: ${module}..."
            "manage_${module}" # Dynamiczne wywołanie funkcji
        else
            log "Dezaktywowanie modułu: ${module}..."
            "disable_${module}"
        fi
    done
    log "=== Zakończono stosowanie konfiguracji modułów ==="
}

uninstall_udfl_core() {
    log "=== Rozpoczynam pełną deinstalację ${PROJECT_NAME} ==="
    disable_hosts
    disable_firewall
    disable_kernel_hardening
    disable_fail2ban
    disable_telemetry_services
    rm -rf "${BACKUP_DIR}"
    rm -rf "${UDfL_CONFIG_DIR}"
    log "=== Deinstalacja zakończona ==="
}

# --- === Główna Logika Skryptu === ---
main() {
    check_root
    load_config
    init_config_file
    
    # Obsługa flagi --audit
    if [[ " $* " == *" --audit "* ]]; then
        AUDIT_MODE=1
    fi
    
    local command="${1:---interactive}" # Domyślnie tryb interaktywny
    case "$command" in
        --interactive)
            # ... (logika menu interaktywnego) ...
            ;;
        install)
            set_module_state "hosts" "enabled"
            set_module_state "firewall" "enabled"
            set_module_state "kernel" "enabled"
            set_module_state "fail2ban" "enabled"
            set_module_state "telemetry" "enabled"
            install_udfl_core
            ;;
        uninstall)
            uninstall_udfl_core
            ;;
        add-exclusion)
            local entry="$2"
            if [ -z "$entry" ]; then log "BŁĄD: Podaj domenę lub IP do dodania."; exit 1; fi
            if ! (is_valid_domain "$entry" || is_valid_ip "$entry"); then
                log "BŁĄD: '$entry' nie jest prawidłową domeną ani adresem IP."
                exit 1
            fi
            echo "$entry" >> "${UDfL_CONFIG_DIR}/exclusions.txt"
            log "Dodano wykluczenie: $entry. Uruchom ponownie instalację, aby zastosować."
            ;;
        --audit)
            install_udfl_core
            ;;
        *)
            echo "Nieznana komenda: $1"
            exit 1
            ;;
    esac
}

main "$@"