        ;; ============================================================
        ;; NMI handler sub-routines
        ;; ============================================================

        ;; Setup handler for CIA2 timer NMI.
setupnmi:
        sei
        lda #$ff
        sta ti2alo
        sta ti2ahi                      ;timer A fires every 66.5ms (PAL)
        ldbimm 4, ti2blo
        ldbimm 0, ti2bhi                ;timer B fires every 266ms (PAL)
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
        php
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
timaev: lda pacrem
        jeq finnmi                      ;don't animate Pac-Man if he's not moving
        inc pacaix
        ldy pacaix
        cpy #6                          ;past final animation?
        bcc :+
        ldbimm 0, pacaix                ;yes, reset animation index
        tay
:       lda pacdir                      ;no, check Pac-Man's direction
        cmp #n
        beq :+
        cmp #s
        beq :++
        cmp #w
        beq :+++
        ldwimm pacalste, nmiwrd1        ;east
        jmp ldanim
:       ldwimm pacalstn, nmiwrd1        ;north
        jmp ldanim
:       ldwimm pacalsts, nmiwrd1        ;south
        jmp ldanim
:       ldwimm pacalstw, nmiwrd1        ;west
ldanim: clc
        lda (nmiwrd1),y
        adc #sp0loc
        sta sp0ptr
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
        plp
        rti
