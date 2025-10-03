#!/bin/bash

# peek - Zeigt einen schnellen Preview von Dateien und Verzeichnissen

PEEK_VERSION="2.0"
FAVORITES_FILE="$HOME/.peek_favorites"

# Farben
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
GRAY='\033[0;90m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Hilfe anzeigen
show_help() {
    echo -e "${CYAN}peek v${PEEK_VERSION}${NC} - Smart File Previewer"
    echo ""
    echo "Usage: peek [FILE/DIR] [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -l, --lines N    Zeige N Zeilen bei Dateien (default: 20)"
    echo "  -s, --sort       Sortiere nach: name, size, date (default: name)"
    echo "  -r, --reverse    Umgekehrte Sortierung"
    echo "  -f, --fav        Speichere als Favorite"
    echo "  -F, --favorites  Liste alle Favorites"
    echo "  -d, --delfav N   Lösche Favorite #N"
    echo "  --stats          Zeige Verzeichnis-Statistiken"
    echo "  -h, --help       Zeige diese Hilfe"
    echo ""
    echo "Ohne Argument: zeigt aktuelles Verzeichnis"
}

# Favorites verwalten
add_favorite() {
    local path=$(realpath "$1")
    if [ ! -e "$path" ]; then
        echo -e "${RED}✗${NC} Pfad existiert nicht!"
        return 1
    fi
    
    if [ -f "$FAVORITES_FILE" ] && grep -Fxq "$path" "$FAVORITES_FILE"; then
        echo -e "${YELLOW}⚠️${NC} Bereits als Favorite gespeichert!"
        return 0
    fi
    
    echo "$path" >> "$FAVORITES_FILE"
    echo -e "${GREEN}★${NC} Favorite gespeichert: ${CYAN}$path${NC}"
}

list_favorites() {
    if [ ! -f "$FAVORITES_FILE" ] || [ ! -s "$FAVORITES_FILE" ]; then
        echo -e "${YELLOW}Keine Favorites gespeichert${NC}"
        echo "Tipp: Nutze 'peek /path -f' um einen Favorite zu speichern"
        return
    fi
    
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}★ Deine Favorites${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    local i=1
    while IFS= read -r fav; do
        if [ -e "$fav" ]; then
            if [ -d "$fav" ]; then
                echo -e "${GREEN}$i)${NC} ${BLUE}📁 $fav${NC}"
            else
                echo -e "${GREEN}$i)${NC} ${GRAY}📄 $fav${NC}"
            fi
        else
            echo -e "${GREEN}$i)${NC} ${RED}✗ $fav${NC} ${GRAY}(nicht gefunden)${NC}"
        fi
        ((i++))
    done < "$FAVORITES_FILE"
    
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

delete_favorite() {
    local num="$1"
    
    if [ ! -f "$FAVORITES_FILE" ]; then
        echo -e "${RED}✗${NC} Keine Favorites vorhanden"
        return 1
    fi
    
    local total=$(wc -l < "$FAVORITES_FILE")
    if [ "$num" -lt 1 ] || [ "$num" -gt "$total" ]; then
        echo -e "${RED}✗${NC} Ungültige Nummer (1-$total)"
        return 1
    fi
    
    local deleted=$(sed -n "${num}p" "$FAVORITES_FILE")
    sed -i "${num}d" "$FAVORITES_FILE" 2>/dev/null || sed -i '' "${num}d" "$FAVORITES_FILE"
    echo -e "${GREEN}✓${NC} Favorite gelöscht: ${GRAY}$deleted${NC}"
}

# Icon für Datei/Ordner
get_icon() {
    local name="$1"
    local perms="$2"
    
    if [[ $perms == d* ]]; then
        echo "📁"
    elif [[ $perms == l* ]]; then
        echo "🔗"
    elif [[ $perms == *x* ]]; then
        echo "⚙️ "
    else
        case "$name" in
            *.sh|*.bash) echo "📜" ;;
            *.py) echo "🐍" ;;
            *.js|*.ts|*.jsx|*.tsx) echo "📦" ;;
            *.java) echo "☕" ;;
            *.cpp|*.c|*.h) echo "⚡" ;;
            *.rs) echo "🦀" ;;
            *.go) echo "🐹" ;;
            *.txt|*.md|*.markdown) echo "📝" ;;
            *.json|*.xml|*.yaml|*.yml) echo "📋" ;;
            *.jpg|*.jpeg|*.png|*.gif|*.svg) echo "🖼️ " ;;
            *.mp4|*.avi|*.mkv|*.mov) echo "🎬" ;;
            *.mp3|*.wav|*.flac|*.ogg) echo "🎵" ;;
            *.zip|*.tar|*.gz|*.rar|*.7z) echo "📦" ;;
            *.pdf) echo "📕" ;;
            *.doc|*.docx) echo "📘" ;;
            *.xls|*.xlsx) echo "📗" ;;
            *.git*) echo "🔧" ;;
            *) echo "📄" ;;
        esac
    fi
}

