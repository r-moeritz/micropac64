        ;; ============================================================
        ;; Data table definitions
        ;; ============================================================
        
        ;; Node table
        ;; Format:        
        ;;  - db x,y (node loc in sprite coords)
        ;;  - db n,s,w,e (indices of neighboring nodes)
nodetbl:
        ;; Row 1
        db $20,$3a,$ff,$06,$ff,$01
        db $40,$3a,$ff,$07,$00,$02
        db $60,$3a,$ff,$09,$01,$ff
        db $70,$3a,$ff,$0a,$ff,$04
        db $90,$3a,$ff,$0c,$03,$05
        db $b0,$3a,$ff,$0d,$04,$ff
        ;; Row 2
        db $20,$52,$00,$0e,$ff,$07
        db $40,$52,$01,$0f,$06,$08
        db $50,$52,$ff,$10,$07,$09
        db $60,$52,$02,$ff,$08,$0a
        db $70,$52,$03,$ff,$09,$0b
        db $80,$52,$ff,$13,$0a,$0c
        db $90,$52,$04,$14,$0b,$0d
        db $b0,$52,$05,$15,$0c,$ff
        ;; Row 3
        db $20,$6a,$06,$ff,$ff,$0f
        db $40,$6a,$07,$1c,$0e,$ff
        db $50,$6a,$08,$ff,$ff,$11
        db $60,$6a,$ff,$17,$10,$ff
        db $70,$6a,$ff,$19,$ff,$13
        db $80,$6a,$0b,$ff,$12,$ff
        db $90,$6a,$0c,$20,$ff,$15
        db $b0,$6a,$0d,$ff,$14,$ff
        ;; Row 4
        db $50,$7a,$ff,$1d,$ff,$17
        db $60,$7a,$11,$ff,$16,$18
        db $68,$7a,$ff,$1e,$17,$19
        db $70,$7a,$12,$ff,$18,$1a
        db $80,$7a,$ff,$1f,$19,$ff
        ;; Row 5
        db $18,$92,$ff,$ff,$21,$1c
        db $40,$92,$0f,$25,$1b,$1d
        db $50,$92,$16,$22,$1c,$ff
        db $68,$92,$18,$ff,$ff,$ff
        db $80,$92,$1a,$23,$ff,$20
        db $90,$92,$14,$2a,$1f,$21
        db $b8,$92,$ff,$ff,$20,$1b
        ;; Row 6
        db $50,$a2,$1d,$26,$ff,$23
        db $80,$a2,$1f,$29,$22,$ff
        ;; Row 7
        db $20,$ba,$ff,$2c,$ff,$25
        db $40,$ba,$1c,$2e,$24,$26
        db $50,$ba,$22,$ff,$25,$27
        db $60,$ba,$ff,$30,$26,$ff
        db $70,$ba,$ff,$32,$ff,$29
        db $80,$ba,$23,$ff,$28,$2a
        db $90,$ba,$20,$34,$29,$2b
        db $b0,$ba,$ff,$36,$2a,$ff
        ;; Row 8
        db $20,$ca,$24,$ff,$ff,$2d
        db $30,$ca,$ff,$38,$2c,$ff
        db $40,$ca,$25,$39,$ff,$2f
        db $50,$ca,$ff,$3a,$2e,$30
        db $60,$ca,$27,$ff,$2f,$31
        db $68,$ca,$ff,$ff,$30,$32
        db $70,$ca,$28,$ff,$31,$33
        db $80,$ca,$ff,$3d,$32,$34
        db $90,$ca,$2a,$3e,$33,$ff
        db $a0,$ca,$ff,$3f,$ff,$36
        db $b0,$ca,$2b,$ff,$35,$ff
        ;; Row 9
        db $20,$da,$ff,$41,$ff,$38
        db $30,$da,$2d,$ff,$37,$39
        db $40,$da,$2e,$ff,$38,$ff
        db $50,$da,$2f,$ff,$ff,$3b
        db $60,$da,$ff,$42,$3a,$ff
        db $70,$da,$ff,$43,$ff,$3d
        db $80,$da,$33,$ff,$3c,$ff
        db $90,$da,$34,$ff,$ff,$3f
        db $a0,$da,$35,$ff,$3e,$40
        db $b0,$da,$ff,$44,$3f,$ff
        ;; Row 10
        db $20,$ea,$37,$ff,$ff,$42
        db $60,$ea,$3b,$ff,$41,$43
        db $70,$ea,$3c,$ff,$42,$44
        db $b0,$ea,$40,$ff,$43,$ff


        ;; Pellet table
        ;; Format:        
        ;;  - dw address (screen memory address)
        ;;  - db presence (0=eaten, 1=present)
        ;;  - db x,y (sprite coordinates of char)
