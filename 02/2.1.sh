#!/bin/bash
DEBUG=1

DEBUG(){
    if [[ DEBUG -eq 0 ]];then
        echo "$@"
    fi
}

GAMES=0
MAX_RED=12
MAX_GREEN=13
MAX_BLUE=14

while read -r line; do
    game=$(echo $line | cut -d' ' -f 2 | sed -e 's/://g')
    DEBUG $game
    PLAYS=$(echo $line | cut -d':' -f 2 | sed -e 's/;/\n/gm')
    possible=0
    while read -r PLAY;do
        while read -r COLORS;do
            if [[ "$possible" -eq 1 ]]; then break;fi
            shopt -s lastpipe
            DEBUG ---
            while read -r COLOR; do
                color_check="$(echo $COLOR | cut -d' ' -f 2)"
                value="$(echo $COLOR | cut -d' ' -f 1)"
                case $color_check in
                    "red")
                        DEBUG "RED: $value"
                        if [[ "$value" -gt "MAX_RED" ]];then possible=1;break;fi
                    ;;
                    "green")
                        DEBUG "GREEN: $value"
                        if [[ "$value" -gt "MAX_GREEN" ]];then possible=1;break;fi
                    ;;
                    "blue")
                        DEBUG "BLUE: $value"
                        if [[ "$value" -gt "MAX_BLUE" ]];then possible=1;break;fi
                    ;;
                esac
            done < <(echo $COLORS | sed -e 's/, /\n/gm')
        done < <(echo "$PLAY")
    done < <(echo "${PLAYS}")
    DEBUG "Possible: $possible"
    if [[ "$possible" -eq 0 ]]; then
        GAMES=$((GAMES + game))
    fi
done <2.input
echo "Games possible: $GAMES"