#!/bin/bash
check_if_contain(){
    case $1 in
        *"one"*|\
        *"two"*|\
        *"three"*|\
        *"four"*|\
        *"five"*|\
        *"six"*|\
        *"seven"*|\
        *"eight"*|\
        *"nine"*)
        return 0
        ;;
        *)
        return 1
        ;;
    esac
}
COUNT=0
while read -r line; do
    converted=''
    converted_left=''
    converted_right=''
    for ((i = 0; i < ${#line}; i++)); do
        converted_left=$converted_left"${line:i:1}"
        if check_if_contain "$converted_left"; then
            converted_left=$(echo $converted_left | sed -e 's/one/1/g' -e 's/two/2/g' -e 's/three/3/g' -e 's/four/4/g' -e 's/five/5/g' -e 's/six/6/g' -e 's/seven/7/g' -e 's/eight/8/g' -e 's/nine/9/g' )
            converted_left=$converted_left${line:i:${#line}}
            break
        fi
    done
    # echo $converted_left
    for ((i = ${#converted_left}; i >= 0; i--)); do
        converted_right="${converted_left:i:1}"$converted_right
        if check_if_contain "$converted_right"; then
            converted_right=$(echo "$converted_right" | sed -e 's/zero/0/g' -e 's/one/1/g' -e 's/two/2/g' -e 's/three/3/g' -e 's/four/4/g' -e 's/five/5/g' -e 's/six/6/g' -e 's/seven/7/g' -e 's/eight/8/g' -e 's/nine/9/g' )
            converted=${converted_left:0:i}$converted_right
            break
        fi
    done
    if [[ -z $converted ]];then
        converted="$converted_left"
    fi
    digits="${converted//[a-z]/}"
    # echo $digits
    if [[ ${#digits} -eq 1 ]];then
        COUNT=$(echo $COUNT + $digits$digits | bc)
    else
        COUNT=$(echo "$COUNT + $(echo "$digits" | head -c 1)$(echo "$digits" | tail -c 2)" | bc)
    fi
done <1.input
echo $COUNT
