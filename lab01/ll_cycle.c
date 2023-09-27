#include <stddef.h>
#include <stdio.h>
#include "ll_cycle.h"

int ll_has_cycle(node *head) {
    /* your code here */
    node *tortoise = head, *hare = head;
    if (head == NULL) return 0;
    while (1) {
        if (hare -> next == NULL || hare -> next -> next == NULL) return 0;
        hare = hare -> next -> next;
        if (tortoise -> next == NULL) return 0;
        tortoise = tortoise -> next;
        if (tortoise == hare) return 1;
    }
    return 0;
}