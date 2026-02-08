#!/bin/bash
# Skrypt włączający automatyczne aktualizacje dla Ultra Defender for Linux

# Upewnij się, że ten skrypt jest uruchamiany z uprawnieniami roota
if [ "$(id -u)" -ne 0 ]; then
    echo "Ten skrypt musi być uruchomiony z uprawnieniami roota (sudo)."
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)" # Poprawiona definicja SCRIPT_DIR
INSTALL_PATH="/opt/udfl" # Docelowa ścieżka instalacji
CRON_FILE="/etc/cron.d/udfl-autoupdate"

echo "Konfigurowanie automatycznych aktualizacji..."

# Kopiowanie plików projektu do INSTALL_PATH
if [ ! -d "${INSTALL_PATH}" ]; then
    echo "Instalowanie plików projektu w ${INSTALL_PATH}..."
    mkdir -p "${INSTALL_PATH}"
fi
# Skopiuj udfl-config.sh i exclusions.txt do /opt/udfl, aby cron mógł je znaleźć
cp "${SCRIPT_DIR}/udfl-config.sh" "${INSTALL_PATH}/"
# Tworzenie pliku exclusions.txt w INSTALL_PATH, jeśli nie istnieje
if [ ! -f "${INSTALL_PATH}/exclusions.txt" ]; then
    cp "${SCRIPT_DIR}/exclusions.txt" "${INSTALL_PATH}/" 
fi


# Tworzenie pliku cron
cat > "${CRON_FILE}" << EOL
# Automatyczna aktualizacja dla Ultra Defender for Linux
# Uruchamia się w każdą niedzielę o 3:00 w nocy
0 3 * * 0 root bash ${INSTALL_PATH}/udfl-config.sh -update > /var/log/udfl-autoupdate.log 2>&1
EOL

chmod 0644 "${CRON_FILE}"

echo "Automatyczne aktualizacje zostały włączone."
echo "Logi z aktualizacji będą dostępne w /var/log/udfl-autoupdate.log"
