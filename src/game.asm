        ;; ============================================================
        ;; Game-logic related routines
        ;; ============================================================

        ;; Initialize variables when starting a new game
newgame:
        ldbimm maxpell, npelrem
        ldbimm maxmen, nmenrem
        ldbimm 0, lvlnum
        jsr rstscr              ;reset score
        jmp fillmaze            ;fill maze with pellets

        ;; Setup next game level
nextlvl:
        inc lvlnum
        jsr fillmaze
        jsr fillcolmem
        jsr initsprt
        ldbimm maxpell, npelrem
        rts
        
        ;; Main game loop
gameloop:
        lda npelrem             ;check remaining pellets
        bne rdinpt              ;if <> 0 read joystick input
:       ldx #$ff
:       dex
        bne :-                  ;delay
        lda irqtmp              ;check if end level animation finished
        bne :--                 ;no? wait a bit longer
        jsr nextlvl 
rdinpt: jsr readjoy2
        lda #1
        cmp joyx
        beq move
        bcs chky
        ldbimm w, tmp
        jmp chkmov
move:   ldbimm e, tmp
        jmp chkmov
chky:   lda #1
        cmp joyy
        beq movs
        jcs gameloop
        ldbimm n, tmp
        jmp chkmov
movs:   ldbimm s, tmp
chkmov: lda pacrem
        sec
        sbc #3
        jcs chkrvw
        cpbyt tmp, pacnxd
        jmp gameloop
chkrvw: lda pacdir
        cmp #w
        bne chkrve
        lda tmp
        cmp #e
        jne gameloop
        jmp reverse
chkrve: cmp #e
        bne chkrvn
        lda tmp
        cmp #w
        jne gameloop
        jmp reverse
chkrvn: cmp #n
        bne revs
        lda tmp
        cmp #s
        jne gameloop
        jmp reverse
revs:
        lda tmp
        cmp #n
        jne gameloop
reverse:
        sei
        cpbyt tmp, pacdir
        swpbyt pacsrc, pactar
        lda pacdis
        sec
        sbc pacrem
        sta pacrem
        cli
        jmp gameloop
