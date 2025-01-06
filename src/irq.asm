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
        ;;  - Pac-Man's movement (player controlled but we need to 
        ;;    update sprite coordinates, distance remaining to target
        ;;     node, set new target on reaching target node, etc.)
        ;;  - Pac-Man's dying & updating remaining lives
        ;;  - Ghosts going into/out of fright mode, or being eaten
procirq:
        lda spbgcl              ;check for collision
        and #%00000001          ;between sprite 0 (Pac-Man) and background
        beq chkrem
        
        ;; Collision detected between Pac-Man sprite and background.
        ;; Must be a pellet since fruit and ghosts are sprites!
        jsr findpel             ;find pellet collided with & mark as eaten
        lda irqwrd1+1           ;load pellet address hi-byte
        cmp #$ff                ;pellet found?
        jeq chkrem              ;nope, check remaining distance
        ldx #irqblki+4
        jsr isenzr              ;is it an energizer?
        bne :+
        ldx #irqblki+2
        jsr screnzr             ;yes, score it
        jmp rmpel
:       ldx #irqblki+2
        jsr scrpell             ;no, score as regular pellet
rmpel:  ldwptr irqwrd1, 0, irqwrd2
        ldy #spcechr
        jsr printchr            ;erase pellet
        dec npelrem             ;decrement remaining pellet count
        jsr printscr              ;print score
        jmp finirq
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
        cmp #gsthmnd
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
