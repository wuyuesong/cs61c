.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 75.
# - If the stride of either vector is less than 1,
#   this function terminates the program with error code 76.
# =======================================================
dot:
    # Prologue
    ble a2, x0, error1 # if a2 <= x0 then error1
    ble a3, x0, error2 # if a3 <= x0 then error2
    ble a4, x0, error2 # if a4 <= x0 then error2

    li t0, 4
    mul a3, a3, t0 # mul byte size for stride
    mul a4, a4, t0

    add t0, x0, x0 # t0 for answears
    add t1, x0, x0 # t1 for itr

loop_start:
    lw t2, 0(a0)
    lw t3, 0(a1)
    mul t2, t2, t3
    add t0, t2, t0

    add a0, a0, a3
    add a1, a1, a4
    addi t1, t1, 1
    blt t1, a2, loop_start # if t1 < a2 then loop_start   

loop_end:
    # Epilogue
    add a0, t0, x0
    ret

error1:
    li a1, 75 # a1 = 75
    j exit2  # jump to exit2

error2:
    li a1, 76 # a1 = 76
    j exit2  # jump to exit2