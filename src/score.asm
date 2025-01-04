        ;; ============================================================
        ;; Score related routines
        ;; ============================================================

        ;; Reset the score to 0
rstscr:
        lda #0
        ldx #3
:       bmi :+
        sta score,x
        dex
        jmp :-
:       rts
        
        ;; Score pellet (10 pts)
        ;; Reads:
        ;;  - .X (offset to memory block)
        ;; Writes:
        ;;  - score
scrpell:
        lda #pellpts
        sta buf,x
        inx
        lda #0
        sta buf,x
        dex
        jmp addscr

        ;; Score energizer (50 pts)
        ;; Reads:
        ;;  - .X (offset to memory block)
        ;; Writes:
        ;;  - 1st word in memory block
        ;;  - score
screnzr:
        lda #enzrpts
        sta buf,x
        inx
        lda #0
        sta buf,x
        dex
        jmp addscr
      
        ;; Add 16-bit BCD value to score
        ;; Reads:
        ;;  - .X: index into buffer to access memory block
        ;;  - 1st word in memory block containing 4 BCD digits
        ;; Writes:
        ;;  - score
addscr:
        sed
        clc
        lda score
        adc buf,x
        sta score
        lda score+1
        inx
        adc buf,x 
        sta score+1
        lda score+2
        adc #0
        sta score+2
        lda score+3
        adc #0
        sta score+3
        cld
        dex
        rts