# Farbe für Datei/Ordner
get_color() {
    local name="$1"
    local perms="$2"
    
    if [[ $perms == d* ]]; then
        echo "$BLUE"
    elif [[ $perms == l* ]]; then
        echo "$CYAN"
    elif [[ $perms == *x* ]]; then
        echo "$GREEN"
    else
        case "$name" in
            *.sh|*.bash|*.py|*.js|*.ts) echo "$GREEN" ;;
            *.jpg|*.png|*.gif|*.svg) echo "$MAGENTA" ;;
            *.zip|*.tar|*.gz) echo "$RED" ;;
            .*) echo "$GRAY" ;;
            *) echo "$NC" ;;
        esac
    fi
}

# Verzeichnis Statistiken
show_stats() {
    local dir="$1"
    local total_files=$(find "$dir" -maxdepth 1 -type f | wc -l)
    local total_dirs=$(find "$dir" -maxdepth 1 -type d | wc -l)
    local total_size=$(du -sh "$dir" 2>/dev/null | cut -f1)
    local hidden=$(ls -A "$dir" | grep "^\." | wc -l)
    
    echo -e "${CYAN}┌─ Statistiken ─────────────────────────────┐${NC}"
    echo -e "${CYAN}│${NC} 📁 Ordner: ${BOLD}$((total_dirs - 1))${NC}"
    echo -e "${CYAN}│${NC} 📄 Dateien: ${BOLD}$total_files${NC}"
    echo -e "${CYAN}│${NC} 👻 Versteckt: ${BOLD}$hidden${NC}"
    echo -e "${CYAN}│${NC} 💾 Größe: ${BOLD}$total_size${NC}"
    echo -e "${CYAN}└───────────────────────────────────────────┘${NC}"
}

