        ;; ============================================================
        ;; Data table definitions
        ;; ============================================================
        
        ;; Node table
        ;; Format:        
        ;;  - byte x,y (node loc in sprite coords)
        ;;  - byte n,s,w,e (indices of neighboring nodes)
nodetbl:
        ;; Row 1
        byte $20,$3a,$ff,$06,$ff,$01
        byte $40,$3a,$ff,$07,$00,$02
        byte $60,$3a,$ff,$09,$01,$ff
        byte $70,$3a,$ff,$0a,$ff,$04
        byte $90,$3a,$ff,$0c,$03,$05
        byte $b0,$3a,$ff,$0d,$04,$ff
        ;; Row 2
        byte $20,$52,$00,$0e,$ff,$07
        byte $40,$52,$01,$0f,$06,$08
        byte $50,$52,$ff,$10,$07,$09
        byte $60,$52,$02,$ff,$08,$0a
        byte $70,$52,$03,$ff,$09,$0b
        byte $80,$52,$ff,$13,$0a,$0c
        byte $90,$52,$04,$14,$0b,$0d
        byte $b0,$52,$05,$15,$0c,$ff
        ;; Row 3
        byte $20,$6a,$06,$ff,$ff,$0f
        byte $40,$6a,$07,$1c,$0e,$ff
        byte $50,$6a,$08,$ff,$ff,$11
        byte $60,$6a,$ff,$17,$10,$ff
        byte $70,$6a,$ff,$19,$ff,$13
        byte $80,$6a,$0b,$ff,$12,$ff
        byte $90,$6a,$0c,$20,$ff,$15
        byte $b0,$6a,$0d,$ff,$14,$ff
        ;; Row 4
        byte $50,$7a,$ff,$1d,$ff,$17
        byte $60,$7a,$11,$ff,$16,$18
        byte $68,$7a,$ff,$1e,$17,$19
        byte $70,$7a,$12,$ff,$18,$1a
        byte $80,$7a,$ff,$1f,$19,$ff
        ;; Row 5
        byte $18,$92,$ff,$ff,$21,$1c
        byte $40,$92,$0f,$25,$1b,$1d
        byte $50,$92,$16,$22,$1c,$ff
        byte $68,$92,$18,$ff,$ff,$ff
        byte $80,$92,$1a,$23,$ff,$20
        byte $90,$92,$14,$2a,$1f,$21
        byte $b8,$92,$ff,$ff,$20,$1b
        ;; Row 6
        byte $50,$a2,$1d,$26,$ff,$23
        byte $80,$a2,$1f,$29,$22,$ff
        ;; Row 7
        byte $20,$ba,$ff,$2c,$ff,$25
        byte $40,$ba,$1c,$2e,$24,$26
        byte $50,$ba,$22,$ff,$25,$27
        byte $60,$ba,$ff,$30,$26,$ff
        byte $70,$ba,$ff,$32,$ff,$29
        byte $80,$ba,$23,$ff,$28,$2a
        byte $90,$ba,$20,$34,$29,$2b
        byte $b0,$ba,$ff,$36,$2a,$ff
        ;; Row 8
        byte $20,$ca,$24,$ff,$ff,$2d
        byte $30,$ca,$ff,$38,$2c,$ff
        byte $40,$ca,$25,$39,$ff,$2f
        byte $50,$ca,$ff,$3a,$2e,$30
        byte $60,$ca,$27,$ff,$2f,$31
        byte $68,$ca,$ff,$ff,$30,$32
        byte $70,$ca,$28,$ff,$31,$33
        byte $80,$ca,$ff,$3d,$32,$34
        byte $90,$ca,$2a,$3e,$33,$ff
        byte $a0,$ca,$ff,$3f,$ff,$36
        byte $b0,$ca,$2b,$ff,$35,$ff
        ;; Row 9
        byte $20,$da,$ff,$41,$ff,$38
        byte $30,$da,$2d,$ff,$37,$39
        byte $40,$da,$2e,$ff,$38,$ff
        byte $50,$da,$2f,$ff,$ff,$3b
        byte $60,$da,$ff,$42,$3a,$ff
        byte $70,$da,$ff,$43,$ff,$3d
        byte $80,$da,$33,$ff,$3c,$ff
        byte $90,$da,$34,$ff,$ff,$3f
        byte $a0,$da,$35,$ff,$3e,$40
        byte $b0,$da,$ff,$44,$3f,$ff
        ;; Row 10
        byte $20,$ea,$37,$ff,$ff,$42
        byte $60,$ea,$3b,$ff,$41,$43
        byte $70,$ea,$3c,$ff,$42,$44
        byte $b0,$ea,$40,$ff,$43,$ff


        ;; Pellet table
        ;; Format:        
        ;;  - word address (screen memory address)
        ;;  - byte status (0=eaten, 1=not eaten)
        ;;  - byte x,y (sprite coordinates of char)
