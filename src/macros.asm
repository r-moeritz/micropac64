        ;; ============================================================
        ;; General purpose macros
        ;; ============================================================


        ;; Maths
        ;; ------------------------------------------------------------
        
        ;; Multiply value in .A by 8, ignore C flag
        ;; Reads:       .A
        ;; Writes:      .A
mula8:  macro
        clc
        asl
        asl
        asl
        endm
        
        ;; Divide value in .A by 8, ignore C flag
        ;; Reads:       .A
        ;; Writes:      .A      
diva8:  macro
        sec
        lsr
        lsr
        lsr
        endm

        ;; Add immediate value to byte and store
adcbimm: macro val, byt
        clc
        lda \byt
        adc #\val
        sta \byt
        endm

        ;; Subtract immediate value from byte and store
sbcbimm: macro val, byt
        sec
        lda \byt
        sbc #\val
        sta \byt
        endm

        ;; Add immediate word value to word and store
adcwimm: macro val, wrd
        clc
        lda \wrd
        adc #<\val
        sta \wrd
        lda \wrd+1
        adc #>\val
        sta \wrd+1
        endm

        ;; Subtract immediate word value from word and store
sbcwimm: macro val, wrd
        sec
        lda \wrd
        sbc #<\val
        sta \wrd
        lda \wrd+1
        sbc #>\val
        sta \wrd+1
        endm
        
        ;; Conditional jumps
        ;; ------------------------------------------------------------

        ;; BNE to distant address
jne:    macro adr
        beq :+
        jmp \adr
:
        endm

        ;; BEQ to distant address
jeq:    macro adr
        bne :+
        jmp \adr
:
        endm

        ;; BCS to distant address
jcs:    macro adr
        bcc :+
        jmp \adr
:
        endm

        ;; BCC to distant address
jcc:    macro adr
        bcs :+
        jmp \adr
:
        endm

        ;; BMI to distant address
jmi:    macro adr
        bpl :+
        jmp \adr
:
        endm
        
        ;; Stack operations
        ;; ------------------------------------------------------------

        ;; Push .X onto the stack
phx:    macro
        txa
        pha
        endm

        ;; Pop the top byte off the stack onto .X
plx:    macro
        pla
        tax
        endm

        ;; Push .Y onto the stack
phy:    macro
        tya
        pha
        endm

        ;; Pop the top byte off the stack onto .Y
ply:    macro
        pla
        tay
        endm

        ;; Memory operations
        ;; ------------------------------------------------------------

        ;; Swap bytes via the stack
swpbyt: macro byt1, byt2
        lda \byt1
        pha                     ;load byt1 & push onto the stack
        lda \byt2
        sta \byt1               ;load byt2 & save to byt1
        pla
        sta \byt2               ;pop byt1 off the stack & save to byt2
        endm
        
        ;; Load immediate value into byte
ldbimm: macro val, byt
        lda #\val
        sta \byt
        endm
        
        ;; Load immediate value into word
ldwimm: macro val, wrd
        lda #<\val
        sta \wrd
        lda #>\val
        sta \wrd+1
        endm

        ;; Load value into byte via pointer at index
ldbptr: macro ptr, idx, byt
        ldy #\idx
        lda (\ptr),y
        sta \byt
        endm
        
        ;; Load value into word via pointer at index
ldwptr: macro ptr, idx, wrd
        ldy #\idx
        lda (\ptr),y
        sta \wrd
        iny
        lda (\ptr),y
        sta \wrd+1
        endm

        ;; Copy value from one byte to another
cpbyt:  macro src, dst
        lda \src
        sta \dst
        endm

        ;; Copy value from one word to another
cpwrd:  macro src, dst
        lda \src
        sta \dst
        lda \src+1
        sta \dst+1
        endm

        ;; Increment pointer using X-based, indirect adressing to ensure
        ;; HB is updated along with LB.
incptrx: macro ptr
        clc
        lda \ptr,x
        adc #1
        sta \ptr,x
        inx
        lda \ptr,x
        adc #0
        sta \ptr,x
        dex
        endm

        ;; Increment word to ensure HB is updated along with LB.
incwrd: macro wrd
        clc
        lda \wrd
        adc #1
        sta \wrd
        lda \wrd+1
        adc #0
        sta \wrd+1
        endm

        ;; Increment accumulator
ina:    macro
        tay
        iny
        tya
        endm

        ;; Decrement accumulator
dea:    macro
        tay
        dey
        tya
        endm
