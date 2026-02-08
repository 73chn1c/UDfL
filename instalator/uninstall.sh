#!/bin/bash
# Skrypt deinstalacyjny dla Ultra Defender for Linux

# Znajdź ścieżkę do bieżącego skryptu, aby uruchomić udfl-config.sh z tego samego katalogu
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
CONFIG_SCRIPT="${SCRIPT_DIR}/udfl-config.sh"

if [ ! -f "${CONFIG_SCRIPT}" ]; then
    echo "BŁĄD: Główny skrypt udfl-config.sh nie został znaleziony w tym samym katalogu!"
    exit 1
fi

# Sprawdź uprawnienia i uruchom z sudo, jeśli to konieczne
if [ "$(id -u)" -ne 0 ]; then
    echo "Ten skrypt wymaga uprawnień roota. Próbuję uruchomić z sudo..."
    sudo bash "${CONFIG_SCRIPT}" -uninstall
else
    bash "${CONFIG_SCRIPT}" -uninstall
fi

echo "Proces deinstalacji zakończony."