        ;; ============================================================
        ;; NMI handler sub-routines
        ;; ============================================================

        ;; Setup CIA2 timer NMI
setupnmi:
        sei
        lda #$ff
        sta ti2alo
        sta ti2ahi
        ldbimm 2, ti2blo
        ldbimm 0, ti2bhi        ;132 ms (pal)
        ldbimm %00010001, ci2cra
        ldbimm %01010001, ci2crb
        lda ci2icr
        ldbimm %10000010, ci2icr
        ldbimm 0, pacaix        ;init Pac-Man's animation index
        ldbimm 0, powpaix       ;init power pellet animation index
        ldwimm procnmi, nminv
        cli
        rts

        ;; NMI handler. Here we animate the various in-game objects such as:
        ;;  - Pac-Man (in-game and death animations)
        ;;  - Power pellets (phase)
        ;;  - The ghosts (regular & fright mode animations)
procnmi:
        pha
        txa
        pha
        tya
        pha
        lda ci2icr
        and #%00000010
        jeq sysnmi
        
        ;; Animate Pac-Man
        inc pacaix
        ldy pacaix
        ldwimm pacalst, nmiwrd1
        lda (nmiwrd1),y
        cmp #$ff
        beq rstpaca
        adc #sp0loc
        sta sp0ptr
        jmp anipowp
rstpaca:
        ldbimm 0, pacaix
        ldbimm sp0loc, sp0ptr
        
        ;; Animate power pellets
anipowp:
        ldbimm 3, nmiwrd2
        tax                     ;set loop counter (.X) and stash in nmiwrd2 (lo)
        lda powpaix
        beq tic
        dec powpaix
tocloop:
        bmi finnmi
        lda powplst,x           ;load pellet index into .A
        ldx #nmiblki            ;set .X to NMI handler block index
        jsr pelladr             ;load pellet address into nmiwrd1
        ldx nmiwrd2             ;restore .X (loop counter) from nmiwrd2 (lo)
        ldwptr nmiwrd1, 0, nmiwrd2 ;write pellet x,y loc to nmiwrd2 (lo,hi)
        stx nmiwrd1             ;stash loop counter in nmiwrd1 (lo)
        ldy #powpchr            ;load power pellet char into .Y
        ldx #nmiblki+2          ;set .X to NMI handler block hi (nmiwrd2)
        jsr prtchr              ;print power pellet char
        dec nmiwrd1             ;decrement loop counter
        ldx nmiwrd1             ;restore .X (loop counter) from nmiwrd1 (lo)
        jmp tocloop
tic:    inc powpaix
ticloop:
        bmi finnmi
        lda powplst,x           ;load pellet index into .A
        ldx #nmiblki            ;set .X to NMI handler block index
        jsr pelladr             ;load pellet address into nmiwrd1
        ldx nmiwrd2
        ldwptr nmiwrd1, 0, nmiwrd2 ;write pellet x,y loc to nmiwrd2 (lo,hi)
        stx nmiwrd1             ;stash loop counter in nmiwrd1 (lo)
        ldy #spcechr            ;load space char into .Y
        ldx #nmiblki+2          ;set .X to NMI handler block hi (nmiwrd2)
        jsr prtchr              ;print power pellet char
        dec nmiwrd1             ;decrement loop counter
        ldx nmiwrd1             ;restore .X (loop counter) from nmiwrd1 (lo)
        jmp ticloop
finnmi: pla
        tay
        pla
        tax
        pla
        rti
