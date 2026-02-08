#!/bin/bash
# Skrypt wyłączający automatyczne aktualizacje dla Ultra Defender for Linux

# Upewnij się, że ten skrypt jest uruchamiany z uprawnieniami roota
if [ "$(id -u)" -ne 0 ]; then
    echo "Ten skrypt musi być uruchomiony z uprawnieniami roota (sudo)."
    exit 1
fi

CRON_FILE="/etc/cron.d/udfl-autoupdate"
INSTALL_PATH="/opt/udfl" # Docelowa ścieżka instalacji

echo "Wyłączanie automatycznych aktualizacji..."

if [ -f "${CRON_FILE}" ]; then
    rm "${CRON_FILE}"
    echo "Plik cron został usunięty. Automatyczne aktualizacje są wyłączone."
else
    echo "Automatyczne aktualizacje nie były włączone."
fi

# Opcjonalnie usuń zainstalowane pliki z /opt/udfl, jeśli chcesz całkowicie posprzątać
# read -p "Czy chcesz usunąć zainstalowane pliki UDfL z ${INSTALL_PATH}? [t/N]: " remove_files_choice
# remove_files_choice=$(echo "${remove_files_choice}" | tr '[:upper:]' '[:lower:]')
# if [ "$remove_files_choice" == "t" ] || [ "$remove_files_choice" == "tak" ]; then
#     if [ -d "${INSTALL_PATH}" ]; then
#         rm -rf "${INSTALL_PATH}"
#         echo "Usunięto pliki UDfL z ${INSTALL_PATH}."
#     fi
# fi