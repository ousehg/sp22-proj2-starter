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
	addi sp, sp, -40
	sw ra, 0(sp)
	sw s0, 4(sp)
	sw s1, 8(sp)
	sw s2, 12(sp)
	sw s3, 16(sp)
	sw s4, 20(sp)
	sw s5, 24(sp)
	sw s6, 28(sp)
	sw s7, 32(sp)
	sw s8, 36(sp)

	mv s0, a0
	mv s1, a1
	mv s2, a2
	mv s3, a3
	mv s4, a4
	mv s5, a5
	mv s6, a6
	li s7, 0 # index of rows

outer_loop_start:
	beq s7, s1, outer_loop_end 

	li s8, 0 # index of cols


inner_loop_start:
	beq s8, s5, inner_loop_end

	# set first array
	mul t0, s7, s2
	li t1, 4
	mul t0, t0, t1
	add a0, s0, t0

	# set second array
	li t1, 4
	mul t0, s8, t1
	add a1, s3, t0

	# set number of elements
	mv a2, s2

	# set stride of a1
	li a3, 1

	# set stride of a2 
	mv a4, s5

	# product 
	jal ra, dot

	# update d
	sw a0, 0(s6)

	# update pointer of d
	li t1, 4
	add s6, s6, t1
	
	# update s8
	addi s8, s8, 1
	j inner_loop_start

inner_loop_end:

	addi s7, s7, 1
	j outer_loop_start


outer_loop_end:


	# Epilogue

	lw ra, 0(sp)
	lw s0, 4(sp)
	lw s1, 8(sp)
	lw s2, 12(sp)
	lw s3, 16(sp)
	lw s4, 20(sp)
	lw s5, 24(sp)
	lw s6, 28(sp)
	lw s7, 32(sp)
	lw s8, 36(sp)
	addi sp, sp, 40

	ret

error:
	li a0, 38
	j exit