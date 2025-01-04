        ;; ============================================================
        ;; Program startup
        ;; ============================================================

        org $0801

        ;; BASIC header
        word nxl,10
        byte $9e
        string "2061"
nxl:    word 0

        ;; Program initialization
        jsr initvic
        jsr fillcolmem
        jsr initsprt
        jsr newgame
        jsr setupirq
        jsr setupnmi
        jmp gameloop

        ;; Include program modules
        include macros.asm
        include symbols.asm
        include maths.asm
        include io.asm
        include maze.asm
        include nodes.asm
        include sprites.asm
        include irq.asm
        include nmi.asm
        include game.asm
        include score.asm

        ;; Include tables
        include tables.asm
        
        ;; Include assets
        *=charset
        incbin assets/charset,2

        *=mazegfx
        incbin assets/mazegfx,2

        *=sp0mem
        incbin assets/sprites,2
