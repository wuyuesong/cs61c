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
# - If you receive an fopen error or eof,
#   this function terminates the program with error code 93.
# - If you receive an fwrite error or eof,
#   this function terminates the program with error code 94.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 95.
# ==============================================================================
write_matrix:

    # Prologue
    addi sp, sp, -36
    sw, ra, 0(sp)
    sw, s0, 4(sp)
    sw, s1, 8(sp)
    sw, s2, 12(sp)
    sw, s3, 16(sp)
    sw, s4, 20(sp)
    sw, s5, 24(sp)
    sw, s6, 28(sp)
    sw, s7, 32(sp)

    mv s0, a0
    mv s1, a1
    mv s2, a2
    mv s3, a3

    # open file 
    mv a1, s0
    li a2, 1
    jal fopen  # jump to fopen and save position to ra
    mv s0, a0 # s0 for file descriptor
    blt s0, x0, error93 # if s3 < x0 then error93

    # malloc for rows and cols
    li a0, 8
    jal malloc  # jump to malloc and save position to ra
    mv s4, a0 # save address for row and col
    # beq s4, x0, error88 # if s4 == x0 then error88

    # write rows and cols
    sw s2, 0(s4)
    sw s3, 4(s4)
    mv a1, s0 # a1 = s0
    mv a2, s4
    li a3, 2
    li a4, 4
    jal fwrite
    li a3, 2
    blt a0, a3, error94 # if a0 < a3 then error94
    
    # write matrix
    mv a1, s0 # a1 = s0
    mv a2, s1
    mul a3, s2, s3
    li a4, 4
    jal fwrite
    mul a3, s2, s3
    blt a0, a3, error94 # if a0 < a3 then error94


    # close file 
    mv a1, s0
    jal fclose  # jump to fclose and save position to ra
    blt a0, x0, error95 # if a0 < x0 then error95

    # Epilogue
    lw, ra, 0(sp)
    lw, s0, 4(sp)
    lw, s1, 8(sp)
    lw, s2, 12(sp)
    lw, s3, 16(sp)
    lw, s4, 20(sp)
    lw, s5, 24(sp)
    lw, s6, 28(sp)
    lw, s7, 32(sp)
    addi sp, sp, 36

    ret

error93:
    li a1, 93 # a1 = 93
    j exit2  # jump to exit2

error94:
    li a1, 94 # a1 = 94
    j exit2  # jump to exit2

error95:
    mv a1, s0
    jal fclose  # jump to fclose and save position to ra
    li a1, 95 # a1 = 95
    j exit2  # jump to exit2