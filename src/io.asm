        ;; ============================================================
        ;; I/O related sub-routines
        ;; ============================================================

        ;; Write char in .Y to screen memory at 16-bit offset from
        ;; memory block.
        ;; Reads:
        ;;  - .Y (char to print)
        ;;  - .X (buf offset to access memory block)
        ;; Writes:
        ;;  - 1st word in memory block at offset
prtchr: clc
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
