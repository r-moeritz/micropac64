        ;; ============================================================
        ;; Symbol definitions
        ;; ============================================================

        
        ;; Zero page memory locations
        ;; ------------------------------------------------------------

        ;; 15-byte buffer for use in sub-routines,
        ;; divided into 3x blocks of 5 bytes each.
buf:            equ $16         ;$16-$24
        
        ;; Block for game loop
wrd1:           equ buf
wrd2:           equ buf+$02
tmp:            equ buf+$04
        
        ;; Block for IRQ handler
irqwrd1:        equ buf+$05
irqwrd2:        equ buf+$07
irqtmp:         equ buf+$09
        
        ;; Block for NMI handler
nmiwrd1:        equ buf+$0a
nmiwrd2:        equ buf+$0c
nmitmp:         equ buf+$0e

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

        ;; Scoring, gameplay
npelrem:        equ $a7          ;number of pellets remaining
nmenrem:        equ $a8          ;number of remaining "men"
lvlnum:         equ $a9          ;level number
score:          equ $f7          ;player's score in BCD (4 bytes: $f7-$fa)

        ;; Animation
pacaix:         equ $fb          ;Pac-Man animation frame index
enzraix:        equ $fc          ;energizer animation frame index

        ;; Still available: $fd,$fe
        
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
ti2a:           equ cia2 + $04
ti2b:           equ cia2 + $06
ci2icr:         equ cia2 + $0d
ci2cra:         equ cia2 + $0e
ci2crb:         equ cia2 + $0f


        ;; Operating system memory locations
        ;; ------------------------------------------------------------
        
        ;; Interrupt vectors
cinv:           equ $0314       ;IRQ vector
nminv:          equ $0318       ;NMI vector

        ;; Interrupt routines
sysirq:         equ $ea7e       ;kernal IRQ handler
sysnmi:         equ $fe56       ;kernal NMI handler


        ;; Program memory locations
        ;; ------------------------------------------------------------
        
charset:        equ $4000       ;character set definition
coltab:         equ $4800       ;colour table
mazegfx:        equ $4bf0       ;Pac-Man maze
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
maxpell:        equ 182         ;maximum number of pellets (incl. energizers)
maxmen:         equ 3           ;maximum number of "men"

        ;; Screen memory indexes
scrmsdi:        equ $15c        ;most significant digit of score
        
        ;; Node indexes
wrpnixw:        equ $1b         ;western warp tunnel node index
wrpnixe:        equ $21         ;eastern warp tunnel node index
pacstnd:        equ $31         ;Pac-Man's starting node index
gsthmnd:        equ $1e         ;ghost home node

        ;; Character constants
spcechr:        equ $20         ;space char
pellchr:        equ $53         ;pellet char
enzrchr:        equ $54         ;energizer char

        ;; Colour constants
dkgrey:         equ $0b         ;dark grey
ltgrey:         equ $0f         ;light grey
        
        ;; Compass directions
n:              equ 2
s:              equ 3
w:              equ 4
e:              equ 5

        ;; Scores, expressed as BCD pairs
pellpts:        equ %00010000   ;10 pts for pellets
enzrpts:        equ %01010000   ;50 pts for energizers

        ;; Index into buf to access memory block
        ;; reservedf for gameloop
blki:           equ $00
        
        ;; Index into buf to access memory block
        ;; reserved for IRQ handler
irqblki:        equ $05

        ;; Index into buf to access memory block
        ;; reserved for NMI handler
nmiblki:        equ $0a

        ;; The number of pellets that need to be eaten for bonus items
        ;; to appear the 1st and 2nd time
nbonpel1:     equ 52
nbonpel2:     equ 127
