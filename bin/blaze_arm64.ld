ENTRY(_start)

MEMORY
{
    RAM (rwx) : ORIGIN = 0x40000000, LENGTH = 16M
}

SECTIONS
{
    /* Текст (код) */
    .text 0x40000000 :
    {
        *(.text*)
        *(.rodata*)
        *(.glue_7)
        *(.glue_7t)
        _etext = .; /* конец кода */
    } > RAM

    /* Данные инициализированные */
    .data :
    {
        _sdata = .;
        *(.data*)
        _edata = .;
    } > RAM

    /* BSS - неинициализированные данные */
    .bss :
    {
        _sbss = .;
        *(.bss*)
        KEEP(*(COMMON))
        _ebss = .;
    } > RAM

    .stack (NOLOAD) :
    {
        _sstack = .;
        . = . + 0x2000;
        _estack = .;
    } > RAM
}