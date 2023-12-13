#!/bin/bash
shopt -s lastpipe
DEBUG=1

DEBUG(){
    if [[ DEBUG -eq 0 ]];then
        echo "$@"
    fi
}

MAX(){
    if [[ "$1" -gt "$2" ]];then
        echo "$1"
    else
        echo "$2"
    fi
}

GAMES=0
POWER=0

MAX_RED=12
MAX_GREEN=13
MAX_BLUE=14

while read -r line; do
    game=$(echo $line | cut -d' ' -f 2 | sed -e 's/://g')
    DEBUG $game
    PLAYS=$(echo $line | cut -d':' -f 2 | sed -e 's/;/\n/gm')
    possible=0
    POWER_RED=0
    POWER_GREEN=0
    POWER_BLUE=0
    while read -r PLAY;do
        while read -r COLORS;do
            DEBUG ---
            while read -r COLOR; do
                color_check="$(echo $COLOR | cut -d' ' -f 2)"
                value="$(echo $COLOR | cut -d' ' -f 1)"
                case $color_check in
                    "red")
                        DEBUG "RED: $value"
                        POWER_RED=$(MAX $POWER_RED $value)
                        # DEBUG "Max: $POWER_RED"
                        if [[ "$value" -gt "MAX_RED" ]];then possible=1;fi
                    ;;
                    "green")
                        DEBUG "GREEN: $value"
                        POWER_GREEN=$(MAX $POWER_GREEN $value)
                        # DEBUG "Max: $POWER_GREEN"
                        if [[ "$value" -gt "MAX_GREEN" ]];then possible=1;fi
                    ;;
                    "blue")
                        DEBUG "BLUE: $value"
                        POWER_BLUE=$(MAX $POWER_BLUE $value)
                        # DEBUG "Max: $POWER_BLUE"
                        if [[ "$value" -gt "MAX_BLUE" ]];then possible=1;fi
                    ;;
                esac
            done < <(echo $COLORS | sed -e 's/, /\n/gm')
        done < <(echo "$PLAY")
    done < <(echo "${PLAYS}")
    DEBUG "POWER RED: $POWER_RED"
    DEBUG "POWER GREEN: $POWER_GREEN"
    DEBUG "POWER BLUE: $POWER_BLUE"
    POWER_PLAY=$(( POWER_RED * POWER_GREEN * POWER_BLUE ))
    POWER=$(( POWER + POWER_PLAY ))
    DEBUG "Possible: $possible"
    DEBUG "Power of PLAY: $POWER_PLAY"
    if [[ "$possible" -eq 0 ]]; then
        GAMES=$((GAMES + game))
    fi
done <2.input
echo "Games possible: $GAMES"
echo "Power: $POWER"