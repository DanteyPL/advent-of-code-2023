#!/bin/bash
COUNT=0
while read -r line; do
    digits="${line//[a-z]/}"
    if [[ ${#digits} -eq 1 ]];then
        COUNT=$(echo $COUNT + $digits$digits | bc)
    else
        COUNT=$(echo "$COUNT + $(echo "$digits" | head -c 1)$(echo "$digits" | tail -c 2)" | bc)
    fi
done <1.input
echo $COUNT