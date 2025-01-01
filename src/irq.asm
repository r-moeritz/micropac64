        ;; ============================================================
        ;; IRQ handler sub-routines
        ;; ============================================================

        ;; Setup handler for raster IRQ.
setupirq:
        sei
        ldbimm $7f, ci1icr
        ldbimm 1, irqmsk
        ldbimm $1b, scroly
        ldbimm raslin, raster
        ldwimm procirq, cinv
        cli
        rts

        ;; IRQ handler. Here we implement logic for events such as:
        ;;  - Pac-Man's movement (player controlled but we need to update distance
        ;;    remaining, set next target on reaching target node, etc.)
        ;;  - Pac-Man's dying & updating remaining lives
        ;;  - Ghosts going into/out of fright mode, or being eaten
procirq:
        lda spbgcl
        and #%00000001
        beq chkrem
        ;; Collision detected between Pac-Man sprite and background.
        ;; Must be a pellet since fruit and ghosts are sprites!
        ;; TODO:
        ;;  1. Get pellet x,y loc
        ;;  2. Erase pellet (print spcechar to pellet x,y loc)
        ;;  3. Lookup pellet by x,y loc
        ;;  4. Is it a power pellet? (state=2)
        ;;  4.a. Yes, add 50 pts to player's score
        ;;  4.b. No, add 10 pts to player's score
        ;;  5. Mark pellet as eaten (set state to 0)
chkrem: lda pacrem
        beq setnsrc
        lda pacdir
        cmp #w
        bne chkpde
        dec sp0x
        jmp decrem
chkpde: cmp #e
        bne chkpdn
        inc sp0x
        jmp decrem
chkpdn: cmp #n
        bne pdsouth
        dec sp0y
        jmp decrem
pdsouth:
        inc sp0y
decrem: dec pacrem
        lda pacrem
        beq setnsrc
        jmp finirq
setnsrc:
        cpbyt pactar, pacsrc    ;set target node as new source node
        ldx #irqblki
        jsr nodeadr             ;load node address into irqwrd1
        ldbptr irqwrd1, 0, sp0x ;store node x loc into sp0x
        ldbptr irqwrd1, 1, sp0y ;store node y loc into sp0y
        ldy pacnxd
        beq chkcon
        lda (irqwrd1),y
        cmp #$ff
        beq chkcon
        sta pactar
        sty pacdir
        jsr setnodis
        jmp finirq
chkcon: ldy pacdir
        lda (irqwrd1),y
        cmp #$ff
        beq finirq
        sta pactar
        jsr setnodis
finirq: ldbimm 0, pacnxd
        ldbimm 1, vicirq        ;acknowledge VIC IRQ
        jmp sysirq
