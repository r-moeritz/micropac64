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

        ;; Swap bytes via .A and .X
swpbyt: macro byt1, byt2
        lda \byt1
        ldx \byt2
        sta \byt2
        stx \byt1
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
