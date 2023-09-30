// #include <stdio.h>
// #include <stdint.h>
// #include <stdlib.h>
// #include <string.h>
// #include "lfsr.h"

// void lfsr_calculate(uint16_t *reg) {
//     /* YOUR CODE HERE */
//     uint16_t x = ((*reg >> 0) & 1) ^ ((*reg >> 2) & 1) ^ ((*reg >> 3) & 1) ^ ((*reg >> 5) & 1);
//     *reg = *reg >> 1;
//     *reg = *reg & ~(1 << 15);
//     *reg = *reg | (x << 15);
// }

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include "lfsr.h"
#include "bit_ops.c"

void lfsr_calculate(uint16_t *reg) {
    /* YOUR CODE HERE */
    uint16_t x = get_bit(*reg, 0) ^ get_bit(*reg, 2) ^ get_bit(*reg, 3) ^ get_bit(*reg, 5);
    *reg = *reg >> 1;
    set_bit((unsigned *)reg, 15, x);
}


