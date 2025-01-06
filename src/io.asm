        ;; ============================================================
        ;; I/O related sub-routines
        ;; ============================================================

        ;; Write the player's score to screen memory
        ;; May only be called from IRQ handler!
        ;; Clobbers .A, .X, and .Y
        ;; Reads:
        ;;  - score
        ;;  - irqwrd1
        ;; Writes:
        ;;  - irqwrd1
        ;;  - irqwrd2
        ;;  - irqtmp
printscr:
        ;; Each of the 4 bytes comprising score contains 2 BCD digits.
        ;; Each digit needs to be extracted and turned into a
        ;; printable character. Then, each digit can be written to
        ;; screen memory using printchr. We skip leading zeroes.
        ldwimm scrmsdi, irqwrd1
        cpwrd irqwrd1, irqwrd2
        ldbimm 0, irqtmp
        ldx #3
lpprsc: bmi fiprsc
        ;; print hi-nybble BCD char
        lda score,x
        lsr
        lsr
        lsr
        lsr                     ;shift BCD digit into lo-nybble
        beq :+
        ldy #1
        sty irqtmp
        jmp :++
:       ldy irqtmp
        bne :+
        jmp :++
:       ora #%00110000          ;convert to printable char
        tay                     ;place char in .Y
        phx                     ;save .X onto stack
        ldx #irqblki            ;load block index into .X
        jsr printchr            ;print char
        plx                     ;restore .X from stack
:       inc irqwrd2
        cpwrd irqwrd2, irqwrd1  ;increment screen memory offset
        
        ;; print lo-nybble BCD char
:       lda score,x
        and #%00001111          ;mask out hi-nybble
        beq :+
        ldy #1        
        sty irqtmp
        jmp :++
:       ldy irqtmp
        bne :+
        jmp :++
:       ora #%00110000          ;convert to printable char
        tay                     ;place char in .Y
        phx                     ;save .X onto stack
        ldx #irqblki            ;load block index into .X
        jsr printchr            ;print char
        plx                     ;restore .X from stack
:       inc irqwrd2
        cpwrd irqwrd2, irqwrd1  ;increment screen memory offset
        dex                     ;decrement .X
        jmp lpprsc
fiprsc: rts
        
        ;; Write char in .Y to screen memory at 16-bit screen memory offset
        ;; in memory block.
        ;; Reads:
        ;;  - .Y (char to print)
        ;;  - .X (buf offset to access memory block)
        ;;  - 1st word in memory block at offset
        ;; Writes:
        ;;  - 1st word in memory block at offset
printchr:
        clc
        lda #<scnmem
        adc buf,x
        sta buf,x
        lda #>scnmem
        inx
        adc buf,x
        sta buf,x
        dex
        tya
        sta (buf,x)
        rts

        ;; Initialize VIC-II
        ;;  - Select 16K video bank
        ;;  - Select screen memory location
        ;;  - Select character memory location
        ;;  - Set border & background colours
initvic:
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
        rts

        ;; Fill colour memory from screen memory
fillcolmem:
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
        rts
        
        ;; Read joystick in port 2
        ;; Writes:
        ;;  - joyx = $01: stick moved right
        ;;  - joyx = $ff: stick moved left
        ;;  - joyy = $01: stick moved down
        ;;  - joyy = $ff: stick moved up
        ;;  - joybtn = $01: button pressed
readjoy2:
        sei
        lda ci1pra
        ldy #0
        ldx #0
        lsr
        bcs djr0
        dey
djr0:   lsr
        bcs djr1
        iny
djr1:   lsr
        bcs djr2
        dex
djr2:   lsr
        bcs djr3
        inx
djr3:   lsr
        stx joyx
        sty joyy
        lda #0
        rol
        sta joybtn
        cli
        rts
