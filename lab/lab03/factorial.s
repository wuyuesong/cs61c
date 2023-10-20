.globl factorial

.data
n: .word 8

.text
main:
    la t0, n
    lw a0, 0(t0)
    jal ra, factorial

    addi a1, a0, 0
    addi a0, x0, 1
    ecall # Print Result

    addi a1, x0, '\n'
    addi a0, x0, 11
    ecall # Print newline

    addi a0, x0, 10
    ecall # Exit

factorial:
    # YOUR CODE HERE
    # VERSION 1
#     add t1, a0, x0
#     addi t1, t1, -1
# Loop:
#     beq t1, x0, Exit_factorial
#     mul a0, a0, t1
#     addi t1, t1, -1
#     jal x0, Loop

# Exit_factorial:
#     jr ra

    # VERSION 2
    addi t1, x0, 1
    beq t1, a0, Exit_factorial
    addi sp, sp, -8
    sw ra 4(sp)
    sw a0 0(sp)
    addi a0, a0, -1
    jal ra factorial
    lw t0 0(sp)
    lw ra 4(sp)
    mul a0, t0, a0
    addi sp, sp, 8
Exit_factorial:
    jr ra