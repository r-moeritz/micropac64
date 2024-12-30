        ;; ============================================================
        ;; Maze related sub-routines
        ;; ============================================================

        ;; Convert pellet table index to pellet memory address.
        ;; Reads:
        ;;  - .A (pellet table index)
        ;;  - .X (offset to memory block in buf)
        ;; Writes:
        ;;  - Result is stored in word (lo,hi) of buf at offset .X
pelladr:
        jsr mula5               ;multiply pellet index by 5
        clc
        lda buf,x               ;load product (lo)
        adc #<pelltbl           ;add pellet table address (lo)
        sta buf,x               ;write sum (lo)
        inx
        lda buf,x               ;load product (hi)
        adc #>pelltbl           ;add pellet table address (hi)
        sta buf,x               ;write sum (hi)
        rts

        ;; Render the maze & fill it with pellets
drawmaze:
        ;; select vic bank
        lda #3
        ora c2ddra
        sta c2ddra
        lda #$fc
        and ci2pra
        ora #2
        sta ci2pra

        ;; select screen memory loc
        lda #$0f
        and vmcsb
        ora #$30
        sta vmcsb

        ;; select char memory loc
        lda #$f1
        and vmcsb
        sta vmcsb

        ;; set border & background colours
        lda #0
        sta extcol
        sta bgcol0

        ;; populate colour memory
        ldx #0
setcol1:
        lda scnmem,x
        tay
        lda coltab,y
        sta colmem,x
        inx
        cpx #250
        bne setcol1
        ldx #0
setcol2:
        lda scnmem+250,x
        tay
        lda coltab,y
        sta colmem+250,x
        inx
        cpx #250
        bne setcol2
        ldx #0
setcol3:
        lda scnmem+500,x
        tay
        lda coltab,y
        sta colmem+500,x
        inx
        cpx #250
        bne setcol3
        ldx #0
setcol4:
        lda scnmem+750,x
        tay
        lda coltab,y
        sta colmem+750,x
        inx
        cpx #250
        bne setcol4
        jsr filmaze
        rts

        ;; Reset pellet table & fill maze with pellets
filmaze:
        ldbimm 0, wrd2          ;set .A & stash in wrd2 (lo)
filloop:
        ldx #0
        jsr pelladr             ;get pellet address
        ldy #2
        lda (wrd1),y            ;load pellet value
        cmp #$ff                ;check for end pellet marker
        jeq finfil
        lda #1
        sta (wrd1),y            ;set pellet value to 1 (not eaten)
        ldx wrd2                ;restore wrd2 (lo) into .X
        ldwptr wrd1, 0, wrd2    ;store pellet x,y loc in wrd2 (lo,hi)
        stx wrd1                ;stash .X in wrd1 (lo)
        ldx #2
        ldy #pellchr
        jsr prtchr              ;print pellet char (x,y loc in wrd2)
        inc wrd1                ;increment wrd1 (lo)
        cpbyt wrd1, wrd2        ;copy wrd1 (lo) to wrd2 (lo) via .A
        jmp filloop
finfil: rts
