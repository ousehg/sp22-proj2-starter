.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
#   d = matmul(m0, m1)
# Arguments:
#   a0 (int*)  is the pointer to the start of m0
#   a1 (int)   is the # of rows (height) of m0
#   a2 (int)   is the # of columns (width) of m0
#   a3 (int*)  is the pointer to the start of m1
#   a4 (int)   is the # of rows (height) of m1
#   a5 (int)   is the # of columns (width) of m1
#   a6 (int*)  is the pointer to the the start of d
# Returns:
#   None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 38
# =======================================================
matmul:

	# Error checks
	li t0, 1
	blt a1, t0, error
	blt a2, t0, error
	blt a4, t0, error
	blt a5, t0, error
	# bne a1, a5, error
	bne a2, a4, error

	# Prologue
	addi sp, sp, -4
	sw ra, 0(sp)

	li t0, 0

outer_loop_start:
	beq t0, a1, outer_loop_end

	li t1, 0


inner_loop_start:
	beq t1, a5, inner_loop_end

	# Prologue
	addi sp, sp, -40
	sw ra, 0(sp)
	sw a0, 4(sp)
	sw a1, 8(sp)
	sw a2, 12(sp)
	sw a3, 16(sp)
	sw a4, 20(sp)
	sw a5, 24(sp)
	sw a6, 28(sp)
	sw t0, 32(sp)
	sw t1, 36(sp)

	# index of a6
	# mul t2, t0, a2
	mul t2, t0, a5
	add t2, t2, t1 

	# update pointer of a6
	li t3, 4
	mul t2, t2, t3 
	add a6, a6, t2
	sw a6, 40(sp)

	# update pointer of a1
	mul t4, t0, a2
	mul t4, t4, t3
	add a0, a0, t4

	# update pointer of a2
	mul t5, t1, t3
	add a1, a3, t5

	# set number of elements
	addi a2, a2, 0

	# set stride of a1
	li a3, 1

	# set stride of a2 
	addi a4, a5, 0

	# product 
	jal ra, dot

	# update a6
	lw a6, 40(sp)
	sw a0, 0(a6)

	# Epilogue

	lw ra, 0(sp)
	lw a0, 4(sp)
	lw a1, 8(sp)
	lw a2, 12(sp)
	lw a3, 16(sp)
	lw a4, 20(sp)
	lw a5, 24(sp)
	lw a6, 28(sp)
	lw t0, 32(sp)
	lw t1, 36(sp)
	addi sp, sp, 40
	
	# update t1
	addi t1, t1, 1
	j inner_loop_start

inner_loop_end:

	addi t0, t0, 1
	j outer_loop_start


outer_loop_end:


	# Epilogue
	lw ra, 0(sp)
	addi sp, sp, 4

	ret

error:
	li a0, 38
	j exit