pelltbl:
        ;; Row 1
        word $0029
        byte 1,$20,$3a
        word $002a
        byte 1,$28,$3a
        word $002b
        byte 1,$30,$3a
        word $002c
        byte 1,$38,$3a
        word $002d
        byte 1,$40,$3a
        word $002e
        byte 1,$48,$3a
        word $002f
        byte 1,$50,$3a
        word $0030
        byte 1,$58,$3a
        word $0031
        byte 1,$60,$3a
        word $0033
        byte 1,$70,$3a
        word $0034
        byte 1,$78,$3a
        word $0035
        byte 1,$80,$3a
        word $0036
        byte 1,$88,$3a
        word $0037
        byte 1,$90,$3a
        word $0038
        byte 1,$98,$3a
        word $0039
        byte 1,$a0,$3a
        word $003a
        byte 1,$a8,$3a
        word $003b
        byte 1,$b0,$3a
        ;; Row 2
        word $0051
        byte 1,$20,$42          ;energizer
        word $0055
        byte 1,$40,$42
        word $0059
        byte 1,$60,$42
        word $005b
        byte 1,$70,$42
        word $005f
        byte 1,$90,$42
        word $0063
        byte 1,$b0,$42          ;energizer
        ;; Row 3
        word $0079
        byte 1,$20,$4a
        word $007d
        byte 1,$40,$4a
        word $0081
        byte 1,$60,$4a
        word $0083
        byte 1,$70,$4a
        word $0087
        byte 1,$90,$4a
        word $008b
        byte 1,$b0,$4a
        ;; Row 4
        word $00a1
        byte 1,$20,$52
        word $00a2
        byte 1,$28,$52
        word $00a3
        byte 1,$30,$52
        word $00a4
        byte 1,$38,$52
        word $00a5
        byte 1,$40,$52
        word $00a6
        byte 1,$48,$52
        word $00a7
        byte 1,$50,$52
        word $00a8
        byte 1,$58,$52
        word $00a9
        byte 1,$60,$52
        word $00aa
        byte 1,$68,$52
        word $00ab
        byte 1,$70,$52
        word $00ac
        byte 1,$78,$52
        word $00ad
        byte 1,$80,$52
        word $00ae
        byte 1,$88,$52
        word $00af
        byte 1,$90,$52
        word $00b0
        byte 1,$98,$52
        word $00b1
        byte 1,$a0,$52
        word $00b2
        byte 1,$a8,$52
        word $00b3
        byte 1,$b0,$52
        ;; Row 5
        word $00c9
        byte 1,$20,$5a
        word $00cd
        byte 1,$40,$5a
        word $00cf
        byte 1,$50,$5a
        word $00d5
        byte 1,$80,$5a
        word $00d7
        byte 1,$90,$5a
        word $00db
        byte 1,$b0,$5a
        ;; Row 6
        word $00f1
        byte 1,$20,$62
        word $00f5
        byte 1,$40,$62
        word $00f7
        byte 1,$50,$62
        word $00fd
        byte 1,$80,$62
        word $00ff
        byte 1,$90,$62
        word $0103
        byte 1,$b0,$62
        ;; Row 7
        word $0119
        byte 1,$20,$6a
        word $011a
        byte 1,$28,$6a
        word $011b
        byte 1,$30,$6a
        word $011c
        byte 1,$38,$6a
        word $011d
        byte 1,$40,$6a
        word $011f
        byte 1,$50,$6a
        word $0120
        byte 1,$58,$6a
        word $0121
        byte 1,$60,$6a
        word $0123
        byte 1,$70,$6a
        word $0124
        byte 1,$78,$6a
        word $0125
        byte 1,$80,$6a
        word $0127
        byte 1,$90,$6a
        word $0128
        byte 1,$98,$6a
        word $0129
        byte 1,$a0,$6a
        word $012a
        byte 1,$a8,$6a
        word $012b
        byte 1,$b0,$6a
        ;; Row 8
        word $0145
        byte 1,$40,$72
        word $0149
        byte 1,$60,$72
        word $014b
        byte 1,$70,$72
        word $014f
        byte 1,$90,$72
        ;; Row 9
        word $016d
        byte 1,$40,$7a
        word $0177
        byte 1,$90,$7a
        ;; Row 10
        word $0195
        byte 1,$40,$82
        word $019f
        byte 1,$90,$82
        ;; Row 11
        word $01bd
        byte 1,$40,$8a
        word $01c7
        byte 1,$90,$8a
        ;; Row 12
        word $01e5
        byte 1,$40,$92
        word $01ef
        byte 1,$90,$92
        ;; Row 13
        word $020d
        byte 1,$40,$9a
        word $0217
        byte 1,$90,$9a
        ;; Row 14
        word $0235
        byte 1,$40,$a2
        word $023f
        byte 1,$90,$a2
        ;; Row 15
        word $025d
        byte 1,$40,$aa
        word $0267
        byte 1,$90,$aa
        ;; Row 16
        word $0285
        byte 1,$40,$b2
        word $028f
        byte 1,$90,$b2
        ;; Row 17
        word $02a9
        byte 1,$20,$ba
        word $02aa
        byte 1,$28,$ba
        word $02ab
        byte 1,$30,$ba
        word $02ac
        byte 1,$38,$ba
        word $02ad
        byte 1,$40,$ba
        word $02ae
        byte 1,$48,$ba
        word $02af
        byte 1,$50,$ba
        word $02b0
        byte 1,$58,$ba
        word $02b1
        byte 1,$60,$ba
        word $02b3
        byte 1,$70,$ba
        word $02b4
        byte 1,$78,$ba
        word $02b5
        byte 1,$80,$ba
        word $02b6
        byte 1,$88,$ba
        word $02b7
        byte 1,$90,$ba
        word $02b8
        byte 1,$98,$ba
        word $02b9
        byte 1,$a0,$ba
        word $02ba
        byte 1,$a8,$ba
        word $02bb
        byte 1,$b0,$ba
        ;; Row 18
        word $02d1
        byte 1,$20,$c2
        word $02d5
        byte 1,$40,$c2
        word $02d9
        byte 1,$60,$c2
        word $02db
        byte 1,$70,$c2
        word $02df
        byte 1,$90,$c2
        word $02e3
        byte 1,$b0,$c2
        ;; Row 19
        word $02f9
        byte 1,$20,$ca          ;energizer
        word $02fa
        byte 1,$28,$ca
        word $02fb
        byte 1,$30,$ca
        word $02fd
        byte 1,$40,$ca
        word $02fe
        byte 1,$48,$ca
        word $02ff
        byte 1,$50,$ca
        word $0300
        byte 1,$58,$ca
        word $0301
        byte 1,$60,$ca
        word $0303
        byte 1,$70,$ca
        word $0304
        byte 1,$78,$ca
        word $0305
        byte 1,$80,$ca
        word $0306
        byte 1,$88,$ca
        word $0307
        byte 1,$90,$ca
        word $0309
        byte 1,$a0,$ca
        word $030a
        byte 1,$a8,$ca
        word $030b
        byte 1,$b0,$ca          ;energizer
        ;; Row 20
        word $0323
        byte 1,$30,$d2
        word $0325
        byte 1,$40,$d2
        word $0327
        byte 1,$50,$d2
        word $032d
        byte 1,$80,$d2
        word $032f
        byte 1,$90,$d2
        word $0331
        byte 1,$a0,$d2
        ;; Row 21
        word $0349
        byte 1,$20,$da
        word $034a
        byte 1,$28,$da
        word $034b
        byte 1,$30,$da
        word $034c
        byte 1,$38,$da
        word $034d
        byte 1,$40,$da
        word $034f
        byte 1,$50,$da
        word $0350
        byte 1,$58,$da
        word $0351
        byte 1,$60,$da
        word $0353
        byte 1,$70,$da
        word $0354
        byte 1,$78,$da
        word $0355
        byte 1,$80,$da
        word $0357
        byte 1,$90,$da
        word $0358
        byte 1,$98,$da
        word $0359
        byte 1,$a0,$da
        word $035a
        byte 1,$a8,$da
        word $035b
        byte 1,$b0,$da
        ;; Row 22
        word $0371
        byte 1,$20,$e2
        word $0379
        byte 1,$60,$e2
        word $037b
        byte 1,$70,$e2
        word $0383
        byte 1,$b0,$e2
        ;; Row 23
        word $0399
        byte 1,$20,$ea
        word $039a
        byte 1,$28,$ea
        word $039b
        byte 1,$30,$ea
        word $039c
        byte 1,$38,$ea
        word $039d
        byte 1,$40,$ea
        word $039e
        byte 1,$48,$ea
        word $039f
        byte 1,$50,$ea
        word $03a0
        byte 1,$58,$ea
        word $03a1
        byte 1,$60,$ea
        word $03a2
        byte 1,$68,$ea
        word $03a3
        byte 1,$70,$ea
        word $03a4
        byte 1,$78,$ea
        word $03a5
        byte 1,$80,$ea
        word $03a6
        byte 1,$88,$ea
        word $03a7
        byte 1,$90,$ea
        word $03a8
        byte 1,$98,$ea
        word $03a9
        byte 1,$a0,$ea
        word $03aa
        byte 1,$a8,$ea
        word $03ab
        byte 1,$b0,$ea
        ;; End marker
        word $ffff
        byte $ff,$ff,$ff
        
        ;; Energizer list
        ;; Index into pelltbl
