#!/usr/bin/env bash

name=micropac64

mkdir -p ./build

vasm6502_oldstyle ./src/startup.asm -cbm-prg -Fbin -chklabels -nocase \
                  -o ./build/startup.prg -L "./build/$name.txt" \
    && exomizer sfx sys -t 64 -o "./build/$name.prg" ./build/startup.prg
