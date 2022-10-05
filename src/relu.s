.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
#   a0 (int*) is the pointer to the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   None
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# ==============================================================================
relu:
	# Prologue
	li a4, 1
	blt a1, a4, relu_exception
	li a2, 0
	blt a2, a1, loop_start
	li a1, 0
	ret

loop_start:
	bge a2, a1, loop_end
	lw a3, 0(a0)
	bge a3, zero, loop_continue
	li a3, 0
	sw a3, 0(a0) 
	addi a0, a0, 4
	addi a2, a2, 1
	j loop_start

loop_continue:
	addi a0, a0, 4
	addi a2, a2, 1
	j loop_start

loop_end:


	# Epilogue


	ret

relu_exception:
	li a0, 36
	j exit