enzrlst:
        byte $12
        byte $17
        byte $79
        byte $88

        ;; Pac-Man animation frames:
        ;; Sprite offset values
pacalst:
        byte $00,$01,$02,$03
        byte $02,$01,$ff

        ;; Index in pelltbl of leftmost+rightmost pellet in row by sprite y loc
        ;; Format:
        ;;  - byte y (sprite y loc of row)
        ;;  - byte ixl (pelltbl index of leftmost pellet in row)
        ;;  - byte ixr (pelltbl index of rightmost pellet in row)
plrowix:
        byte $3a,$00,$11        ;row 1
        byte $42,$12,$17        ;row 2
        byte $4a,$18,$1d        ;row 3
        byte $52,$1e,$30        ;row 4
        byte $5a,$31,$36        ;row 5
        byte $62,$37,$3c        ;row 6
        byte $6a,$3d,$4c        ;row 7
        byte $72,$4d,$50        ;row 8
        byte $7a,$51,$52        ;row 9
        byte $82,$53,$54        ;row 10
        byte $8a,$55,$56        ;row 11
        byte $92,$57,$58        ;row 12
        byte $9a,$59,$5a        ;row 13
        byte $a2,$5b,$5c        ;row 14
        byte $aa,$5d,$5e        ;row 15
        byte $b2,$5f,$60        ;row 16
        byte $ba,$61,$72        ;row 17
        byte $c2,$73,$78        ;row 18
        byte $ca,$79,$88        ;row 19
        byte $d2,$89,$8e        ;row 20
        byte $da,$8f,$9e        ;row 21
        byte $e2,$9f,$a2        ;row 22
        byte $ea,$a3,$b5        ;row 23
