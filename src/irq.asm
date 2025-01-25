        ;; ============================================================
        ;; IRQ handler sub-routines
        ;; ============================================================

        ;; Setup handler for raster IRQ.
setupirq:
        sei
        ldbimm $7f, ci1icr
        ldbimm $03, irqmsk ;enable raster IRQ & mob-data collision
        ldbimm $1b, scroly
        ldbimm raslin, raster
        ldwimm procirq, cinv
        cli
        rts

        ;; IRQ handler. Here we handle:
        ;;  - Collisions
        ;;    * between Pac-Man and pellets
        ;;    * between Pac-Man and fruit
        ;;    * between Pac-Man and ghosts
        ;;  - Movement
        ;;    * Updating Pac-Man and ghost sprite coordinates
procirq:
        ;; Read sprite collision registers & save to irqwrd1
        cpbyt spbgcl, irqwrd1
        cpbyt spspcl, irqwrd1+1
        lda npelrem
        bne chkirq              ;don't handle IRQ when no pellets left
        asl vicirq              ;acknowledge IRQ
        jmp sysirq              ;return from interrupt
        
chkirq: lda vicirq
        and #%00000010          ;check for sprite-background collision
        jne bgcol
        lda vicirq
        and #%00000100          ;check for sprite-sprite collision
        jeq fincol

        ;; Handle sprite-sprite collision
spcol:  lda irqwrd1+1           ;read saved sprite-sprite collision register
        and #%00000001          ;only interested if Pac-Man sprite was involved
        jeq fincol
        jsr hidefrt             ;hide the fruit
        jsr scrfrt              ;score the fruit
        jsr printscr            ;print the score
        ;; TODO: Show points earned sprite
        ;; (NMI timer to hide after ~1.5s)
        jmp fincol

        ;; Handle sprite-background collision:
        ;; Assume Pac-Man collision with pellet
bgcol:  jsr findpel             ;find pellet collided with & mark as eaten
        lda irqwrd1+1           ;load pellet address hi-byte
        cmp #$ff                ;pellet found?
        jeq fincol              ;no, do nothing
        ldx #irqblki+4
        jsr isenzr              ;yes, is it an energizer?
        bne :+
        ldx #irqblki+2
        jsr screnzr             ;yes, score it
        jmp rmpel
:       ldx #irqblki+2
        jsr scrpel              ;no, score as regular pellet
rmpel:  ldwptr irqwrd1, 0, irqwrd2
        ldy #spcechr
        jsr printchr            ;erase pellet
        jsr printscr            ;print score
        ldbimm 6, lvlend        ;set number of level end flashes
        dec npelrem             ;decrement pellets remaining
        jsr showfrt             ;conditionally enable bonus fruit
        lda npelrem
        jne fincol
        lda spena
        and #%00000001
        sta spena               ;disable all but Pac-Man's sprite
fincol: lda vicirq
        and #%00000001
        bne rasirq              ;check for raster IRQ
        asl vicirq              ;acknowledge IRQ
        jmp sysirq              ;return from interrupt

        ;; Handle raster IRQ
        ;; Update sprite 0 (Pac-Man) x & y coordinates
rasirq: lda pacrem
        beq finras
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
        bne pds
        dec sp0y
        jmp decrem
pds:    inc sp0y
decrem: dec pacrem
finras: asl vicirq              ;acknowledge IRQ
        jmp sysirq              ;return from interrupt
