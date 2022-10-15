.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
#   - If malloc returns an error,
#     this function terminates the program with error code 26
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fread error or eof,
#     this function terminates the program with error code 29
# ==============================================================================
read_matrix:

	# Prologue
	# open file
	addi sp, sp, -12
	sw ra, 0(sp)
	sw a0, 4(sp)
	sw a1, 8(sp)
	sw a2, 12(sp)
	
	li a1, 3
	jal ra, fopen
	li t0, -1
	beq a0, t0, fopen_error
	# a3 = file_descriptor
	mv a3, a0
	lw ra, 0(sp)
	lw a0, 4(sp)
	lw a1, 8(sp)
	lw a2, 12(sp)
	addi sp, sp, 12

	#read the number of row and col
	addi sp, sp, -16
	sw ra, 0(sp)
	sw a0, 4(sp)
	sw a1, 8(sp)
	sw a2, 12(sp)
	sw a3, 16(sp)

	mv a0, a3
	li a2, 8
	jal ra, fread
	li t0, 8
	bne a0, t0, fread_error

	lw ra, 0(sp)
	lw a0, 4(sp)
	lw a1, 8(sp)
	lw a2, 12(sp)
	lw a3, 16(sp)
	addi sp, sp, 16

	# malloc
	lw t0, 0(a1)
	lw t1, 0(a2)
	mul t2, t0, t1
	li t3, 4
	mul t2, t2, t3
	mv a4, t2

	addi sp, sp, -24
	sw ra, 0(sp)
	sw a0, 4(sp)
	sw a1, 8(sp)
	sw a2, 12(sp)
	sw a3, 16(sp)
	sw a4, 20(sp)

	mv a0, a4
	jal ra, malloc
	beq a0, zero, malloc_error
	# a5 = pointer_memory
	mv a5, a0 
	lw ra, 0(sp)
	lw a0, 4(sp)
	lw a1, 8(sp)
	lw a2, 12(sp)
	lw a3, 16(sp)
	lw a4, 20(sp)
	addi sp, sp, 24

	# read file
	addi sp, sp, -28
	sw ra, 0(sp)
	sw a0, 4(sp)
	sw a1, 8(sp)
	sw a2, 12(sp)
	sw a3, 16(sp)
	sw a4, 20(sp)
	sw a5, 24(sp)

	mv a0, a3
	mv a1, a5
	mv a2, a4
	jal ra, fread
	# a6 = actual_bytes_read
	mv a6, a0 
	lw ra, 0(sp)
	lw a0, 4(sp)
	lw a1, 8(sp)
	lw a2, 12(sp)
	lw a3, 16(sp)
	lw a4, 20(sp)
	lw a5, 24(sp)
	bne a6, a4, fread_error
	addi sp, sp, 28

	# close file
	addi sp, sp, -28
	sw ra, 0(sp)
	sw a0, 4(sp)
	sw a1, 8(sp)
	sw a2, 12(sp)
	sw a3, 16(sp)
	sw a4, 20(sp)
	sw a5, 24(sp)

	mv a0, a3
	jal ra, fclose
	li t0, -1
	beq a0, t0, fclose_error
	lw ra, 0(sp)
	lw a0, 4(sp)
	lw a1, 8(sp)
	lw a2, 12(sp)
	lw a3, 16(sp)
	lw a4, 20(sp)
	lw a5, 24(sp)
	addi sp, sp, 28

	# Epilogue
	mv a0, a5
	
	ret

malloc_error: 
	li a0, 26
	j exit

fopen_error: 
	li a0, 27
	j exit

fclose_error: 
	li a0, 28
	j exit

fread_error: 
	li a0, 29
	j exit




