.globl argmax

.text
# =================================================================
# FUNCTION: Given a int array, return the index of the largest
#   element. If there are multiple, return the one
#   with the smallest index.
# Arguments:
#   a0 (int*) is the pointer to the start of the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   a0 (int)  is the first index of the largest element
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# =================================================================
argmax:
	# Prologue
	li a2, 1
	blt a1, a2, argmax_error
	# index of array
	li a3, 0
	# index of max
	li a4, 0
	# value of max
	lw a5, 0(a0)
	lw a6, 0(a0)

loop_start:
	bge a3, a1, loop_end
	# load current value
	lw a6, 0(a0)
	bge a5, a6, loop_continue
	# update index of max
	addi a4, a3, 0
	# update value of max
	add a5, a6, zero
	j loop_start


loop_continue:
	# update index of array
	addi a3, a3, 1
	# update pointer of array
	addi a0, a0, 4
	j loop_start


loop_end:
	# Epilogue
	addi a0, a4, 0
	ret

argmax_error:
	li a0, 36
	j exit
