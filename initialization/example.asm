            processor 6502

            include "nes.h"
            include "macro.h"
            
            seg Header
            org $7ff0

            NES_HEADER 0,2,0,0  ; mapper 0, 2 16KB PRG banks, no 8KB CHR bank, horiz. mirror

            seg Code
            org $8000

Start       NES_INIT        ; init registers
            jsr WaitSync    ; wait for VSync
            jsr ClearRAM    ; Clear RAM
            jsr WaitSync    ; wait for another VSync

            lda #$3f        ; set palette regs
            sta PPU_ADDR    ; set PPU_ADDR to $3000
            lda #$00
            sta PPU_ADDR
            lda #$1c        ; $1c = light blue
            sta PPU_DATA    ; set background color

            lda #MASK_BG
            sta PPU_MASK    ; enable background rendering
            lda #CTRL_NMI
            sta PPU_CTRL    ; enable NMI

.endless    jmp .endless    ; endless loop

; Include common support code
            include "helpers.asm"

NMIHandler  rti             ; just return from interrupt

            seg Vectors
            org $fffa

            word NMIHandler ; NMI vector
            word Start      ; reset vector
            word NMIHandler ; IRQ vector
