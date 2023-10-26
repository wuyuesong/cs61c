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
# - If malloc returns an error,
#   this function terminates the program with error code 88.
# - If you receive an fopen error or eof, 
#   this function terminates the program with error code 90.
# - If you receive an fread error or eof,
#   this function terminates the program with error code 91.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 92.
# ==============================================================================
read_matrix:

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

    mv s0, a0 # s0 for filename
    mv s1, a1 # s1 for address of rows
    mv s2, a2 # s2 for address of cols

    # open file 
    mv a1, s0
    li a2, 0
    jal fopen  # jump to fopen and save position to ra
    mv s3, a0 # s3 for file descriptor
    blt s3, x0, error90 # if s3 < x0 then error90

    # for debug
    # mv a1, s0
    # jal print_str
    # li a1, '\n'
    # jal print_char

    # read row
    mv a1, s3
    mv a2, s1
    li a3, 4
    jal fread
    blt a0, x0, error91 # if a0 < x0 then error91

    # for debug   
    # lw a1, 0(a2)
    # jal print_int
    # li a1, '\n'
    # jal print_char

    # read col
    mv a1, s3
    mv a2, s2
    li a3, 4
    jal fread
    blt a0, x0, error91 # if a0 < x0 then error91

    # for debug
    # lw a1, 0(a2)
    # jal print_int
    # li a1, '\n'
    # jal print_char
    
    # malloc
    lw s1, 0(s1)
    lw s2, 0(s2)
    mul s1, s1, s2 
    li s2, 4
    mul s1, s1, s2 # s1 for total bytes now
    mv a0, s1
    jal malloc  # jump to malloc and save position to ra
    mv s4, a0 # save address for s4
    beq s4, x0, error88 # if s4 == x0 then error88

    # read matrix
    li s6, 0
    li s7, 4
    mv a1, s3
    mv a2, s4
    li a3, 4
loop_read:
    add a2, s6, s4
    jal fread
    blt a0, s7, error91 # if a0 < x0 then error91
    addi s6, s6, 4
    blt s6, s1, loop_read 

    

    # close file 
    mv a1, s3
    jal fclose  # jump to fclose and save position to ra
    blt a0, x0, error92 # if a0 < x0 then error92

    # mv array address to a0
    mv a0, s4

    # lw a1, 0(a0)
    # jal print_int


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

error88:
    li a1, 88 # a1 = 88
    j exit2  # jump to exit2

error90:
    li a1, 90 # a1 = 90
    j exit2  # jump to exit2

error91:
    li a1, 91 # a1 = 91
    j exit2  # jump to exit2

error92:
    li a1, 92 # a1 = 92
    j exit2  # jump to exit2
