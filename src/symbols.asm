        ;; ============================================================
        ;; Symbol definitions
        ;; ============================================================

        
        ;; Zero page memory locations
        ;; ------------------------------------------------------------

        ;; 18-byte buffer for use in sub-routines.
        ;; Divided into 3x 6-byte blocks:
        ;;  - 1st block for game loop
        ;;  - 2nd block for IRQ handler
        ;;  - 3rd block for NMI handler
buf:            equ $16         ;$16-$27
        ;; 1st word of buffer memory block
wrd1:           equ buf
irqwrd1:        equ buf+6
nmiwrd1:        equ buf+12
        ;; 2nd word of buffer memory block
wrd2:           equ buf+2
irqwrd2:        equ buf+8
nmiwrd2:        equ buf+14
        ;; 3rd word of buffer memory block
wrd3:           equ buf+4
irqwrd3:        equ buf+10
nmiwrd3:        equ buf+16

        ;; Joystick data
joybtn:         equ $92         ;button value
joyx:           equ $96         ;x axis value
joyy:           equ $9b         ;y axis value

        ;; Pac-Man data
pacsrc:         equ $9e         ;source node
pactar:         equ $9f         ;target node
pacdir:         equ $a3         ;facing direction
pacnxd:         equ $a4         ;next direction
pacdis:         equ $a5         ;distance to target
pacrem:         equ $a6         ;distance remaining to target
pacaix:         equ $a7         ;current animation frame index

        ;; Power pellet animation frame index
powpaix:        equ $a8
        
        ;; Still available: $a9, $f7-$fe


        ;; Memory-mapped hardware registers
        ;; ------------------------------------------------------------
        
        ;; VIC II registers
vic:            equ $d000
sp0x:           equ vic
sp0y:           equ vic + $01
scroly:         equ vic + $11
raster:         equ vic + $12
spena:          equ vic + $15
vmcsb:          equ vic + $18
vicirq:         equ vic + $19
irqmsk:         equ vic + $1a
spbgcl:         equ vic + $1f
extcol:         equ vic + $20
bgcol0:         equ vic + $21
sp0col:         equ vic + $27

        ;; CIA1 registers
cia1:           equ $dc00
ci1pra:         equ cia1
ci1icr:         equ cia1 + $0d

        ;; CIA2 registers
cia2:           equ $dd00
ci2pra:         equ cia2
c2ddra:         equ cia2 + $02
ti2alo:         equ cia2 + $04
ti2ahi:         equ cia2 + $05
ti2blo:         equ cia2 + $06
ti2bhi:         equ cia2 + $07
ci2icr:         equ cia2 + $0d
ci2cra:         equ cia2 + $0e
ci2crb:         equ cia2 + $0f


        ;; Operating system memory locations
        ;; ------------------------------------------------------------
        
        ;; Interrupt vectors
cinv:           equ $0314       ;IRQ vector
nminv:          equ $0318       ; NMI vector

        ;; Interrupt routines
sysirq:         equ $ea7e       ;kernal IRQ handler
sysnmi:         equ $fe56       ;kernal NMI handler


        ;; Program memory locations
        ;; ------------------------------------------------------------
        
charset:        equ $4000       ;character set definition
mazegfx:        equ $4bf0       ;Pac-Man maze
coltab:         equ $4800       ;colour table
scnmem:         equ $4c00       ;screen memory
colmem:         equ $d800       ;colour memory
sp0mem:         equ $5000       ;sprite 0 address
sp0ptr:         equ $4ff8       ;sprite 0 pointer
sp0loc:         equ $1000/$40   ;sp0mem


        ;; Constants
        ;; ------------------------------------------------------------

        ;; Misc.
raslin:         equ 250         ;line for raster interrupt
spxscog:        equ 24          ;sprite x screen origin
spyscog:        equ 50          ;sprite y screen origin

        ;; Node indexes
wrpnixw:        equ $1b         ;western warp tunnel node index
wrpnixe:        equ $21         ;eastern warp tunnel node index
pacstnd:        equ $31         ;Pac-Man's starting node index

        ;; Character constants
powpchr:        equ $20         ;power pellet char
pellchr:        equ $53         ;pellet char
spcechr:        equ $54         ;space char

        
        ;; Compass directions
n:              equ 2
s:              equ 3
w:              equ 4
e:              equ 5
        
        ;; Index into buf to access memory block
        ;; reserved for IRQ handler
irqblki:        equ 6

        ;; Index into buf to access memory block
        ;; reserved for NMI handler
nmiblki:        equ 12
