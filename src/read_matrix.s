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
	addi sp, sp, -28
	sw ra, 0(sp)
	sw s0, 4(sp)
	sw s1, 8(sp)
	sw s2, 12(sp)
	sw s3, 16(sp)
	sw s4, 20(sp)
	sw s5, 24(sp)
	sw s6, 28(sp)
	
	mv s0, a0
	mv s1, a1
	mv s2, a2
	
	# open file
	li a1, 3 # r+ mode
	jal ra, fopen
	li t0, -1
	beq a0, t0, fopen_error
	mv s3, a0 # s3 = file_descriptor

	#read the number of row and col
	mv a0, s3
	mv a1, s1
	li a2, 8
	jal ra, fread
	li t0, 8
	bne a0, t0, fread_error

	# malloc
	lw t0, 0(s1)
	lw t1, 0(s2)
	mul t2, t0, t1
	li t3, 4
	mul t2, t2, t3
	mv s4, t2 # s4 = bytes to read

	mv a0, s4
	jal ra, malloc
	beq a0, zero, malloc_error
	# s5 = pointer_memory
	mv s5, a0 # s5 = buffer to read

	# read file
	mv a0, s3
	mv a1, s5
	mv a2, s4
	jal ra, fread
	mv s6, a0 # s6 = bytes actually read
	bne s6, s4, fread_error

	# close file
	mv a0, s3
	jal ra, fclose
	li t0, -1
	beq a0, t0, fclose_error

	# Epilogue
	mv a0, s5

	lw ra, 0(sp)
	lw s0, 4(sp)
	lw s1, 8(sp)
	lw s2, 12(sp)
	lw s3, 16(sp)
	lw s4, 20(sp)
	lw s5, 24(sp)
	lw s6, 28(sp)
	addi sp, sp, 28
	
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




