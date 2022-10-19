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
	addi sp, sp, -52
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
	sw s9, 40(sp)
	sw s10, 44(sp)
	sw s11, 48(sp)

	mv s0, a0
	mv s1, a1
	mv s2, a2

	# ===========================
	# Read pretrained m0 - malloc
	# ===========================

	li a0, 8
	jal ra, malloc
	beq a0, zero, malloc_error
	mv s5, a0

	# ===========================
	# Read pretrained m0 - read matrix
	# ===========================

	lw a0, 4(s1)
	mv a1, s5
	mv a2, s5
	addi a2, a2, 4
	jal ra, read_matrix
	mv s3, a0 # m0 pointer
	mv a0, s5 # to free
	lw s4, 0(s5) # m0 rows
	lw s5, 4(s5) # mo cols

	# ===========================
	# Read pretrained m0 - free
	# ===========================

	jal ra, free

	# ===========================
	# Read pretrained m1 - malloc
	# ===========================

	li a0, 8
	jal ra, malloc
	beq a0, zero, malloc_error
	mv s8, a0

	# ===========================
	# Read pretrained m1 - read matrix
	# ===========================

	lw a0, 8(s1)
	mv a1, s8
	mv a2, s8
	addi a2, a2, 4
	jal ra, read_matrix
	mv s6, a0 # m1 pointer
	mv a0, s8 # to free
	lw s7, 0(s8) # m1 rows
	lw s8, 4(s8) # m1 cols

	# ===========================
	# Read pretrained m1 - free
	# ===========================

	jal ra, free

	# ===========================
	# Read input matrix -- malloc
	# ===========================

	li a0, 8
	jal ra, malloc
	beq a0, zero, malloc_error
	mv s11, a0

	# ===========================
	# Read input matrix -- read
	# ===========================

	lw a0, 12(s1)
	mv a1, s11
	mv a2, s11
	addi a2, a2, 4
	jal ra, read_matrix
	mv s9, a0 # input pointer
	mv a0, s11 # to free
	lw s10, 0(s11) # input rows
	lw s11, 4(s11)  # input cols

	# ===========================
	# Read input matrix -- free
	# ===========================

	jal ra, free

	# ===========================
	# Compute h = matmul(m0, input) - malloc
	# ===========================

	mul t0, s4, s11
	li t1, 4
	mul t0, t0, t1
	mv a0, t0
	jal ra, malloc
	beq a0, zero, malloc_error
	mv s0, a0

	# ===========================
	# Compute h = matmul(m0, input) - matmul
	# ===========================

	mv a0, s3
	mv a1, s4
	mv a2, s5
	mv a3, s9
	mv a4, s10
	mv a5, s11
	mv a6, s0
	jal ra, matmul # Compute h = matmul(m0, input) - matmul

	# ===========================
	# Compute h = relu(h)
	# ===========================

	mv a0, s0
	mul a1, s4, s11
	jal ra, relu

	# ===========================
	# Compute o = matmul(m1, h) - malloc
	# ===========================

	mul t0, s7, s11
	li t1, 4
	mul t0, t0, t1
	jal ra, malloc
	beq a0, zero, malloc_error
	mv t0, a0

	# ===========================
	# Compute o = matmul(m1, h) - matmul
	# ===========================

	mv a0, s6
	mv a1, s7
	mv a2, s8
	mv a3, s0
	mv a4, s4
	mv a5, s11
	mv a6, t0
	jal ra, matmul # Compute o = matmul(m1, h) - matmul
	mv s3, a0 # pointer of o

	# ===========================
	# Write output matrix o
	# ===========================

	lw a0, 16(s1)
	mv a1, s3
	mv a2, s7
	mv a3, s11
	jal ra, write_matrix

	# ===========================
	# Compute and return argmax(o)
	# ===========================

	mv a0, s3
	mul a1, s7, s11
	jal ra, argmax
	mv s6, a0

	# ===========================
	# free t0, t1, t2
	# ===========================

	mv a0, s0
	jal ra, free

	mv a0, s3
	jal ra, free

	# If enabled, print argmax(o) and newline

	mv a0, s6
	# beq s2, zero, print_int
	# mv a0, '\n'
	# beq s2, zero, print_char

	# mv a0, s6

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
	lw s9, 40(sp)
	lw s10, 44(sp)
	lw s11, 48(sp)
	addi sp, sp, 52

	ret

args_error:
	li a0, 31
	j exit

malloc_error: 
	li a0, 26
	j exit
