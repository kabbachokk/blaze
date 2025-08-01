    /* aarch64 startup code */

    /* TODO: :lo12: and bare syntax for adrp is also the ELF/Linux way of writing it. On Apple it's */
    /* adrp \reg, \symbol @PAGE */
    /* add \reg, \reg, \symbol @PAGEOFF */
.macro adrl reg, symbol
    adrp \reg, \symbol 
    add  \reg, \reg, :lo12:\symbol 
.endm

    .text
    .align 2
    .global _start
    .type _start,STT_FUNC 
_start:
    msr		DAIFSet, 0xf

    /* Save dtb for later*/
    mov x20, x0

    /* Setup stack pointer */
    adrl 	x0, _estack
    /* Align SP to 16 bytes */
    and		x0, x0, #~0xF
    mov		sp, x0

    adrl x0, _sbss
    adrl x1, _ebss
    /* Zero bss */
1:  cmp x0, x1
    b.cs 2f
    str xzr, [x0],#0x8
    b 1b
2:
    msr tpidr_el1, xzr
    msr cntv_cval_el0, xzr
    adrl x2, .Learly_vectors
    msr vbar_el1, x2

    mov x0, x20 /* dtb */
	/*adrl x3, _main
    b   x3   noret */
    b   _main

    /* Exception vector entries */
sp0_sync:
sp0_irq:
sp0_fiq:
sp0_serror:
spx_sync:
spx_irq:
spx_fiq:
spx_serror:
a64_sync:
a64_irq:
a64_fiq:
a64_serror:
a32_sync:
a32_irq:
a32_fiq:
a32_serror:
1:  wfi
    b   1b

    .macro vector_entry label
        .align 7
        b   \label
    .endm

    .align 7
.Learly_vectors:
    vector_entry sp0_sync
    vector_entry sp0_irq
    vector_entry sp0_fiq
    vector_entry sp0_serror
    vector_entry spx_sync
    vector_entry spx_irq
    vector_entry spx_fiq
    vector_entry spx_serror
    vector_entry a64_sync
    vector_entry a64_irq
    vector_entry a64_fiq
    vector_entry a64_serror
    vector_entry a32_sync
    vector_entry a32_irq
    vector_entry a32_fiq
    vector_entry a32_serror

    /* void _main(void*) */
.extern _main
.extern _sbss
.extern _ebss
.extern _sstack
.extern _estack