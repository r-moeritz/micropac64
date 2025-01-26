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
        lda tmp
        ldx #blki
        jsr pelladr             ;get pellet address
        ldy #1
        lda (wrd1),y
        cmp #$ff                ;end marker?
        beq finfil              ;yep, we're done
        lda #1
        ldy #2
        sta (wrd1),y            ;set pellet status        
        ldwptr wrd1, 0, wrd2
        ldx #blki+4
        jsr isenzr              ;is pellet an energizer?
        beq :+
        ldy #pellchr            ;no, it's a regular pellet
        jmp :++
:       ldy #enzrchr            ;yes, it's an energizer        
:       ldx #blki+2
        jsr printchr            ;print pellet char
        inc tmp
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
        cpbyt sp0y, irqtmp      ;store sp0y in irqtmp
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

        ;; Convert node index to node address
        ;; Reads:
        ;;  - .A (node index)
        ;;  - .X (offset into buf to access memory block)
        ;; Writes:
        ;;  - Result is stored in 1st word of memory block
        ;;  - 2nd word of memory block is used as a work area
nodeadr:
        jsr mula6
        clc
        lda buf,x
        adc #<nodetbl
        sta buf,x
        inx
        lda buf,x
        adc #>nodetbl
        sta buf,x
        dex
        rts

        ;; Calculate distance from Pac-Man's source node to target node
        ;; Reads:
        ;;  - pacsrc (source node)
        ;;  - pactar (target node)
        ;;  - pacdir (compass direction)
        ;;  - .X (offset into buf to access memory block)
        ;; Writes:
        ;;  - pacdis (total distance)
        ;;  - pacrem (distance remaining)
        ;;  - 1st & 2nd word of memory block are used for calculations
setnodis:
        lda pacdir
        cmp #w
        bne chkne
        lda pactar
        cmp #wrpnixe            ;eastern warp tunnel node
        jeq warp
        lda pacsrc
        jsr nodeadr             
        lda (buf,x)             ;get source x coord...
        pha                     ;... and stash it on the stack
        lda pactar
        jsr nodeadr             ;get target node address
        pla                     ;restore source x coord
        jmp calcnd
chkne:  cmp #e
        bne chknn
        lda pactar
        cmp #wrpnixw             ;western warp tunnel node
        jeq warp
        lda pactar
        jsr nodeadr             
        lda (buf,x)             ;get target x coord...
        pha                     ;... and stash it on the stack
        lda pacsrc
        jsr nodeadr             ;get source node address
        pla                     ;restore target x coord
        jmp calcnd
chknn:  cmp #n
        bne setnds
        lda pacsrc
        jsr nodeadr
        incptrx buf             ;advance pointer; we need y coord
        lda (buf,x)             ;get source y coord...
        pha                     ;... and stash it on the stack
        lda pactar
        jsr nodeadr             ;get target node address
        incptrx buf             ;advance pointer; we need y coord
        pla                     ;restore source y coord
        jmp calcnd
setnds: lda pactar
        jsr nodeadr
        incptrx buf             ;advance pointer; we need y coord
        lda (buf,x)             ;get target y coord...
        pha                     ;... and stash it on the stack
        lda pacsrc
        jsr nodeadr
        incptrx buf             ;advance pointer; we need y coord
        pla                     ;restore target y coord
calcnd: sec
        sbc (buf,x)
        sta pacdis
        sta pacrem
        rts
warp:   lda #0
        sta pacdis
        sta pacrem
        rts
