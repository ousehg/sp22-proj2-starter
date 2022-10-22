.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fwrite error or eof,
#     this function terminates the program with error code 30
# ==============================================================================
write_matrix:

	# Prologue
	addi sp, sp, -28
	sw ra, 0(sp)
	sw s0, 4(sp)
	sw s1, 8(sp)
	sw s2, 12(sp)
	sw s3, 16(sp)
	sw s4, 20(sp)
	sw s5, 24(sp)

	mv s0, a0
	mv s1, a1
	mv s2, a2
	mv s3, a3

	# open file
	li a1, 4 # mode w+
	jal ra, fopen
	li t0, -1
	beq a0, t0, fopen_error
	mv s4, a0 # s4 = file_descriptor

	# write file - malloc
	li a0, 8
	jal ra, malloc
	beq a0, zero, malloc_error
	mv s5, a0 # s5 = buffer for rows and cols
	sw s2 0(s5)
	sw s3 4(s5)

	# write file - number of rows and cols
	mv a0, s4
	mv a1, s5
	li a2, 2
	li a3, 4
	jal ra, fwrite
	li t0, 2
	bne a0, t0, fwrite_error

	# write file - free
	mv a0, s5
	jal ra, free

	# write file - data
	mv a0, s4
	mv a1, s1
	mul a2, s2, s3
	li a3, 4
	jal ra, fwrite
	mul t0, s2, s3
	bne a0, t0, fwrite_error

	# close file
	mv a0, s4
	jal ra, fclose
	li t0, -1
	beq a0, t0, fclose_error

	# Epilogue
	lw ra, 0(sp)
	lw s0, 4(sp)
	lw s1, 8(sp)
	lw s2, 12(sp)
	lw s3, 16(sp)
	lw s4, 20(sp)
	lw s5, 24(sp)
	addi sp, sp, 28

	ret

fopen_error: 
	li a0, 27
	j exit

fclose_error: 
	li a0, 28
	j exit

fwrite_error:
	li a0, 30
	j exit

malloc_error: 
	li a0, 26
	j exit