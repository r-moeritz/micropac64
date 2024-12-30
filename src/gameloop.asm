        ;; ============================================================
        ;; The main game loop
        ;; ============================================================

gameloop:
        jsr readjoy2
        ldx #4
gl0:    ldy #$ff                
gl1:    dey
        bne gl1
        dex
        bne gl0                 ;delay (value in ms?)
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
