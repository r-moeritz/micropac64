	;; ============================================================
	;; Node-related sub-routines
	;; ============================================================

	;; Convert node index to node address
	;; Reads:
	;;  - .A (node index)
	;;  - .X (offset into buf to access memory block)
	;; Writes:
	;;  - Node address is stored in 1st word of memory block
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
setnodis:
	lda pacdir
	cmp #w
	bne chkne
	lda pactar
	cmp wrpnixe		;eastern warp tunnel node
	jeq warp
	lda pacsrc
	jsr nodeadr		
	lda (buf,x)		;get source x coord
	tay			;stash in .Y
	lda pactar
	jsr nodeadr		;get target node address
	tya			;restore source x coord
	jmp calcnd
chkne:	cmp #e
	bne chknn
	lda pactar
	cmp wrpnixw		;western warp tunnel node
	jeq warp
	lda pactar
	jsr nodeadr		
	lda (buf,x)		;get target x coord
	tay			;stash in .Y
	lda pacsrc
	jsr nodeadr		;get source node address
	tya			;restore target x coord
	jmp calcnd
chknn:	cmp #n
	bne setnds
	lda pacsrc
	jsr nodeadr
	inc buf,x		;advance pointer; we need y coord
	lda (buf,x)		;get source y coord
	tay			;stash in .Y
	lda pactar
	jsr nodeadr		;get target node address
	inc buf,x		;advance pointer; we need y coord
	tya			;restore source y coord
	jmp calcnd
setnds:	lda pactar
	jsr nodeadr
	inc buf,x		;advance pointer; we need y coord
	lda (buf,x)		;get target y coord
	tay			;stash in .Y
	lda pacsrc
	jsr nodeadr
	inc buf,x		;advance pointer; we need y coord
	tya			;restore target y coord
calcnd:	sec
	sbc (buf,x)
	sta pacdis
	sta pacrem
	rts
warp:	lda #0
	sta pacdis
	sta pacrem
	rts
