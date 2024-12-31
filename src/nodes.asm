        ;; ============================================================
        ;; Node-related sub-routines
        ;; ============================================================

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
        inc buf,x               ;advance pointer; we need y coord
        lda (buf,x)             ;get source y coord...
        pha                     ;... and stash it on the stack
        lda pactar
        jsr nodeadr             ;get target node address
        inc buf,x               ;advance pointer; we need y coord
        pla                     ;restore source y coord
        jmp calcnd
setnds: lda pactar
        jsr nodeadr
        inc buf,x               ;advance pointer; we need y coord
        lda (buf,x)             ;get target y coord...
        pha                     ;... and stash it on the stack
        lda pacsrc
        jsr nodeadr
        inc buf,x               ;advance pointer; we need y coord
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
