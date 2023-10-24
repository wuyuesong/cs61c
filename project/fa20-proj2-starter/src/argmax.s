.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 77.
# =================================================================
argmax:

    # Prologue
    li t0 1
    blt a1, t0, error # if a1 < 1 then error
    add t0, x0, x0
    add t3, x0, x0

loop_start:
    lw t1, 0(a0) # load a element of array 
    ble t1, t3, loop_continue # if t1 <= t3 then loop_continue
    add t3, x0, t1

loop_continue:
    addi a0, a0, 4 
    addi t0, t0, 1
    blt t0, a1, loop_start # if t0 < a1 then loop_start

loop_end:
    # Epilogue
    add a0, x0, t3
    ret

error:
    li a1, 77 # a1 = 77
    j exit2  # jump to exit2