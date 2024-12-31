#!/usr/bin/env bash

name=micro-pac
vasm6502_oldstyle ./src/startup.asm -cbm-prg -Fbin -chklabels -nocase \
                  -o ./build/startup.prg -L "./build/$name.txt" \
    && exomizer sfx sys -t 64 -o "./build/$name.prg" ./build/startup.prg