# Verzeichnis als Grid anzeigen (wie ls aber schöner)
show_directory() {
    local dir="$1"
    local sort_mode="$2"
    local reverse="$3"
    
    # Terminal-Breite ermitteln
    local term_width=$(tput cols)
    local max_name_length=0
    
    # Dateien sammeln und sortieren
    local -a files=()
    local sort_cmd="sort"
    
    case "$sort_mode" in
        size)
            while IFS= read -r line; do
                files+=("$line")
            done < <(ls -lAh "$dir" | tail -n +2 | sort -k5 -h $([[ "$reverse" == "true" ]] && echo "-r"))
            ;;
        date)
            while IFS= read -r line; do
                files+=("$line")
            done < <(ls -lAht "$dir" | tail -n +2 $([[ "$reverse" == "true" ]] || echo "| tac"))
            ;;
        *)
            while IFS= read -r line; do
                files+=("$line")
            done < <(ls -lAh "$dir" | tail -n +2 $([[ "$reverse" == "true" ]] && echo "| tac"))
            ;;
    esac
    
    # Längsten Namen finden
    for line in "${files[@]}"; do
        local name=$(echo "$line" | awk '{print $NF}')
        local len=${#name}
        [[ $len -gt $max_name_length ]] && max_name_length=$len
    done
    
    # Spaltenbreite: Icon (3) + Name + Size (8) + Padding (3)
    local col_width=$((max_name_length + 14))
    local cols=$((term_width / col_width))
    [[ $cols -lt 1 ]] && cols=1
    
    local total=$(ls -1A "$dir" | wc -l)
    
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}📁 $(basename "$dir")${NC} ${GRAY}($total items)${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    local count=0
    for line in "${files[@]}"; do
        local perms=$(echo "$line" | awk '{print $1}')
        local size=$(echo "$line" | awk '{print $5}')
        local name=$(echo "$line" | awk '{print $NF}')
        
        local icon=$(get_icon "$name" "$perms")
        local color=$(get_color "$name" "$perms")
        
        # Name auf maximale Länge kürzen wenn nötig
        local display_name="$name"
        if [ ${#name} -gt $((max_name_length)) ]; then
            display_name="${name:0:$((max_name_length-2))}…"
        fi
        
        # Formatierte Ausgabe
        printf "${icon} ${color}%-${max_name_length}s${NC} ${GRAY}%6s${NC}  " "$display_name" "$size"
        
        ((count++))
        if [ $((count % cols)) -eq 0 ]; then
            echo ""
        fi
    done
    
    # Neue Zeile wenn letzte Zeile nicht voll
    [[ $((count % cols)) -ne 0 ]] && echo ""
}

# Dateiinfo anzeigen
show_file_info() {
    local file="$1"
    local size=$(du -h "$file" 2>/dev/null | cut -f1)
    local modified=$(stat -c %y "$file" 2>/dev/null | cut -d'.' -f1 || stat -f "%Sm" "$file" 2>/dev/null)
    local perms=$(stat -c %A "$file" 2>/dev/null || stat -f "%Sp" "$file" 2>/dev/null)
    
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}📄 $(basename "$file")${NC}"
    echo -e "${GRAY}Size: $size | Modified: $modified | Perms: $perms${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

# Datei anzeigen mit Syntax-Highlighting
show_file() {
    local file="$1"
    local lines="$2"
    
    show_file_info "$file"
    
    if file "$file" | grep -q "text"; then
        head -n "$lines" "$file" | while IFS= read -r line; do
            if [[ $line =~ ^[[:space:]]*# ]] || [[ $line =~ ^[[:space:]]*// ]]; then
                echo -e "${GRAY}$line${NC}"
            elif [[ $line =~ \".*\" ]] || [[ $line =~ \'.*\' ]]; then
                echo -e "${GREEN}$line${NC}"
            elif [[ $line =~ (function|def|class|if|else|for|while|return|import|from) ]]; then
                echo -e "${MAGENTA}$line${NC}"
            else
                echo "$line"
            fi
        done
        
        local total_lines=$(wc -l < "$file")
        if [ $total_lines -gt "$lines" ]; then
            echo -e "${GRAY}... $(($total_lines - $lines)) weitere Zeilen${NC}"
        fi
    else
        echo -e "${YELLOW}⚠️  Binärdatei - kein Preview verfügbar${NC}"
        file "$file"
    fi
}

# Standard-Werte
LINES=20
TARGET="."
ADD_FAV=false
SORT_MODE="name"
REVERSE=false
SHOW_STATS=false

# Argumente parsen
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        -l|--lines)
            LINES="$2"
            shift 2
            ;;
        -s|--sort)
            SORT_MODE="$2"
            shift 2
            ;;
        -r|--reverse)
            REVERSE=true
            shift
            ;;
        -f|--fav)
            ADD_FAV=true
            shift
            ;;
        -F|--favorites)
            list_favorites
            exit 0
            ;;
        -d|--delfav)
            delete_favorite "$2"
            exit 0
            ;;
        --stats)
            SHOW_STATS=true
            shift
            ;;
        *)
            TARGET="$1"
            shift
            ;;
    esac
done

# Wenn Target nicht existiert
if [ ! -e "$TARGET" ]; then
    echo -e "${RED}✗${NC} '$TARGET' existiert nicht!"
    exit 1
fi

# Main Logic
if [ "$SHOW_STATS" = true ] && [ -d "$TARGET" ]; then
    show_stats "$TARGET"
    echo ""
fi

if [ -d "$TARGET" ]; then
    show_directory "$TARGET" "$SORT_MODE" "$REVERSE"
elif [ -f "$TARGET" ]; then
    show_file "$TARGET" "$LINES"
else
    echo -e "${RED}✗${NC} Unbekannter Dateityp"
    exit 1
fi

# Favorite hinzufügen wenn gewünscht
if [ "$ADD_FAV" = true ]; then
    add_favorite "$TARGET"
fi

echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
