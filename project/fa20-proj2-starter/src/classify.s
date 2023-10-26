.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero, 
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # Exceptions:
    # - If there are an incorrect number of command line args,
    #   this function terminates the program with exit code 89.
    # - If malloc fails, this function terminats the program with exit code 88.
    #
    # Usage:
    #   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>

    addi sp, sp, -48
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)
    sw s7, 32(sp)
    sw s8, 36(sp)
    sw s9, 40(sp)
    sw s10, 44(sp)

    li s0, 5
    bne a0, s0, error89 # if a0 != s0 then error89


    # s0 for arg
    # s1 for print or not
    # s2 for m0 row and col
    # s3 for m0
    # s4 for m1 row and col
    # s5 for m1
    # s6 for input row and col
    # s7 for input

    mv s0, a1 # s0 for arg
    mv s1, a2 # s1 for print or not
	# =====================================
    # LOAD MATRICES
    # =====================================
    # Load pretrained m0
    li a0, 8
    jal malloc
    beq a0, x0, error88 # if a0 == x0 then error88
    mv s2, a0 # s2 for m0 row and col

    lw a0, 4(s0)
    addi a1, s2, 0
    addi a2, s2, 4
    jal read_matrix  # jump to read_matrix and save position to ra
    mv s3, a0 # s3 for m0 

    # addi sp, sp, -12
    # sw ra, 0(sp)
    # sw a1, 4(sp)
    # sw a0, 8(sp)
    # addi s3, s3, 0
    # lw a1, 4000(s3)
    # jal print_int
    # li a1, '\n'
    # jal print_char
    # lw ra, 0(sp)
    # lw a1, 4(sp)
    # lw a0, 8(sp)
    # addi sp, sp, 12

    # Load pretrained m1
    li a0, 8
    jal malloc
    beq a0, x0, error88 # if a0 == x0 then error88
    mv s4, a0 # s4 for m1 row and col



    lw a0, 8(s0)
    addi a1, s4, 0
    addi a2, s4, 4
    jal read_matrix  # jump to read_matrix and save position to ra
    mv s5, a0 # s5 for m1 

    # Load input matrix
    li a0, 8
    jal malloc
    beq a0, x0, error88 # if a0 == x0 then error88
    mv s6, a0 # s6 for input row and col

    lw a0, 12(s0)
    addi a1, s6, 0
    addi a2, s6, 4
    jal read_matrix  # jump to read_matrix and save position to ra
    mv s7, a0 # s7 for input 

    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)

    # s0 for arg
    # s1 for print or not
    # s2 for m0 row and col
    # s3 for m0
    # s4 for m1 row and col
    # s5 for m1
    # s6 for input row and col
    # s7 for input

    # first step
    lw a1, 0(s2)
    lw a2, 4(s6)
    addi a3, x0, 4
    mul a0, a1, a2
    mul a0, a3, a0
    jal malloc
    beq a0, x0, error88
    mv a6, a0 
    mv s10, a0

    mv a0, s3
    lw a1, 0(s2)
    lw a2, 4(s2)
    mv a3, s7
    lw a4, 0(s6)
    lw a5, 4(s6)
    jal matmul
    mv s3, s10 # s3 for step1_m
    sw a1, 0(s2)
    sw a5, 4(s2)

    # second step
    # s0 for arg
    # s1 for print or not
    # s2 for step1_m row and col
    # s3 for step1_m
    # s4 for m1 row and col
    # s5 for m1
    # s6 for input row and col
    # s7 for input
    mv a0, s3
    lw a1, 0(s2)
    jal relu

    

    # third step
#   a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
    # malloc for answear
    lw a1, 0(s4)
    lw a2, 4(s2)
    addi a3, x0, 4
    mul a0, a1, a2
    mul a0, a3, a0
    jal malloc
    beq a0, x0, error88
    mv a6, a0 
    mv s10, a6

    mv a0, s5
    lw a1, 0(s4)
    lw a2, 4(s4)
    mv a3, s3
    lw a4, 0(s2)
    lw a5, 4(s2)
    jal matmul
    mv s5, s10 # s5 for step1_m
    sw a1, 0(s4)
    sw a5, 4(s4)

    # for debug
    # li a1, 'a'
    # jal print_char

    # mv a1, a2
    # jal print_int

    # mv a1, a4
    # jal print_int

    # s0 for arg
    # s1 for print or not
    # s2 for step1_m row and col
    # s3 for step1_m
    # s4 for final_m row and col
    # s5 for final_m
    # s6 for input row and col
    # s7 for input
    
    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
    lw a0, 16(s0)
    mv a1, s5
    lw a2, 0(s4)
    lw a3, 4(s4)
    jal write_matrix

    
    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
    mv a0, s5
    lw a1, 0(s4)

    # jal print_int
    # li a1, '\n'
    # jal print_char

    jal argmax


    # lw a1, 0(s4)
    # jal print_int
    # li a1, '\n'
    # jal print_char

    # Print classification
    # beq s1, x0, end # if s1 == x0 then end 
    # li a1, 4
    # mul a0, a0, a1
    # add a0, a0, s5
    # lw a0, 0(a0)   
    mv a1, a0
    jal print_int

    

    # Print newline afterwards for clarity
    li a1, '\n'
    jal print_char  # jump to print_char and save position to ra
    
    
end:

    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    lw s7, 32(sp)
    lw s8, 36(sp)
    lw s9, 40(sp)
    lw s10, 44(sp)
    addi sp, sp, 48
    ret

error88:
    li a1, 88 # a1 = 88
    j exit2  # jump to exit2

error89:
    li a1, 89 # a1 = 89
    j exit2  # jump to exit2