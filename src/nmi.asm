        ;; ============================================================
        ;; NMI handler sub-routines
        ;; ============================================================

        ;; Setup handler for CIA2 timer NMI.
setupnmi:
        sei
        lda #$ff
        sta ti2alo
        sta ti2ahi                      ;timer A fires every 66.5ms (PAL)
        ldbimm 5, ti2blo
        ldbimm 0, ti2bhi                ;timer B fires every 332.5ms (PAL)
        ldbimm %00010001, ci2cra
        ldbimm %01010001, ci2crb
        lda ci2icr
        ldbimm %10000011, ci2icr        ;allow interrupts from both timers
        ldbimm 0, pacaix                ;init Pac-Man's animation index
        ldbimm 0, powpaix               ;init power pellet animation index
        ldwimm procnmi, nminv
        cli
        rts

        ;; NMI handler. Here we animate the various in-game objects such as:
        ;;  - Pac-Man (in-game and death animations)
        ;;  - Power pellets (phase)
        ;;  - The ghosts (regular, fright, and death animations)
        ;; We also handle timer events such as:
        ;;  - Fruit (appearance and disappearance)
        ;;  - Ghosts switching between scatter & chase mode
procnmi:
        pha
        txa
        pha
        tya
        pha                             ;push .X, .Y, and .A onto the stack
        lda ci2icr
        tay
        and #%00000010
        jne timbev
        tya
        and #%00000001
        jeq sysnmi
        
        ;; Timer A fired: animate Pac-Man
timaev: inc pacaix
        ldy pacaix
        ldwimm pacalst, nmiwrd1
        lda (nmiwrd1),y
        cmp #$ff                        ;reached end of animation?
        beq rstpaca                     ;yes, restart animation
        adc #sp0loc
        sta sp0ptr
        jmp finnmi
rstpaca:
        ldbimm 0, pacaix
        ldbimm sp0loc, sp0ptr
        jmp finnmi
        
        ;; Timer B fired: animate power pellets
timbev: ldbimm 3, nmiwrd3               ;stash loop counter in nmiwrd3 (lo)
        tax                     
        lda powpaix
        beq tic
        dec powpaix
tocloop:
        bmi finnmi
        lda powplst,x                   ;load pellet index into .A
        ldx #nmiblki                    ;set .X to NMI handler mem block index
        jsr pelladr                     ;load pellet address into nmiwrd1
        ldwptr nmiwrd1, 0, nmiwrd2      ;write pellet scrn mem offset to nmiwrd2
        ldy #powpchr                    ;load power pellet char into .Y
        ldx #nmiblki+2                  ;set .X to index of nmiwrd2
        jsr prtchr                      ;print power pellet char
        dec nmiwrd3                     ;decrement loop counter
        ldx nmiwrd3                     ;restore loop counter from nmiwrd3 (lo)
        jmp tocloop
tic:    inc powpaix
ticloop:
        bmi finnmi
        lda powplst,x                   ;load pellet index into .A
        ldx #nmiblki                    ;set .X to NMI handler mem block index
        jsr pelladr                     ;load pellet address into nmiwrd1
        ldwptr nmiwrd1, 0, nmiwrd2      ;write pellet scrn mem offset to nmiwrd2
        ldy #spcechr                    ;load space char into .Y
        ldx #nmiblki+2                  ;set .X to index of nmiwrd2
        jsr prtchr                      ;print power pellet char
        dec nmiwrd3                     ;decrement loop counter
        ldx nmiwrd3                     ;restore loop counter from nmiwrd3 (lo)
        jmp ticloop
finnmi: pla
        tay
        pla
        tax
        pla                             ;restore .Y .X and .A from stack
        rti
