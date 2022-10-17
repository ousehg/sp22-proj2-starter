.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int arrays
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the number of elements to use
#   a3 (int)  is the stride of arr0
#   a4 (int)  is the stride of arr1
# Returns:
#   a0 (int)  is the dot product of arr0 and arr1
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
#   - If the stride of either array is less than 1,
#     this function terminates the program with error code 37
# =======================================================
dot:

	# Prologue
	li a5, 1
	blt a2, a5, length_error
	blt a3, a5, stride_error
	blt a4, a5, stride_error

	# set counter 
	li a6, 0
	# set pointer offset
	li t3, 0
	# set product
	li a7, 0

loop_start:
	beq a6, a2, loop_end 
	# set pointer
	add a0, a0, t3
	add a1, a1, t3
	# load value 
	lw t0, 0(a0)
	lw t1, 0(a1)
	# update product
	mul t2, t0, t1
	add a7, a7, t2
	# update pointer offset 
	li t0, 4
	# pointer offset for array
	mul t1, a3, t0
	mul t2, a4, t0
	# update pointer for array
	add a0, a0, t1
	add a1, a1, t2
	# update counter 
	addi a6, a6, 1
	j loop_start




loop_end:


	# Epilogue
	addi a0, a7, 0

	ret

length_error: 
	li a0, 36
	j exit

stride_error:
	li a0, 37
	j exit