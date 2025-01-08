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
        ldbimm w, wrd2
        jmp chkmov
move:   ldbimm e, wrd2
        jmp chkmov
chky:   lda #1
        cmp joyy
        beq movs
        jcs gameloop
        ldbimm n, wrd2
        jmp chkmov
movs:   ldbimm s, wrd2
chkmov: lda pacrem
        sec
        sbc #3
        jcs chkrvw
        cpwrd wrd2, pacnxd
        jmp gameloop
chkrvw: lda pacdir
        cmp #w
        bne chkrve
        lda wrd2
        cmp #e
        jne gameloop
        jmp reverse
chkrve: cmp #e
        bne chkrvn
        lda wrd2
        cmp #w
        jne gameloop
        jmp reverse
chkrvn: cmp #n
        bne revs
        lda wrd2
        cmp #s
        jne gameloop
        jmp reverse
revs:
        lda wrd2
        cmp #n
        jne gameloop
reverse:
        sei
        cpbyt wrd2, pacdir
        swpbyt pacsrc, pactar
        lda pacdis
        sec
        sbc pacrem
        sta pacrem
        cli
        jmp gameloop
