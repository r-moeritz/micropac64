#!/usr/bin/env bash

name=micro-pac
vasm6502_oldstyle ./src/startup.asm -cbm-prg -Fbin -chklabels -nocase -o "./build/$name.prg" -L "./build/$name.txt"
