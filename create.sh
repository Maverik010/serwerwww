#!/bin/bash

# Zmienne kolorów
RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m'  # No Color (powrót do normalnego koloru)


# Skrypt do tworzenia projektu serwera WWW
echo -e "${CYAN}Tworzenie projektu serwera WWW${NC}"
echo -e "${YELLOW}Do katalogu assets wrzuć pliki które chcesz udostępnić przez serwer WWW. Zanim zbudujesz sobie \
kontener. Po stworzeniu kontenera będziesz musiał wrzucić pliki poprzez komendę \
docker cp <ścieżka_do_pliku> <nazwa_kontenera>:/var/www/html/assets/${NC}"
sleep 3;
echo -e "${YELLOW}W razie potrzeby możesz też użyć swoich certyfikatów, aczkolwiek te są generowane adhoc.${NC}"
echo -e -n "${CYAN}Czy chcesz kontynuować? (y/n) ${NC}"
read answer

# Sprawdzenie odpowiedzi użytkownika
if [[ "$answer" != "y" ]]; then
    echo -e "${CYAN}Anulowano tworzenie projektu serwera WWW.${NC}"
    exit 1;
fi

# Tworzenie katalogu projektu
if [ ! -d "assets" ]; then
    mkdir assets
    echo -e "${GREEN}Katalog 'assets' został utworzony.${NC}"
else
    echo -e "${RED}Katalog 'assets' już istnieje.${NC}"
fi

echo -e -n "${CYAN}Podaj nazwę kontenera: ${NC}"
read container_name
sleep 1;

if ! su root -c "docker build -t serwerwww ." 2>/dev/null; then
    echo -e "${RED}Błąd: budowanie obrazu Docker nie powiodło się.${NC}"
    exit 1
fi

if ! su root -c "docker run -d -p 80:80 -p 443:443 --name $container_name serwerwww" 2>/dev/null; then
    echo -e "${RED}Błąd: uruchomienie kontenera Docker nie powiodło się.${NC}"
    exit 1
fi

echo -e "${GREEN}Projekt serwera WWW został pomyślnie utworzony i uruchomiony w kontenerze '$container_name'.${NC}"
exit 0;