pelltbl:
        ;; Row 1
        dw $0029
        db 1,$20,$3a
        dw $002a
        db 1,$28,$3a
        dw $002b
        db 1,$30,$3a
        dw $002c
        db 1,$38,$3a
        dw $002d
        db 1,$40,$3a
        dw $002e
        db 1,$48,$3a
        dw $002f
        db 1,$50,$3a
        dw $0030
        db 1,$58,$3a
        dw $0031
        db 1,$60,$3a
        dw $0033
        db 1,$70,$3a
        dw $0034
        db 1,$78,$3a
        dw $0035
        db 1,$80,$3a
        dw $0036
        db 1,$88,$3a
        dw $0037
        db 1,$90,$3a
        dw $0038
        db 1,$98,$3a
        dw $0039
        db 1,$a0,$3a
        dw $003a
        db 1,$a8,$3a
        dw $003b
        db 1,$b0,$3a
        ;; Row 2
        dw $0051
        db 1,$20,$42
        dw $0055
        db 1,$40,$42
        dw $0059
        db 1,$60,$42
        dw $005b
        db 1,$70,$42
        dw $005f
        db 1,$90,$42
        dw $0063
        db 1,$b0,$42
        ;; Row 3
        dw $0079
        db 1,$20,$4a
        dw $007d
        db 1,$40,$4a
        dw $0081
        db 1,$60,$4a
        dw $0083
        db 1,$70,$4a
        dw $0087
        db 1,$90,$4a
        dw $008b
        db 1,$b0,$4a
        ;; Row 4
        dw $00a1
        db 1,$20,$52
        dw $00a2
        db 1,$28,$52
        dw $00a3
        db 1,$30,$52
        dw $00a4
        db 1,$38,$52
        dw $00a5
        db 1,$40,$52
        dw $00a6
        db 1,$48,$52
        dw $00a7
        db 1,$50,$52
        dw $00a8
        db 1,$58,$52
        dw $00a9
        db 1,$60,$52
        dw $00aa
        db 1,$68,$52
        dw $00ab
        db 1,$70,$52
        dw $00ac
        db 1,$78,$52
        dw $00ad
        db 1,$80,$52
        dw $00ae
        db 1,$88,$52
        dw $00af
        db 1,$90,$52
        dw $00b0
        db 1,$98,$52
        dw $00b1
        db 1,$a0,$52
        dw $00b2
        db 1,$a8,$52
        dw $00b3
        db 1,$b0,$52
        ;; Row 5
        dw $00c9
        db 1,$20,$5a
        dw $00cd
        db 1,$40,$5a
        dw $00cf
        db 1,$50,$5a
        dw $00d5
        db 1,$80,$5a
        dw $00d7
        db 1,$90,$5a
        dw $00db
        db 1,$b0,$5a
        ;; Row 6
        dw $00f1
        db 1,$20,$62
        dw $00f5
        db 1,$40,$62
        dw $00f7
        db 1,$50,$62
        dw $00fd
        db 1,$80,$62
        dw $00ff
        db 1,$90,$62
        dw $0103
        db 1,$b0,$62
        ;; Row 7
        dw $0119
        db 1,$20,$6a
        dw $011a
        db 1,$28,$6a
        dw $011b
        db 1,$30,$6a
        dw $011c
        db 1,$38,$6a
        dw $011d
        db 1,$40,$6a
        dw $011f
        db 1,$50,$6a
        dw $0120
        db 1,$58,$6a
        dw $0121
        db 1,$60,$6a
        dw $0123
        db 1,$70,$6a
        dw $0124
        db 1,$78,$6a
        dw $0125
        db 1,$80,$6a
        dw $0127
        db 1,$90,$6a
        dw $0128
        db 1,$98,$6a
        dw $0129
        db 1,$a0,$6a
        dw $012a
        db 1,$a8,$6a
        dw $012b
        db 1,$b0,$6a
        ;; Row 8
        dw $0145
        db 1,$40,$72
        dw $0149
        db 1,$60,$72
        dw $014b
        db 1,$70,$72
        dw $014f
        db 1,$90,$72
        ;; Row 9
        dw $016d
        db 1,$40,$7a
        dw $0177
        db 1,$90,$7a
        ;; Row 10
        dw $0195
        db 1,$40,$82
        dw $019f
        db 1,$90,$82
        ;; Row 11
        dw $01bd
        db 1,$40,$8a
        dw $01c7
        db 1,$90,$8a
        ;; Row 12
        dw $01e5
        db 1,$40,$92
        dw $01ef
        db 1,$90,$92
        ;; Row 13
        dw $020d
        db 1,$40,$9a
        dw $0217
        db 1,$90,$9a
        ;; Row 14
        dw $0235
        db 1,$40,$a2
        dw $023f
        db 1,$90,$a2
        ;; Row 15
        dw $025d
        db 1,$40,$aa
        dw $0267
        db 1,$90,$aa
        ;; Row 16
        dw $0285
        db 1,$40,$b2
        dw $028f
        db 1,$90,$b2
        ;; Row 17
        dw $02a9
        db 1,$20,$ba
        dw $02aa
        db 1,$28,$ba
        dw $02ab
        db 1,$30,$ba
        dw $02ac
        db 1,$38,$ba
        dw $02ad
        db 1,$40,$ba
        dw $02ae
        db 1,$48,$ba
        dw $02af
        db 1,$50,$ba
        dw $02b0
        db 1,$58,$ba
        dw $02b1
        db 1,$60,$ba
        dw $02b3
        db 1,$70,$ba
        dw $02b4
        db 1,$78,$ba
        dw $02b5
        db 1,$80,$ba
        dw $02b6
        db 1,$88,$ba
        dw $02b7
        db 1,$90,$ba
        dw $02b8
        db 1,$98,$ba
        dw $02b9
        db 1,$a0,$ba
        dw $02ba
        db 1,$a8,$ba
        dw $02bb
        db 1,$b0,$ba
        ;; Row 18
        dw $02d1
        db 1,$20,$c2
        dw $02d5
        db 1,$40,$c2
        dw $02d9
        db 1,$60,$c2
        dw $02db
        db 1,$70,$c2
        dw $02df
        db 1,$90,$c2
        dw $02e3
        db 1,$b0,$c2
        ;; Row 19
        dw $02f9
        db 1,$20,$ca
        dw $02fa
        db 1,$28,$ca
        dw $02fb
        db 1,$30,$ca
        dw $02fd
        db 1,$40,$ca
        dw $02fe
        db 1,$48,$ca
        dw $02ff
        db 1,$50,$ca
        dw $0300
        db 1,$58,$ca
        dw $0301
        db 1,$60,$ca
        dw $0303
        db 1,$70,$ca
        dw $0304
        db 1,$78,$ca
        dw $0305
        db 1,$80,$ca
        dw $0306
        db 1,$88,$ca
        dw $0307
        db 1,$90,$ca
        dw $0309
        db 1,$a0,$ca
        dw $030a
        db 1,$a8,$ca
        dw $030b
        db 1,$b0,$ca
        ;; Row 20
        dw $0323
        db 1,$30,$d2
        dw $0325
        db 1,$40,$d2
        dw $0327
        db 1,$50,$d2
        dw $032d
        db 1,$80,$d2
        dw $032f
        db 1,$90,$d2
        dw $0331
        db 1,$a0,$d2
        ;; Row 21
        dw $0349
        db 1,$20,$da
        dw $034a
        db 1,$28,$da
        dw $034b
        db 1,$30,$da
        dw $034c
        db 1,$38,$da
        dw $034d
        db 1,$40,$da
        dw $034f
        db 1,$50,$da
        dw $0350
        db 1,$58,$da
        dw $0351
        db 1,$60,$da
        dw $0353
        db 1,$70,$da
        dw $0354
        db 1,$78,$da
        dw $0355
        db 1,$80,$da
        dw $0357
        db 1,$90,$da
        dw $0358
        db 1,$98,$da
        dw $0359
        db 1,$a0,$da
        dw $035a
        db 1,$a8,$da
        dw $035b
        db 1,$b0,$da
        ;; Row 22
        dw $0371
        db 1,$20,$e2
        dw $0379
        db 1,$60,$e2
        dw $037b
        db 1,$70,$e2
        dw $0383
        db 1,$b0,$e2
        ;; Row 23
        dw $0399
        db 1,$20,$ea
        dw $039a
        db 1,$28,$ea
        dw $039b
        db 1,$30,$ea
        dw $039c
        db 1,$38,$ea
        dw $039d
        db 1,$40,$ea
        dw $039e
        db 1,$48,$ea
        dw $039f
        db 1,$50,$ea
        dw $03a0
        db 1,$58,$ea
        dw $03a1
        db 1,$60,$ea
        dw $03a2
        db 1,$68,$ea
        dw $03a3
        db 1,$70,$ea
        dw $03a4
        db 1,$78,$ea
        dw $03a5
        db 1,$80,$ea
        dw $03a6
        db 1,$88,$ea
        dw $03a7
        db 1,$90,$ea
        dw $03a8
        db 1,$98,$ea
        dw $03a9
        db 1,$a0,$ea
        dw $03aa
        db 1,$a8,$ea
        dw $03ab
        db 1,$b0,$ea
        ;; End marker
        dw $ffff
        db $ff

        ;; Power pellet list:        
        ;; Indexes into pellet table
powplst:
        db $12,$17,$79,$88

        ;; Pac-Man animation frames:
        ;; Sprite offset values
pacalst:
        db $00,$01,$02,$03
        db $02,$01,$ff
