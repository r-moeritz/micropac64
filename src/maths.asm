        ;; ============================================================
        ;; Maths sub-routines
        ;; ============================================================

        ;; Multiply by 5
        ;; Reads:
        ;;  - .A (multiplicand)
        ;;  - .X (offset to memory block in buf)
        ;; Writes:
        ;;  - Result is stored in word (lo, hi) of buf at offset .X
mula5:  inx
        inx
        sta buf,x               ;stash original .A in wrd2 (lo)
        clc
        asl                     ;multiply by 2
        tay                     ;stash product in .Y
        lda #0
        rol
        inx
        sta buf,x               ;stash .C in wrd2 (hi)
        tya                     ;restore product from .Y
        asl                     ;multiply by 2
        tay                     ;stash product in .Y
        lda buf,x               
        rol                     ;restore .C from wrd2 (hi)
        dex
        dex
        sta buf,x               ;write hi byte to wrd1 (hi)
        tya                     ;restore product from .Y
        inx
        adc buf,x               ;add original .A value
        dex
        dex
        sta buf,x               ;write lo byte to wrd1 (lo)
        lda #0
        rol
        inx
        adc buf,x               ;add .C to hi byte
        sta buf,x               ;and write to wrd1 (hi)
        dex
        rts
        
        ;; Multiply by 6
        ;; Reads:
        ;;  - .A (multiplicand)
        ;;  - .X (offset to memory block in buf)
        ;; Writes:
        ;;  - Result is stored in word (lo, hi) of buf at offset .X
mula6:  inx
        inx
        sta buf,x
        clc
        asl
        tay
        lda #0
        rol
        inx
        sta buf,x
        tya
        asl
        tay
        lda buf,x
        rol
        dex
        dex
        sta buf,x
        tya
        inx
        adc buf,x
        tay
        lda #0
        rol
        dex
        adc buf,x
        sta buf,x
        tya
        inx
        adc buf,x
        dex
        dex
        sta buf,x
        lda #0
        rol
        inx
        adc buf,x
        sta buf,x
        dex
        rts

