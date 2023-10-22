/************************************************************************
**
** NAME:        imageloader.c
**
** DESCRIPTION: CS61C Fall 2020 Project 1
**
** AUTHOR:      Dan Garcia  -  University of California at Berkeley
**              Copyright (C) Dan Garcia, 2020. All rights reserved.
**              Justin Yokota - Starter Code
**				YOUR NAME HERE
**
**
** DATE:        2020-08-15
**
**************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include <string.h>
#include "imageloader.h"

//Opens a .ppm P3 image file, and constructs an Image object. 
//You may find the function fscanf useful.
//Make sure that you close the file with fclose before returning.
Image *readData(char *filename) 
{
	//YOUR CODE HERE
    char P3[3];
    uint32_t  t;
    FILE * fp;
    FILE *outputFile;
    Image *img = (Image *)malloc(sizeof(Image));
    fp = fopen(filename, "r");
    if (fp == NULL) {
        outputFile = freopen("/dev/tty", "w", stdout);
        perror("file not exists");
        fclose(outputFile);
        fclose(fp);
        return NULL;
    }
    fscanf(fp, "%s", P3);
    if (strcmp(P3, "P3") != 0) {
        outputFile = freopen("/dev/tty", "w", stdout);
        perror("file format is not P3");
        fclose(outputFile);
        fclose(fp);
        return NULL;
    }
    img->cols = -1; img->rows = -1;
    fscanf(fp, "%u %u", &img->cols, &img->rows);
    fscanf(fp, "%u", &t);
    if (img->cols == -1 || img->rows == -1 || t != 255) {
        outputFile = freopen("/dev/tty", "w", stdout);
        perror("file format is not P3");
        fclose(outputFile);
        fclose(fp);
        return NULL;
    }
    img->image = (Color **)malloc((img->rows) * sizeof(Color *));
    for (int i = 0; i < img->rows; i ++) {
        img->image[i] = (Color *)malloc((img->cols) * sizeof(Color));
    }
    for (int i = 0; i < img->rows; i ++) {
        for (int j = 0; j < img->cols; j ++) {
            if (fscanf(fp, "%hhu%hhu%hhu", &img->image[i][j].R, &img->image[i][j].G,&img->image[i][j].B) != 3) {
                outputFile = freopen("/dev/tty", "w", stdout);
                perror("file colur format error");
                fclose(outputFile);
                fclose(fp);
                return NULL;
            }
        }
    }
    fclose(fp);
    return img;
}

//Given an image, prints to stdout (e.g. with printf) a .ppm P3 file with the image's data.
void writeData(Image *image)
{
	//YOUR CODE HERE
    printf("P3\n");
    printf("%u %u\n", image->cols, image->rows);
    printf("255\n");
    for (int i = 0; i < image->rows; i ++) {
        for (int j = 0; j < image->cols; j ++) {
            if (j != 0) printf("   ");
            printf("%3hhu %3hhu %3hhu", image->image[i][j].R, image->image[i][j].G, image->image[i][j].B);
        }
        printf("\n");
    }
}

//Frees an image
void freeImage(Image *image)
{
	//YOUR CODE HERE
    for (int i = 0; i < image->rows; i ++) {
        free(image->image[i]);
    }
    free(image->image);
    free(image);
}