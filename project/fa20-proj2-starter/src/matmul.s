.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 72.
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 73.
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 74.
# =======================================================
matmul:

    # Error checks
    ble a1, x0, error72 # if a1 <= x0 then error72
    ble a2, x0, error72 # if a2 <= x0 then error72

    ble a4, x0, error73 # if a1 <= x0 then error72
    ble a5, x0, error73 # if a2 <= x0 then error72

    bne a2, a4, error74 # if a2 != a4 then error74
    # Prologue
    add t0, x0, x0 # t0 is itr of outer loop
    
    li t3, 4 # t3 for word size, and step for m1 and d
    mul t6, a2, t3 # t6 step for m0
    add t4, x0, a3 # save the start of m1

outer_loop_start:
    add a3, t4, x0
    add t1, x0, x0 # t1 is itr of inner loop

inner_loop_start:
    
    addi sp, sp, -56
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    sw a3, 12(sp)
    sw a4, 16(sp)
    sw a5, 20(sp)
    sw a6, 24(sp)
    sw ra, 28(sp)
    sw t0, 32(sp)
    sw t1, 36(sp)
    sw t2, 40(sp)
    sw t3, 44(sp)
    sw t4, 48(sp)
    sw t6, 52(sp)

    add a0, a0, x0
    add a1, a3, x0
    add a2, a2, x0
    li a3, 1
    add a4, a5, x0

    jal ra, dot

    add t5, a0, x0 # save the ret

    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    lw a3, 12(sp)
    lw a4, 16(sp)
    lw a5, 20(sp)
    lw a6, 24(sp)
    lw ra, 28(sp)
    lw t0, 32(sp)
    lw t1, 36(sp)
    lw t2, 40(sp)
    lw t3, 44(sp)
    lw t4, 48(sp)
    lw t6, 52(sp)
    addi sp, sp, 56

    sw t5, 0(a6)


inner_loop_end:
    addi t1, t1, 1
    add a3, a3, t3
    add a6, a6, t3
    blt t1, a5, inner_loop_start # if t1 < a5 then inner_loop_start

outer_loop_end: 
    addi t0, t0, 1
    add a0, a0, t6
    blt t0, a1, outer_loop_start # if t0 < a1 then outer_loop_start  
    # Epilogue
    ret


error72:
    li a1, 72 # a1 = 72
    j exit2  # jump to exit2

error73:
    li a1, 73 # a1 = 73
    j exit2  # jump to exit2

error74:
    li a1, 74 # a1 = 74
    j exit2  # jump to exit2


#调试代码
# addi sp, sp, -16
# sw ra, 0(sp)
# sw a1, 4(sp)
# sw a0, 8(sp)
# sw a3, 12(sp)

# add a1, a2, x0 
# jal ra, print_int
# add a1, x0, x0
# jal ra, print_int

# lw a3, 12(sp)
# lw a0, 8(sp)
# lw a1, 4(sp)
# lw ra, 0(sp)
# addi sp, sp, 16