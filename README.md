# Ultra Defender for Linux (UDfL) - Wersja 1.0.0 (Modułowa i Interaktywna)

**Kompleksowa, modułowa i interaktywna ochrona prywatności i bezpieczeństwa dla systemów Linux. Teraz z hartowaniem jądra i integracją z Fail2Ban.**

---

### Spis Treści
1.  [Czym jest Ultra Defender for Linux?](#czym-jest-ultra-defender-for-linux)
2.  [Nowości w wersji 1.0.0](#nowości-w-wersji-100)
3.  [Jak to działa?](#jak-to-działa)
4.  [Wymagania](#wymagania)
5.  [Instalacja i Konfiguracja (Interaktywna)](#instalacja-i-konfiguracja-interaktywna)
6.  [Zarządzanie UDfL (Konfigurator)](#zarządzanie-udfl-konfigurator)
7.  [Plik Wykluczeń (`exclusions.txt`)](#plik-wykluczeń-exclusionstxt)

---

### Czym jest Ultra Defender for Linux?

Ultra Defender for Linux (UDfL) to zaawansowane narzędzie skryptowe Bash zaprojektowane, aby wzmocnić Twoją prywatność i bezpieczeństwo w środowisku Linux. Działa w tle, blokując telemetrię, złośliwe oprogramowanie i mechanizmy śledzące, z minimalnym wpływem na wydajność systemu.

### Nowości w wersji 1.0.0

*   **Modułowa Architektura:** UDfL jest teraz podzielony na niezależne moduły (Hosts, Firewall, Kernel Hardening, Fail2Ban, Telemetry), które możesz włączać i wyłączać niezależnie.
*   **Interaktywny Instalator/Konfigurator:** Domyślnie uruchamia się w trybie interaktywnym, oferując szybką instalację (wszystko domyślnie) lub niestandardową konfigurację z wyborem modułów i dodawaniem wykluczeń.
*   **Konfigurator (`udfl-config.sh`):** Nowe, główne narzędzie do zarządzania UDfL po instalacji, pozwalające na włączanie/wyłączanie modułów i dodawanie/usuwanie wykluczeń z poziomu linii komend.
*   **Hartowanie Jądra Systemu (`sysctl`):** UDfL aktywnie wzmacnia parametry sieciowe jądra Linuksa, aby chronić przed atakami sieciowymi, takimi jak SYN Flood i fałszywymi przekierowaniami ICMP.
*   **Integracja z `fail2ban`:** Jeśli `fail2ban` jest zainstalowany, UDfL automatycznie skonfiguruje go do ochrony usługi SSH, dynamicznie blokując adresy IP, które próbują odgadnąć hasło.

### Jak to działa?

UDfL stosuje wielowarstwowe podejście do ochrony:

-   **Zarządzanie Plikiem `/etc/hosts`:** Blokuje dostęp do tysięcy znanych domen związanych z reklamami, malware i telemetrią.
-   **Inteligentna Konfiguracja Zapory:** Automatycznie wykrywa i konfiguruje Twoją zaporę (`firewalld` lub `ipset`/`iptables`), aby blokować ruch do i z adresów IP o złej reputacji. **Uwaga:** Jeśli używasz `ufw`, UDfL nie zmodyfikuje go, aby uniknąć konfliktów i wymaga jego ręcznego wyłączenia, jeśli chcesz, aby UDfL zarządzał zaporą.
-   **Hartowanie Jądra i Usług:** Wzmacnia jądro systemu i wyłącza znane usługi telemetryczne (np. `whoopsie` w Ubuntu).
-   **Dynamiczna Ochrona (Fail2Ban):** Proaktywnie blokuje ataki brute-force na usługi takie jak SSH.

### Wymagania

Przed instalacją upewnij się, że w Twoim systemie zainstalowane są następujące pakiety. Skrypt UDfL automatycznie sprawdzi ich obecność.
*   `curl` lub `wget`
*   `ipset`
*   `iptables`
*   `fail2ban` (opcjonalne, ale zalecane dla pełnej ochrony)
*   `sysctl`
*   `systemctl` (do zarządzania usługami)
*   `grep`, `sed`, `awk`, `mktemp`, `tee` (standardowe narzędzia Linuksa)

Możesz je zainstalować za pomocą menedżera pakietów swojej dystrybucji, np.:
*   **Debian/Ubuntu:** `sudo apt-get install curl ipset iptables fail2ban`
*   **Fedora/CentOS:** `sudo dnf install curl ipset iptables fail2ban`

### Instalacja i Konfiguracja (Interaktywna)

1.  **Pobierz i rozpakuj:**
    *   Pobierz folder `instalator` z tego repozytorium na swój system Linux.
    *   Otwórz terminal wewnątrz rozpakowanego folderu `instalator`.
2.  **Nadaj uprawnienia do wykonania:**
    ```bash
    chmod +x install.sh
    chmod +x udfl-config.sh
    ```
3.  **Uruchom instalator:**
    ```bash
    ./install.sh
    ```
    Skrypt poprosi o hasło `sudo`. Instalator rozpocznie się w trybie interaktywnym, oferując Ci wybór:
    *   **Szybka instalacja:** Zainstaluje wszystkie zalecane moduły z domyślnymi ustawieniami.
    *   **Niestandardowa konfiguracja:** Pozwoli Ci wybrać, które moduły chcesz zainstalować i ewentualnie dodać wykluczenia.

### Zarządzanie UDfL (Konfigurator)

Po instalacji możesz zarządzać modułami UDfL za pomocą głównego skryptu konfiguracyjnego `udfl-config.sh`.
**Uruchamiaj zawsze z `sudo`!**

*   **Sprawdzenie statusu modułów:**
    ```bash
    sudo ./udfl-config.sh status
    ```
*   **Włączanie/wyłączanie modułów:**
    ```bash
    sudo ./udfl-config.sh enable <nazwa_modułu> # np. hosts, firewall, kernel, fail2ban, telemetry
    sudo ./udfl-config.sh disable <nazwa_modułu>
    ```
*   **Dodawanie/usuwanie wykluczeń:**
    ```bash
    sudo ./udfl-config.sh add-exclusion <domena_lub_IP>
    sudo ./udfl-config.sh remove-exclusion <domena_lub_IP>
    ```
*   **Pełna deinstalacja UDfL:**
    ```bash
    sudo ./udfl-config.sh uninstall
    ```
*   **Aktualizacja list (używane przez cron):**
    ```bash
    sudo ./udfl-config.sh update
    ```

### Plik Wykluczeń (`exclusions.txt`)

Jeśli UDfL zablokuje stronę lub usługę, z której chcesz korzystać, możesz dodać wyjątek. Plik `exclusions.txt` znajduje się w `C:\Projekty\UDfL\kod\`.

1.  Otwórz plik `/etc/udfl/exclusions.txt` (po instalacji) w dowolnym edytorze tekstu (np. `sudo nano /etc/udfl/exclusions.txt`).
2.  Dodaj domenę lub adres IP, który chcesz odblokować, w nowej linii.
3.  Linie zaczynające się od `#` są ignorowane.

**Przykład:**
```
# Odblokuj example.com, ponieważ go potrzebuję
example.com
1.2.3.4
```
Po zapisaniu zmian, użyj konfiguratora, aby zastosować zmiany: `sudo ./udfl-config.sh enable hosts` (nawet jeśli hosts jest już włączony, to przeładuje listę z nowymi wykluczeniami).