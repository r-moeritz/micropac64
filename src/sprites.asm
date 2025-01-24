        ;; ============================================================
        ;; Sprite sub-routines
        ;; ============================================================

        ;; Initialize sprites
initsprt:
        ;; Sprite 0: Pac-Man
        ldbimm sp0loc, sp0ptr   ;set sprite 0 pointer
        lda sp0mem+$3f          ;read byte 63
        and #%00001111          ;mask out hi nybble
        sta sp0col              ;set sprite 0 (Pac-Man) colour        
        lda #pacstnd
        ldx #0
        jsr nodeadr             ;get address of Pac's starting node
        ldbptr wrd1, 0, sp0x    ;set Pac's x loc
        ldbptr wrd1, 1, sp0y    ;set Pac's y loc
        lda #%00000001
        sta spena               ;enable sprite 0 (Pac-Man)
        ;; Init Pac's direction & calc distance between source & target nodes
        ldbimm w, pacdir        ;set Pac's initial direction to west
        ldbimm pacstnd, pacsrc  ;set Pac's starting node as source node
        ldbptr wrd1, w, pactar  ;set western neighbour as target node
        jsr setnodis            ;calculate distance between source & target
        rts

        ;; Convert sprite x loc in .A to char x loc
spx2chx:
        sec
        sbc #spxscog
        diva8
        rts

        ;; Convert sprite y loc in .A to char y loc
spy2chy:
        sec
        sbc #spyscog
        diva8
        rts

        ;; Convert char x loc in .A to sprite x loc
chx2spx:
        mula8
        clc
        adc #spxscog
        rts

        ;; Convert char y loc in .A to sprite y loc
chy2spy:
        mula8
        clc
        adc #spyscog
        rts
