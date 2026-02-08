# Ultra Defender for Linux (UDfL) - Wersja 1.1.0

**Kompleksowa, modułowa i interaktywna ochrona prywatności i bezpieczeństwa dla systemów Linux, teraz z walidacją danych, trybem audit i zaawansowanym zarządzaniem.**

---

### Spis Treści
1.  [Czym jest Ultra Defender for Linux?](#czym-jest-ultra-defender-for-linux)
2.  [Główne Cechy Wersji 1.1.0](#główne-cechy-wersji-110)
3.  [Jak to działa?](#jak-to-działa)
4.  [Wymagania](#wymagania)
5.  [Instalacja i Konfiguracja (Interaktywna)](#instalacja-i-konfiguracja-interaktywna)
6.  [Zarządzanie UDfL (Konfigurator)](#zarządzanie-udfl-konfigurator)
7.  [Plik Wykluczeń (`exclusions.txt`)](#plik-wykluczeń-exclusionstxt)
8.  [Zaawansowana Konfiguracja](#zaawansowana-konfiguracja)

---

### Czym jest Ultra Defender for Linux?

Ultra Defender for Linux (UDfL) to zaawansowane narzędzie skryptowe Bash zaprojektowane, aby wzmocnić Twoją prywatność i bezpieczeństwo w środowisku Linux. Działa w tle, blokując telemetrię, złośliwe oprogramowanie i mechanizmy śledzące, z minimalnym wpływem na wydajność systemu.

### Główne Cechy Wersji 1.1.0

*   **Tryb Audit (`--audit`):** Umożliwia symulację instalacji i sprawdzenie, jakie zmiany zostałyby wprowadzone, bez faktycznego modyfikowania systemu.
*   **Walidacja Danych:** Sprawdza poprawność domen i adresów IP dodawanych do listy wykluczeń.
*   **Zaawansowane Zarządzanie:** Pozwala na dodawanie i usuwanie wykluczeń bezpośrednio z linii komend.
*   **Konfiguracja w Pliku:** Umożliwia zaawansowanym użytkownikom zmianę źródeł list blokad w pliku konfiguracyjnym.
*   **Modułowa Architektura, Interaktywny Instalator, Hartowanie Jądra i Integracja z `fail2ban`** (jak w poprzedniej wersji).

### Jak to działa?

UDfL stosuje wielowarstwowe podejście do ochrony:

-   **Zarządzanie Plikiem `/etc/hosts`:** Blokuje dostęp do tysięcy znanych domen.
-   **Inteligentna Konfiguracja Zapory:** Automatycznie wykrywa i konfiguruje `firewalld` lub `ipset`/`iptables`.
-   **Hartowanie Jądra i Usług:** Wzmacnia jądro systemu i wyłącza usługi telemetryczne.
-   **Dynamiczna Ochrona (Fail2Ban):** Proaktywnie blokuje ataki brute-force na SSH.

### Wymagania

Przed instalacją upewnij się, że w Twoim systemie zainstalowane są następujące pakiety:
*   `curl` lub `wget`, `ipset`, `iptables`, `fail2ban` (opcjonalne), `sysctl`, `systemctl`, `grep`, `sed`, `awk`, `mktemp`, `tee`.

### Instalacja i Konfiguracja (Interaktywna)

1.  Pobierz folder `instalator` i otwórz w nim terminal.
2.  Nadaj uprawnienia: `chmod +x install.sh && chmod +x udfl-config.sh`
3.  Uruchom instalator: `./install.sh`
    Instalator uruchomi się w trybie interaktywnym, oferując **Szybką instalację** lub **Niestandardową konfigurację**.

### Zarządzanie UDfL (Konfigurator)

Po instalacji możesz zarządzać modułami UDfL za pomocą `udfl-config.sh`. **Uruchamiaj zawsze z `sudo`!**

*   **Sprawdzenie statusu:** `sudo ./udfl-config.sh status`
*   **Włączanie/wyłączanie modułów:** `sudo ./udfl-config.sh enable <moduł>` lub `disable <moduł>`
*   **Dodawanie/usuwanie wykluczeń:** `sudo ./udfl-config.sh add-exclusion <domena/IP>` lub `remove-exclusion <domena/IP>`
*   **Pełna deinstalacja:** `sudo ./udfl-config.sh uninstall`
*   **Tryb Audit:** `sudo ./udfl-config.sh --audit`

### Plik Wykluczeń (`exclusions.txt`)

Plik z wykluczeniami znajduje się teraz w `/etc/udfl/exclusions.txt`. Możesz go edytować ręcznie (np. `sudo nano /etc/udfl/exclusions.txt`) lub używać poleceń `add-exclusion`/`remove-exclusion`. Po każdej zmianie należy ponownie zastosować konfigurację modułów, np. przez `sudo ./udfl-config.sh enable hosts`.

### Zaawansowana Konfiguracja

Możesz modyfikować źródła list blokad, edytując plik `/etc/udfl/config.conf`. Po zmianie adresów URL, uruchom ponownie instalację, aby pobrać dane z nowych źródeł.