        ;; ============================================================
        ;; Program startup
        ;; ============================================================

        org $0801

        ;; BASIC header
        ;; ------------------------------------------------------------
        dw nxl,10
        db $9e,"3399",0
nxl:    dw 0

        ;; Reserve space for tables
        ;; ------------------------------------------------------------
        org $0d47
        ;; Tables end at $0d47/3399 (hence "3399" in BASIC header)

        ;; Program initialization
        ;; ------------------------------------------------------------
        jsr drawmaze
        jsr initsprt
        jsr setupirq
        jsr setupnmi
        jmp gameloop

        ;; Include program modules
        ;; ------------------------------------------------------------
        include macros.asm
        include symbols.asm
        include maths.asm
        include io.asm
        include maze.asm
        include nodes.asm
        include sprites.asm
        include irq.asm
        include nmi.asm
        include gameloop.asm
