.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 78.
# ==============================================================================
relu:
    # Prologue
    li t0 1
    blt a1, t0, error # if a1 < 1 then error
    add t0, x0, t0

loop_start:
    lw t1, 0(a0) # load a element of array 
    bge t1, x0, loop_continue # if t1 >= x0 then loop_continue
    sw x0, 0(a0)

loop_continue:
    addi a0, a0, 4 
    addi t0, t0, 1
    blt t0, a1, loop_start # if t0 < a1 then loop_start
    
loop_end:
    # Epilogue
	ret

error:
    li a1, 78 # a1 = 78
    j exit2  # jump to exit2
    
