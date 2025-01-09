        ;; ============================================================
        ;; Maze related sub-routines
        ;; ============================================================

        ;; Convert pellet table index to pellet memory address.
        ;; Reads:
        ;;  - .A (pellet table index)
        ;;  - .X (offset to memory block in buf)
        ;; Writes:
        ;;  - Result is stored in 1st word of buf at offset .X
        ;;  - 2nd word of buf at offset .X is used as a work area
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
        dex
        rts

        ;; Fill maze with pellets
        ;; May only be called from gameloop!
fillmaze:
        ldbimm 0, tmp           ;store pellet index in tmp
filloop:
        ldx #blki
        jsr pelladr             ;get pellet address
        ldy #1
        lda (wrd1),y
        cmp #$ff                ;end marker?
        beq finfil              ;yep, we're done
        ldx #blki+4
        jsr isenzr              ;is it an energizer?
        beq :+
        lda #1                  ;regular pellet
        jmp :++
:       lda #2                  ;energizer
:       ldy #2
        sta (wrd1),y            ;set pellet status
        ldwptr wrd1, 0, wrd2
        ldy #pellchr
        ldx #blki+2
        jsr printchr            ;print pellet char
        inc tmp
        lda tmp
        jmp filloop
finfil: rts

        ;; Find pellet collided with by searching in the opposite direction
        ;; to which Pac-Man is facing.
        ;; May only be called from IRQ handler!
        ;; Reads:
        ;;  - sp0x, sp0y
        ;;  - pacdir (direction Pac-Man is facing)
        ;; Writes:
        ;;  - irqwrd1: pellet address
        ;;  - irqtmp: pellet index
findpel:
        ;; if pacdir=#w then find 1st pellet in row with x>=sp0x
        ;; if pacdir=#e then find last pellet in row with x<=sp0x
        ;; if pacdir=#n then find pellet in row-1 with x=sp0x
        ;; if pacdir=#s then find pellet in row+1 with x=sp0x
        lda pacdir
        cmp #w
        bne fpckde
        cpbyt sp0y, irqtmp
        jsr fpinrow             ;get indexes of west-most & east-most pellets
        cpbyt irqwrd2, irqtmp   ;store index of west-most pellet
        ldx #irqblki
:       lda irqtmp              ;load index of west-most pellet in row
        jsr pelladr             ;load pellet address into irqwrd1
        ldy #3
        cpbyt sp0x, irqwrd2     ;copy sp0x to irqwrd2 (lo)
        dec irqwrd2             ;decrement irqwrd2 (lo) to give some leeway
        lda (irqwrd1),y         ;load pellet x loc
        cmp irqwrd2
        bcs :+                  ;pellet x loc >= sp0x?
        inc irqtmp              ;no, try next pellet to the east
        jmp :-
:       ldy #2
        lda (irqwrd1),y         ;yes, load pellet state
        jeq pelnotfd            ;has pellet already been eaten?
        jmp pelfound
fpckde: cmp #e
        bne fpckdn
        cpbyt sp0y, irqtmp
        jsr fpinrow             ;get indexes of west-most & east-most pellets
        ldy #1
        lda irqwrd2,y
        sta irqtmp              ;store index of west-most pellet
        ldx #irqblki
:       lda irqtmp
        jsr pelladr
        cpbyt sp0x, irqwrd2     ;copy sp0x to irqwrd2 (lo)
        inc irqwrd2             ;increment irqwrd2 (lo) to give some leeway
        lda irqwrd2
        ldy #3
        cmp (irqwrd1),y
        bcs :+                  ;sp0x >= pellet x loc
        dec irqtmp              ;no, try next pellet to the west
        jmp :-
:       ldy #2
        lda (irqwrd1),y         ;yes, load pellet state
        jeq pelnotfd            ;has pellet already been eaten?
        jmp pelfound
fpckdn: cmp #n
        bne fpds
        sec
        lda sp0y
        sbc #2
        sta irqtmp              ;store sp0y-2 in irqtmp
        jsr fprixs
        jsr fpinrow             ;get indexes of west-most & east-most pellets
        cpbyt irqwrd2, irqtmp   ;store index of west-most pellet
        ldx #irqblki
:       lda irqtmp
        jsr pelladr
        lda sp0x
        ldy #3
        cmp (irqwrd1),y
        beq :+                  ;sp0x = pellet x loc?
        inc irqtmp              ;no, try next pellet to the east
        jmp :-
:       ldy #2
        lda (irqwrd1),y         ;yes, load pellet state
        beq pelnotfd            ;has pellet already been eaten?
        jmp pelfound
fpds:   cpbyt sp0y, irqtmp
        jsr fprixn
        jsr fpinrow             ;get indexes of west-most & east-most pellets
        cpbyt irqwrd2, irqtmp   ;store index of west-most pellet
        ldx #irqblki
:       lda irqtmp
        jsr pelladr
        lda sp0x
        ldy #3
        cmp (irqwrd1),y
        beq :+                  ;sp0x = pellet x loc?
        inc irqtmp              ;no, try next pellet to the east
        jmp :-
:       ldy #2
        lda (irqwrd1),y         ;yes, load pellet state
        beq pelnotfd            ;has pellet already been eaten?
pelfound:
        lda #0
        ldy #2
        sta (irqwrd1),y         ;pellet not yet eaten, mark as eaten
        rts        
pelnotfd:
        ldwimm $ffff, irqwrd1   ;pellet already eaten
        rts

        ;; Get y loc of next row to the south of the y loc in irqtmp
        ;; Reads:
        ;;  - irqtmp: y loc to find row south of
        ;; Writes:
        ;;  - irqtmp: y loc of next row to the south
fprixs: ldy #0
:       lda plrowix,y
        cmp irqtmp
        bcs :+
        iny
        iny
        iny
        jmp :-
:       sta irqtmp
        rts
        
        ;; Get y loc of next row to the north of the y loc in irqtmp
        ;; Reads:
        ;;  - irqtmp: y loc to find row north of
        ;; Writes:
        ;;  - irqtmp: y loc of next row to the north
fprixn: ldy #66
:       lda plrowix,y
        cmp irqtmp
        bcc :+
        dey
        dey
        dey
        jmp :-
:       sta irqtmp
        rts
        
        
        ;; Get pellet table indexes of west-most & east-most pellets 
        ;; in row whose sprite y loc is in irqtmp
        ;; May only be called from IRQ handler!
        ;; Reads:
        ;;  - irqtmp: pellet row y loc
        ;; Writes:
        ;;  - irqwrd2: indexes of west-most & east-most pellets in row
fpinrow:
        ldy #0
:       lda plrowix,y
        cmp irqtmp
        beq :+
        iny
        iny
        iny
        jmp :-
:       iny
        lda plrowix,y
        sta irqwrd2
        iny
        lda plrowix,y
        sta irqwrd2+1
        rts

        ;; Check whether or not pellet at index is an energizer
        ;; Reads:
        ;;  - .X: index into buffer to access memory block
        ;;  - 1st byte of memory block: pellet index
        ;; Writes:
        ;;  - .Z is set if pellet is an energizer
isenzr: ldy #3
:       bmi :+
        lda buf,x
        cmp enzrlst,y
        beq :+
        dey
        jmp :-
:       rts
