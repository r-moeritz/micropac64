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
        ldbimm 0, enzraix               ;init energizer animation index
        ldwimm procnmi, nminv
        cli
        rts

        ;; NMI handler. Here we animate the various in-game objects such as:
        ;;  - Pac-Man (in-game and death animations)
        ;;  - Energizers (phase)
        ;;  - The ghosts (regular, fright, and death animations)
        ;; We also handle timer events such as:
        ;;  - Fruit (appearance and disappearance)
        ;;  - Ghosts switching between scatter & chase mode
procnmi:
        pha
        phx
        phy                             ;push .A, .X, and .Y onto the stack
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
        
        ;; Timer B fired: animate energizers
timbev: lda enzraix
        beq tic
        dec enzraix
        ldy #3
tocloop:
        bmi finnmi
        phy                             ;save loop counter onto stack        
        lda enzrlst,y                   ;load energizer pelltbl index into .A
        ldx #nmiblki
        jsr pelladr                     ;load pellet address into nmiwrd1
        ldy #2
        lda (nmiwrd1),y                 ;load pellet state
        bne :+                          ;has the pellet been eaten?
        ply                             ;yes, next energizer
        dey
        jmp tocloop
:       ldwptr nmiwrd1, 0, nmiwrd2      ;energizer not eaten
        ldy #enzrchr                    
        ldx #nmiblki+2
        jsr printchr                    ;print energizer char
        ply                             ;pop loop counter off the stack
        dey
        jmp tocloop
tic:    inc enzraix
        ldy #3
ticloop:
        bmi finnmi
        phy                             ;push loop counter onto stack
        lda enzrlst,y                   ;load energizer pelltbl index into .A
        ldx #nmiblki
        jsr pelladr                     ;load pellet address into nmiwrd1
        ldwptr nmiwrd1, 0, nmiwrd2
        ldy #spcechr
        ldx #nmiblki+2
        jsr printchr                    ;print space char
        ply                             ;pop loop counter off the stack
        dey
        jmp ticloop
finnmi: ply
        plx
        pla                             ;restore .Y, .X, and .A from stack
        rti
