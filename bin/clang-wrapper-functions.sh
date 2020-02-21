#!/usr/bin/bash

function run_compilation() {

    compiler=$1
    # intercept compilation, ignore linking
    intercept_compilation=false
    ARGS=()
    IR_FILES=()
    INPUT_ARGS=("$@")
    IGNORE_NEXT_ARG=false
    for ((i=1;i<=$#;i++));
    do
        var=${INPUT_ARGS[$i]}
        if [[ "$var" == "-c" ]]; then
            intercept_compilation=true
        fi
        if [[ ! "$var" == "-o" ]]; then
            #if ! ${IGNORE_NEXT_ARG}; then
                ARGS+=("$var")
            #else
            #    echo "$var"
                #IGNORE_NEXT_ARG=false
            #fi         
        else
            #IGNORE_NEXT_ARG=true
            ARGS+=("$var")
            i=$((i+1)) 
            var=${INPUT_ARGS[$i]}
            dirname=$(dirname -- "$var")
            filename=$(basename -- "$var")
            filename="${filename%.*}"
            IR_FILES+=("${dirname}/${filename}.bc")
            ARGS+=("${dirname}/${filename}.bc")
        fi
    done
    export IFS=' ';
    cflags=($CFLAGS)
    linkflags=($LINKFLAGS)
    if [ "$intercept_compilation" == true ]; then
        shopt -s nocasematch
        ${compiler} "${cflags[@]}" "${@:2}"
        ${compiler} "${cflags[@]}" -emit-llvm "${ARGS[@]}"
    else
        ${compiler} "${linkflags[@]}" "${@:2}"
    fi
}
