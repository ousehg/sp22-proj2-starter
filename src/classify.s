.globl classify

.text
# =====================================
# COMMAND LINE ARGUMENTS
# =====================================
# Args:
#   a0 (int)        argc
#   a1 (char**)     argv
#   a1[1] (char*)   pointer to the filepath string of m0
#   a1[2] (char*)   pointer to the filepath string of m1
#   a1[3] (char*)   pointer to the filepath string of input matrix
#   a1[4] (char*)   pointer to the filepath string of output file
#   a2 (int)        silent mode, if this is 1, you should not print
#                   anything. Otherwise, you should print the
#                   classification and a newline.
# Returns:
#   a0 (int)        Classification
# Exceptions:
#   - If there are an incorrect number of command line args,
#     this function terminates the program with exit code 31
#   - If malloc fails, this function terminates the program with exit code 26
#
# Usage:
#   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
classify:
	li t0, 5
	bne a0, t0, args_error
	addi sp, sp, -16
	sw s0, 0(sp)
	sw s1, 4(sp)
	sw s2, 8(sp)
	sw s3, 12(sp)

	# Read pretrained m0 - malloc
	addi sp, sp, -12
	sw ra, 0(sp)
	sw a0, 4(sp)
	sw a1, 8(sp)
	sw a2, 12(sp)

	li a0, 8
	jal ra, malloc
	beq a0, zero, malloc_error
	mv t0, a0

	lw ra, 0(sp)
	lw a0, 4(sp)
	lw a1, 8(sp)
	lw a2, 12(sp)
	addi sp, sp, 12

	# Read pretrained m0 - read matrix
	addi sp, sp, -16
	sw ra, 0(sp)
	sw a0, 4(sp)
	sw a1, 8(sp)
	sw a2, 12(sp)
	sw t0, 16(sp)

	lw a0, 4(a1)
	mv a1, t0
	mv a2, t0
	addi a2, a2, 4
	jal ra, read_matrix
	mv a3, a0 # m0 pointer
	lw t0, 16(sp)
	lw a4, 0(t0) # m0 rows
	lw a5, 4(t0) # mo cols

	lw ra, 0(sp)
	lw a0, 4(sp)
	lw a1, 8(sp)
	lw a2, 12(sp)
	addi sp, sp, 16

	# Read pretrained m0 - free
	addi sp, sp, -28
	sw ra, 0(sp)
	sw a0, 4(sp)
	sw a1, 8(sp)
	sw a2, 12(sp)
	sw a3, 16(sp)
	sw a4, 20(sp)
	sw a5, 24(sp)

	mv a0, t0
	jal ra, free

	lw ra, 0(sp)
	lw a0, 4(sp)
	lw a1, 8(sp)
	lw a2, 12(sp)
	lw a3, 16(sp)
	lw a4, 20(sp)
	lw a5, 24(sp)
	addi sp, sp, 28

	# Read pretrained m1 - malloc
	addi sp, sp, -28
	sw ra, 0(sp)
	sw a0, 4(sp)
	sw a1, 8(sp)
	sw a2, 12(sp)
	sw a3, 16(sp)
	sw a4, 20(sp)
	sw a5, 24(sp)

	li a0, 8
	jal ra, malloc
	beq a0, zero, malloc_error
	mv t0, a0

	lw ra, 0(sp)
	lw a0, 4(sp)
	lw a1, 8(sp)
	lw a2, 12(sp)
	lw a3, 16(sp)
	lw a4, 20(sp)
	lw a5, 24(sp)
	addi sp, sp, 28

	# Read pretrained m1 - read matrix
	addi sp, sp, -28
	sw ra, 0(sp)
	sw a0, 4(sp)
	sw a1, 8(sp)
	sw a2, 12(sp)
	sw a3, 16(sp)
	sw a4, 20(sp)
	sw a5, 24(sp)
	sw t0, 28(sp)

	lw a0, 8(a1)
	mv a1, t0
	mv a2, t0
	addi a2, a2, 4
	jal ra, read_matrix
	mv a6, a0 # m1 pointer
	lw t0, 28(sp)
	lw a7, 0(t0) # m1 rows
	lw s0, 4(t0) # m1 cols

	lw ra, 0(sp)
	lw a0, 4(sp)
	lw a1, 8(sp)
	lw a2, 12(sp)
	lw a3, 16(sp)
	lw a4, 20(sp)
	lw a5, 24(sp)
	addi sp, sp, 28

	# Read pretrained m1 - free
	addi sp, sp, -36
	sw ra, 0(sp)
	sw a0, 4(sp)
	sw a1, 8(sp)
	sw a2, 12(sp)
	sw a3, 16(sp)
	sw a4, 20(sp)
	sw a5, 24(sp)
	sw a6, 28(sp)
	sw a7, 32(sp)
	sw s0, 36(sp)

	mv a0, t0
	jal ra, free

	lw ra, 0(sp)
	lw a0, 4(sp)
	lw a1, 8(sp)
	lw a2, 12(sp)
	lw a3, 16(sp)
	lw a4, 20(sp)
	lw a5, 24(sp)
	lw a6, 28(sp)
	lw a7, 32(sp)
	lw s0, 36(sp)
	addi sp, sp, 36

	# Read input matrix -- malloc
	addi sp, sp, -36
	sw ra, 0(sp)
	sw a0, 4(sp)
	sw a1, 8(sp)
	sw a2, 12(sp)
	sw a3, 16(sp)
	sw a4, 20(sp)
	sw a5, 24(sp)
	sw a6, 28(sp)
	sw a7, 32(sp)
	sw s0, 36(sp)

	li a0, 8
	jal ra, malloc
	beq a0, zero, malloc_error
	mv t0, a0

	lw ra, 0(sp)
	lw a0, 4(sp)
	lw a1, 8(sp)
	lw a2, 12(sp)
	lw a3, 16(sp)
	lw a4, 20(sp)
	lw a5, 24(sp)
	lw a6, 28(sp)
	lw a7, 32(sp)
	lw s0, 36(sp)
	addi sp, sp, 36

	# Read input matrix -- read
	addi sp, sp, -40
	sw ra, 0(sp)
	sw a0, 4(sp)
	sw a1, 8(sp)
	sw a2, 12(sp)
	sw a3, 16(sp)
	sw a4, 20(sp)
	sw a5, 24(sp)
	sw a6, 28(sp)
	sw a7, 32(sp)
	sw s0, 36(sp)
	sw t0, 40(sp)

	lw a0, 12(a1)
	mv a1, t0
	mv a2, t0
	addi a2, a2, 4
	jal ra, read_matrix
	mv s1, a0 # input pointer
	lw t0, 40(sp)
	lw s2, 0(t0) # input rows
	lw s3, 4(t0)  # input cols

	lw ra, 0(sp)
	lw a0, 4(sp)
	lw a1, 8(sp)
	lw a2, 12(sp)
	lw a3, 16(sp)
	lw a4, 20(sp)
	lw a5, 24(sp)
	lw a6, 28(sp)
	lw a7, 32(sp)
	lw s0, 36(sp)
	addi sp, sp, 40

	# Read input matrix -- free
	addi sp, sp, -48
	sw ra, 0(sp)
	sw a0, 4(sp)
	sw a1, 8(sp)
	sw a2, 12(sp)
	sw a3, 16(sp)
	sw a4, 20(sp)
	sw a5, 24(sp)
	sw a6, 28(sp)
	sw a7, 32(sp)
	sw s0, 36(sp)
	sw s1, 40(sp)
	sw s2, 44(sp)
	sw s3, 48(sp)

	mv a0, t0
	jal ra, free

	lw ra, 0(sp)
	lw a0, 4(sp)
	lw a1, 8(sp)
	lw a2, 12(sp)
	lw a3, 16(sp)
	lw a4, 20(sp)
	lw a5, 24(sp)
	lw a6, 28(sp)
	lw a7, 32(sp)
	lw s0, 36(sp)
	lw s1, 40(sp)
	lw s2, 44(sp)
	lw s3, 48(sp)
	addi sp, sp, 48

	# Compute h = matmul(m0, input) - malloc
	addi sp, sp, -48
	sw ra, 0(sp)
	sw a0, 4(sp)
	sw a1, 8(sp)
	sw a2, 12(sp)
	sw a3, 16(sp)
	sw a4, 20(sp)
	sw a5, 24(sp)
	sw a6, 28(sp)
	sw a7, 32(sp)
	sw s0, 36(sp)
	sw s1, 40(sp)
	sw s2, 44(sp)
	sw s3, 48(sp)

	mul t0, a4, s3
	li t1, 4
	mul t0, t0, t1
	mv a0, t0
	jal ra, malloc
	beq a0, zero, malloc_error
	mv t0, a0

	lw ra, 0(sp)
	lw a0, 4(sp)
	lw a1, 8(sp)
	lw a2, 12(sp)
	lw a3, 16(sp)
	lw a4, 20(sp)
	lw a5, 24(sp)
	lw a6, 28(sp)
	lw a7, 32(sp)
	lw s0, 36(sp)
	lw s1, 40(sp)
	lw s2, 44(sp)
	lw s3, 48(sp)
	addi sp, sp, 48

	# Compute h = matmul(m0, input) - matmul
	addi sp, sp, -48
	sw ra, 0(sp)
	sw a0, 4(sp)
	sw a1, 8(sp)
	sw a2, 12(sp)
	sw a3, 16(sp)
	sw a4, 20(sp)
	sw a5, 24(sp)
	sw a6, 28(sp)
	sw a7, 32(sp)
	sw s0, 36(sp)
	sw s1, 40(sp)
	sw s2, 44(sp)
	sw s3, 48(sp)

	mv a0, a3
	mv a1, a4
	mv a2, a5
	mv a3, s1
	mv a4, s2
	mv a5, s3
	mv a6, t0
	jal ra, matmul # Compute h = matmul(m0, input) - matmul
	mv t0, a6

	lw ra, 0(sp)
	lw a0, 4(sp)
	lw a1, 8(sp)
	lw a2, 12(sp)
	lw a3, 16(sp)
	lw a4, 20(sp)
	lw a5, 24(sp)
	lw a6, 28(sp)
	lw a7, 32(sp)
	lw s0, 36(sp)
	lw s1, 40(sp)
	lw s2, 44(sp)
	lw s3, 48(sp)
	addi sp, sp, 48

	# Compute h = relu(h)
	addi sp, sp, -48
	sw ra, 0(sp)
	sw a0, 4(sp)
	sw a1, 8(sp)
	sw a2, 12(sp)
	sw a3, 16(sp)
	sw a4, 20(sp)
	sw a5, 24(sp)
	sw a6, 28(sp)
	sw a7, 32(sp)
	sw s0, 36(sp)
	sw s1, 40(sp)
	sw s2, 44(sp)
	sw s3, 48(sp)

	mv a0, t0
	mul t1, a4, s3
	li t2, 4
	mul t1, t1, t2
	mv a1, t1
	jal ra, relu
	mv t0, a0
	
	lw ra, 0(sp)
	lw a0, 4(sp)
	lw a1, 8(sp)
	lw a2, 12(sp)
	lw a3, 16(sp)
	lw a4, 20(sp)
	lw a5, 24(sp)
	lw a6, 28(sp)
	lw a7, 32(sp)
	lw s0, 36(sp)
	lw s1, 40(sp)
	lw s2, 44(sp)
	lw s3, 48(sp)
	addi sp, sp, 48


	# Compute o = matmul(m1, h) - malloc
	addi sp, sp, -52
	sw ra, 0(sp)
	sw a0, 4(sp)
	sw a1, 8(sp)
	sw a2, 12(sp)
	sw a3, 16(sp)
	sw a4, 20(sp)
	sw a5, 24(sp)
	sw a6, 28(sp)
	sw a7, 32(sp)
	sw s0, 36(sp)
	sw s1, 40(sp)
	sw s2, 44(sp)
	sw s3, 48(sp)
	sw t0, 52(sp)

	mul t0, a7, s3
	li t1, 4
	mul t0, t0, t1
	jal ra, malloc
	beq a0, zero, malloc_error
	mv t1, a0

	lw ra, 0(sp)
	lw a0, 4(sp)
	lw a1, 8(sp)
	lw a2, 12(sp)
	lw a3, 16(sp)
	lw a4, 20(sp)
	lw a5, 24(sp)
	lw a6, 28(sp)
	lw a7, 32(sp)
	lw s0, 36(sp)
	lw s1, 40(sp)
	lw s2, 44(sp)
	lw s3, 48(sp)
	lw t0, 52(sp)
	addi sp, sp, 52

	# Compute o = matmul(m1, h) - matmul
	addi sp, sp, -52
	sw ra, 0(sp)
	sw a0, 4(sp)
	sw a1, 8(sp)
	sw a2, 12(sp)
	sw a3, 16(sp)
	sw a4, 20(sp)
	sw a5, 24(sp)
	sw a6, 28(sp)
	sw a7, 32(sp)
	sw s0, 36(sp)
	sw s1, 40(sp)
	sw s2, 44(sp)
	sw s3, 48(sp)
	sw t0, 52(sp)

	mv a0, a6
	mv a1, a7
	mv a2, s0
	mv a3, t0
	mv a4, a4
	mv a5, s3
	mv a6, t1
	jal ra, matmul # Compute o = matmul(m1, h) - matmul
	mv t1, a6

	lw ra, 0(sp)
	lw a0, 4(sp)
	lw a1, 8(sp)
	lw a2, 12(sp)
	lw a3, 16(sp)
	lw a4, 20(sp)
	lw a5, 24(sp)
	lw a6, 28(sp)
	lw a7, 32(sp)
	lw s0, 36(sp)
	lw s1, 40(sp)
	lw s2, 44(sp)
	lw s3, 48(sp)
	lw t0, 52(sp)
	addi sp, sp, 52


	# Write output matrix o
	addi sp, sp, -56
	sw ra, 0(sp)
	sw a0, 4(sp)
	sw a1, 8(sp)
	sw a2, 12(sp)
	sw a3, 16(sp)
	sw a4, 20(sp)
	sw a5, 24(sp)
	sw a6, 28(sp)
	sw a7, 32(sp)
	sw s0, 36(sp)
	sw s1, 40(sp)
	sw s2, 44(sp)
	sw s3, 48(sp)
	sw t0, 52(sp)
	sw t1, 56(sp)

	lw a0, 16(a1)
	mv a1, t1
	mv a2, a7
	mv a3, s3
	jal ra, write_matrix

	lw ra, 0(sp)
	lw a0, 4(sp)
	lw a1, 8(sp)
	lw a2, 12(sp)
	lw a3, 16(sp)
	lw a4, 20(sp)
	lw a5, 24(sp)
	lw a6, 28(sp)
	lw a7, 32(sp)
	lw s0, 36(sp)
	lw s1, 40(sp)
	lw s2, 44(sp)
	lw s3, 48(sp)
	lw t0, 52(sp)
	lw t1, 56(sp)
	addi sp, sp, 56

	# Compute and return argmax(o)
	addi sp, sp, -56
	sw ra, 0(sp)
	sw a0, 4(sp)
	sw a1, 8(sp)
	sw a2, 12(sp)
	sw a3, 16(sp)
	sw a4, 20(sp)
	sw a5, 24(sp)
	sw a6, 28(sp)
	sw a7, 32(sp)
	sw s0, 36(sp)
	sw s1, 40(sp)
	sw s2, 44(sp)
	sw s3, 48(sp)
	sw t0, 52(sp)
	sw t1, 56(sp)

	mv a0, t1
	mul t2, a7, s3
	mv a1, t2
	jal ra, argmax
	mv t3, a0

	lw ra, 0(sp)
	lw a0, 4(sp)
	lw a1, 8(sp)
	lw a2, 12(sp)
	lw a3, 16(sp)
	lw a4, 20(sp)
	lw a5, 24(sp)
	lw a6, 28(sp)
	lw a7, 32(sp)
	lw s0, 36(sp)
	lw s1, 40(sp)
	lw s2, 44(sp)
	lw s3, 48(sp)
	lw t0, 52(sp)
	lw t1, 56(sp)
	addi sp, sp, 56

	# free t0
	addi sp, sp, -56
	sw ra, 0(sp)
	sw a0, 4(sp)
	sw a1, 8(sp)
	sw a2, 12(sp)
	sw a3, 16(sp)
	sw a4, 20(sp)
	sw a5, 24(sp)
	sw a6, 28(sp)
	sw a7, 32(sp)
	sw s0, 36(sp)
	sw s1, 40(sp)
	sw s2, 44(sp)
	sw s3, 48(sp)
	sw t1, 52(sp)
	sw t2, 56(sp)

	mv a0, t0
	jal ra, free

	lw ra, 0(sp)
	lw a0, 4(sp)
	lw a1, 8(sp)
	lw a2, 12(sp)
	lw a3, 16(sp)
	lw a4, 20(sp)
	lw a5, 24(sp)
	lw a6, 28(sp)
	lw a7, 32(sp)
	lw s0, 36(sp)
	lw s1, 40(sp)
	lw s2, 44(sp)
	lw s3, 48(sp)
	lw t1, 52(sp)
	lw t2, 56(sp)
	addi sp, sp, 56

	# free t1
	addi sp, sp, -52
	sw ra, 0(sp)
	sw a0, 4(sp)
	sw a1, 8(sp)
	sw a2, 12(sp)
	sw a3, 16(sp)
	sw a4, 20(sp)
	sw a5, 24(sp)
	sw a6, 28(sp)
	sw a7, 32(sp)
	sw s0, 36(sp)
	sw s1, 40(sp)
	sw s2, 44(sp)
	sw s3, 48(sp)
	sw t2, 52(sp)

	mv a0, t1
	jal ra, free

	lw ra, 0(sp)
	lw a0, 4(sp)
	lw a1, 8(sp)
	lw a2, 12(sp)
	lw a3, 16(sp)
	lw a4, 20(sp)
	lw a5, 24(sp)
	lw a6, 28(sp)
	lw a7, 32(sp)
	lw s0, 36(sp)
	lw s1, 40(sp)
	lw s2, 44(sp)
	lw s3, 48(sp)
	lw t2, 52(sp)
	addi sp, sp, 52

	# If enabled, print argmax(o) and newline

	sw t2, 16(sp)
	mv a0, t2
	# beq a2, zero, print_int
	lw s0, 0(sp)
	lw s1, 4(sp)
	lw s2, 8(sp)
	lw s3, 12(sp)
	lw a0, 16(sp)
	addi sp, sp, 16

	ret

args_error:
	li a0, 31
	j exit

malloc_error: 
	li a0, 26
	j exit
