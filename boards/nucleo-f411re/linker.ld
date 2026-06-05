
ENTRY(Reset_Handler)

MEMORY {
    FLASH   (rx)    : ORIGIN = 0x08000000, LENGTH = 512K
    RAM     (rwx)   : ORIGIN = 0x20000000, LENGTH = 128K
}
 
/* Point to top of stack / end of RAM (Cortex-M implements full-descending stack) */
_estack = ORIGIN(RAM) + LENGTH(RAM);

SECTIONS {
    /* Vector table (must be first in Flash) */
    .isr_vector :
    {
        KEEP(*(.isr_vector))
        . = ALIGN(4);
    } > FLASH

    /* Program code */
    .text :
    {
        . = ALIGN(4);
        *(.text*)
        . = ALIGN(4);
    } > FLASH

    /* Read-only data */
    .rodata :
    {
        . = ALIGN(4);
        *(.rodata*)
        . = ALIGN(4);
    } > FLASH

    /* Initialized data
        - Stored in FLASH in the image (LMA)
        - Lives in RAM at runtime (VMA) */
    .data :
    {
        . = ALIGN(4);
        _sdata = .;
        *(.data*)
        . = ALIGN(4);
        _edata = .;
    } > RAM AT> FLASH

    /* Point to Initialized data values in FLASH (LMA) */
    _sidata = LOADADDR(.data);

    /* Zero-Initialized data (no FLASH image needed) */
    .bss :
    {
        . = ALIGN(4);
        _sbss = .;
        *(.bss*) 
        *(COMMON)
        . = ALIGN(4);
        _ebss = .;
    } > RAM
}