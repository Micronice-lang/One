#include "asm.h"

.extern _main
.extern _memset
.extern __stack_start
.extern __stack_end

.extern __InitBATS
.extern __InitPS
.extern __InitFPRS
.extern __InitCache
.extern __InitSystem

.equ _stack_size, 0x00010000

.text
.section .init

    .globl _start
_start:
	bl		__InitBATS			# Initialize BATs to a clear and known state
	bl		__InitGPRS			# Initialize the General Purpose Registers
	bl		__InitHardware		# Initialize some aspects of the Hardware
	bl		__InitSystem		# Initialize more cache aspects, clear a few SPR's, and disable interrupts.
    
    b       _main

__InitGPRS:
	# Clear all of the GPR's to 0
	li      r0,0
	li      r3,0
	li      r4,0
	li      r5,0
	li      r6,0
	li      r7,0
	li      r8,0
	li      r9,0
	li      r10,0
	li      r11,0
	li      r12,0
	li      r14,0
	li      r15,0
	li      r16,0
	li      r17,0
	li      r18,0
	li      r19,0
	li      r20,0
	li      r21,0
	li      r22,0
	li      r23,0
	li      r24,0
	li      r25,0
	li      r26,0
	li      r27,0
	li      r28,0
	li      r29,0
	li      r30,0
	li      r31,0

    lis     r1, _stack_end@h
    ori    r1, r1, _stack_end@l
    li      r0, 0x00
    stwu    r0, -0x40(r1)

__InitHardware:
	# Enable the Floating Point Registers
	mfmsr   r3
	ori     r3,r3,MSR_FP
	mtmsr   r3

	mflr	r31
	bl		__InitPS 			# Initialize Paired Singles
	bl		__InitFPRS		 	# Initialize the FPR's
	bl		__InitCache 		# Initialize the system caches
	mtlr	r31
	blr

.section .stack
    .globl _stack_start
_stack_start:
    .space _stack_size
    .globl _stack_end
_stack_end:
