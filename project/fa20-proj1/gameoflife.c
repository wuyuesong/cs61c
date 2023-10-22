/************************************************************************
**
** NAME:        gameoflife.c
**
** DESCRIPTION: CS61C Fall 2020 Project 1
**
** AUTHOR:      Justin Yokota - Starter Code
**				YOUR NAME HERE
**
**
** DATE:        2020-08-23
**
**************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include "imageloader.h"

//Determines what color the cell at the given row/col should be. This function allocates space for a new Color.
//Note that you will need to read the eight neighbors of the cell in question. The grid "wraps", so we treat the top row as adjacent to the bottom row
//and the left column as adjacent to the right column.
Color *evaluateOneCell(Image *image, int row, int col, uint32_t rule)
{
	//YOUR CODE HERE
    // printf("%u\n", rule);
    Color *color = (Color *)malloc(sizeof(Color));
    char count[24];
    memset(count, 0, sizeof(count));
    memset(color, 0, sizeof(color));
    int act_x[8] = {1, 1, 1, 0, 0, -1, -1, -1};
    int act_y[8] = {-1, 0, 1, -1, 1, -1, 0, 1};
    for (int i = 0; i < 8; i ++) {
        int x = row + act_x[i];
        int y = col + act_y[i];
        x = (x + image->rows) % image->rows;
        y = (y + image->cols) % image->cols;
        for (int j = 0; j < 24; j ++) {
            if (j < 8) {
                if (((image->image[x][y].R) & (1 << j)) != 0) {
                    count[j] ++;
                }
            } else if (j < 16) {
                if (((image->image[x][y].G) & (1 << (j-8))) != 0) {
                    count[j] ++;
                }
            } else {
                if (((image->image[x][y].B) & (1 << (j-16))) != 0) {
                    count[j] ++;
                }
            }
        }
    }
    for (int j = 0; j < 24; j ++) {
        int bais = 0;
        if (j < 8) {
            if ( image->image[row][col].R & (1 << j) != 0) bais = 9;
            if (((1 << (count[j] + bais)) & rule) != 0)
                color->R += (1 << j);
        } else if (j < 16) {
            if ( image->image[row][col].G & (1 << (j - 8)) != 0) bais = 9;
            if (((1 << (count[j] + bais)) & rule) != 0)
                color->G += (1 << (j-8));
        } else {
            if ( image->image[row][col].B & (1 << (j - 16)) != 0) bais = 9;
            if (((1 << (count[j] + bais)) & rule) != 0)
                color->B += (1 << (j-16));
        }
        
    }
    return color;
}

//The main body of Life; given an image and a rule, computes one iteration of the Game of Life.
//You should be able to copy most of this from steganography.c
Image *life(Image *image, uint32_t rule)
{
	//YOUR CODE HERE
    Image *ret = (Image *)malloc(sizeof(Image)); 
    ret->rows = image->rows;
    ret->cols = image->cols;
    ret->image = (Color **)malloc((image->rows) * sizeof(Color *));
    for (int i = 0; i < image->rows; i ++) {
        ret->image[i] = (Color *)malloc((image->cols) * sizeof(Color));
    }
    for (int i = 0; i < image->rows; i ++) {
        for (int j = 0; j < image->cols; j ++) {
            Color *new_color = evaluateOneCell(image, i, j, rule);
            ret->image[i][j] = *new_color;
            free(new_color);
        }
    }
    return ret;
}

/*
Loads a .ppm from a file, computes the next iteration of the game of life, then prints to stdout the new image.

argc stores the number of arguments.
argv stores a list of arguments. Here is the expected input:
argv[0] will store the name of the program (this happens automatically).
argv[1] should contain a filename, containing a .ppm.
argv[2] should contain a hexadecimal number (such as 0x1808). Note that this will be a string.
You may find the function strtol useful for this conversion.
If the input is not correct, a malloc fails, or any other error occurs, you should exit with code -1.
Otherwise, you should return from main with code 0.
Make sure to free all memory before returning!

You may find it useful to copy the code from steganography.c, to start.
*/
int main(int argc, char **argv)
{
	//YOUR CODE HERE
    char *filename;
    uint32_t rule;
    if (argc != 3) {
        exit(-1);
    }
    filename = argv[1];
    Image *image;
    Image *next_image;
    image = readData(filename);
    if (image == NULL) {
        exit(-1); 
    }
    rule = strtoul(argv[2], NULL, 16);
    next_image = life(image, rule);
    writeData(next_image);

    freeImage(image);
    freeImage(next_image);
    return 0;
}
