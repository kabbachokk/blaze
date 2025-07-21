    /* aarch64 startup code */

.extern main
.extern _sbss
.extern _ebss
.extern _sstack
.extern _estack

#ifdef __ILP32__
#define PTR_REG(n)	w##n
#define PTR_SIZE	4
#define PTR_LOG_SIZE	2
#else
#define PTR_REG(n)	x##n
#define PTR_SIZE	8
#define PTR_LOG_SIZE	3
#endif

.macro func name
    .global \name 
    .type \name,STT_FUNC 
\name:
.endm

/*  TODO: :lo12: and bare syntax for adrp is also the ELF/Linux way of writing it. 
On Apple it's
adrp xD, label@PAGE
add xD, xD, label@PAGEOFF
*/
.macro adrl reg, symbol
    adrp \reg, \symbol 
    add  \reg, \reg, :lo12:\symbol 
.endm

    .text
    .align 2
func _mainCRTStartup
func _start
func start
    msr		DAIFSet, 0xf

    /* Save command line descriptor for later use. 
    mov 	x8, x0*/
    adrl x8, .Lcmdline_test

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

    /* Fetch and parse the command line.  */
	mov	x0, #0		/* argc */
	mov	x1, sp		/* argv */

	/* Put NULL at end of argv array.  */
	str	PTR_REG (0), [x1, #-PTR_SIZE]!

	/* Skip leading blanks.  */
.Lnext: 
    ldrb w3, [x8], #1
	cbz	w3, .Lendstr
	cmp	w3, #' '
	b.eq	.Lnext

	mov	w4, #' '	/* Terminator is space.  */

	/* See whether we are scanning a quoted string by checking for
	   opening quote (" or ').  */
	subs	w9, w3, #'\"'
	sub	x8, x8, #1	/* Backup if no match.  */
	ccmp	w9, #('\'' - '\"'), 0x4 /* FLG_Z */, ne
	csel	w4, w3, w4, eq	/* Terminator = quote if match.  */
	cinc	x8, x8, eq

	/* Push arg pointer to argv, and bump argc.  */
	str	PTR_REG (8), [x1, #-PTR_SIZE]!
	add	x0, x0, #1

	/* Find end of arg string.  */
1:	ldrb	w3, [x8], #1
	cbz	w3, .Lendstr
	cmp	w4, w3		/* Reached terminator?  */
	b.ne	1b

	/* Terminate the arg string with NUL char.  */
	mov	w4, #0
	strb	w4, [x8, #-1]
	b	.Lnext

	/* Reverse argv array.  */
.Lendstr:
	add	x3, x1, #0			/* sp = &argv[0] */
	add	x4, x1, w0, uxtw #PTR_LOG_SIZE	/* ep = &argv[argc] */
	cmp	x4, x3
	b.lo	2f
1:	ldr	PTR_REG (5), [x4, #-PTR_SIZE]	/* PTR_REG (5) = ep[-1] */
	ldr	PTR_REG (6), [x3]		/* PTR_REG (6) = *sp */
	str	PTR_REG (6), [x4, #-PTR_SIZE]!	/* *--ep = PTR_REG (6) */
	str	PTR_REG (5), [x3], #PTR_SIZE	/* *sp++ = PTR_REG (5) */
	cmp	x4, x3
	b.hi	1b
2:
	/* Move sp to the 16B boundary below argv.  */
	and	x4, x1, #~0xF
	mov	sp, x4

	/*adrl x3, main
    b   x3   noret */
    b   main

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

.section .rodata
.align 3
.Lcmdline_test:
.asciz "serial1:115200n8 arg1 'arg2'"