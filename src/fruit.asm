        ;; ============================================================
        ;; Fruit related sub-routines
        ;; ============================================================

        ;; Get fruit bonus points by level number
        ;; Reads:
        ;;  - lvlnum
        ;;  - frtsptbl
        ;; Write:
        ;;  - .Y (points lo-byte)
        ;;  - .A (points hi-byte)
        ;; Clobbers:
        ;;  - .X
lvlfrtpts:
        ldx #0
:       lda frtsptbl,x
        cmp lvlnum
        beq :++
        bcs :+
        inx
        inx
        inx
        inx
        inx
        inx
        jmp :-
:       ldx #maxftx
:       inx
        inx
        inx
        inx
        lda frtsptbl,x          ;load points (lo)
        tay
        inx
        lda frtsptbl,x          ;load points (hi)
        rts

        ;; Get fruit sprite index by level number
        ;; Reads:
        ;;  - lvlnum
        ;;  - frtsptbl
        ;; Writes:
        ;;  - .A (fruit sprite index)
        ;; Clobbers:
        ;;  - .X
lvlfrtspix:
        ldx #0
:       lda frtsptbl,x
        cmp lvlnum
        beq :++
        bcs :+                  ;found row for level?
        inx
        inx
        inx
        inx
        inx
        inx
        jmp :-                  ;no, keep looking
:       ldx #maxftx
:       inx                     ;yes...
        lda frtsptbl,x          ;...load sprite index
        rts

        ;; Get fruit sprite shape memory offset
        ;; Reads:
        ;;  - lvlnum
        ;;  - frtsptbl
        ;; Writes:
        ;;  - .Y (offset lo byte)
        ;;  - .A (offset hi byte)
        ;; Clobbers:
        ;;  - .X
lvlfrtspof:
        ldx #0
:       lda frtsptbl,x
        cmp lvlnum
        beq :++
        bcs :+                  ;found row for level?
        inx
        inx
        inx
        inx
        inx
        inx
        jmp :-                  ;no, keep looking
:       ldx #maxftx
:       inx                     ;yes...
        inx
        lda frtsptbl,x          ;load offset (lo)
        tay
        inx
        lda frtsptbl,x          ;load offset (hi)
        rts
        
        ;; Check number of pellets remaining and enable fruit if
        ;; - 130 pellets remaining OR
        ;; - 55 pellets remaining
        ;; May only be called from IRQ handler!
        ;; Clobbers:
        ;;  - irqwrd1
showfrt:
        lda npelrem
        cmp #130
        beq :+
        cmp #55
        beq :+
        rts
        ;; Set sprite pointers
:       jsr lvlfrtspix          ;find fruit sprite index for level, store in .A
        clc
        adc #sp0loc
        sta sp0ptr+1            ;write to sprite 1 pointer
        ina                     ;increment .A
        sta sp0ptr+2            ;write to sprite 2 pointer
        ;; Set sprite colours
        jsr lvlfrtspof          ;find fruit sprite memory offset
        sty irqwrd1             ;save offset (lo) onto irqwrd (lo)
        sta irqwrd1+1           ;save offset (hi) onto irqwrd (hi)
        adcwimm sp0mem, irqwrd1
        ldy #$3f                ;index to sprite colour value
        lda (irqwrd1),y         ;load sprite colour value
        and #%00001111          ;mask out hi nybble
        sta sp0col+1            ;write to sprite 1 colour register
        adcwimm $0040, irqwrd1  ;Add $40 to offset to advance to next sprite
        lda (irqwrd1),y         ;load sprite colour value
        and #%00001111          ;mask out hi nybble
        sta sp0col+2            ;write to sprite 2 colour register
        ;; Set sprite x,y locations
        ldbimm frxpos, sp1x
        ldbimm frxpos, sp2x
        ldbimm frypos, sp1y
        ldbimm frypos, sp2y
        ;; Enable sprites 1+2
        lda spena
        ora #%00000110
        sta spena
        ;; Start fruit timer countdown
        ldbimm 1, frtena
        rts

        ;; Hide fruit
hidefrt:
        lda spena
        and #%11111001
        sta spena               ;disable sprites 1+2
        ldbimm 0, frtena        ;disable fruit timer
        rts
