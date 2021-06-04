#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int put_pixel(char* pixels, int x, int y);
extern int put_thin_bar(char* pixels, int x, int width);
extern int put_thick_bar(char* pixels, int x, int width);
extern int put_char(char* pixels, int x, int width, char character);
extern int encode39(char* pixels, int width, char* text);


char* read_from_file();
char* write_to_file(char* buff);

unsigned int len;

int main(int argc, char** argv)
{
    if(argc !=  3)
    {
        printf("Error: Incorrect number of arguments.\n");
        printf("Correct syntax: ./program width_of_narrow_bar(1, 2 or 3) text_to_be_encoded(max 9 characters).\n ");
        return 2;
    }

    int width = atoi(argv[1]);
    if (width < 1 || width > 3) {
        printf("Error: Width must be 1, 2 or 3.\n");
        return 3;
    }

    char* text = argv[2];
    if (strlen(text) > 9) {
        printf("Error: Length of text to encode must be between 1 and 9 characters.\n");
        return 4;
    }

    printf("width: %d, text: %s\n", width, text);

    char* buff = read_from_file();
    char* pixels = buff + 10;
    pixels = buff + pixels[0];
    // pixels pointer now points to the pixels section of .bmp

    int ret = encode39(pixels, width, text);
    if(ret == -1) {
        printf("Error: Text contains characters which cannot be encoded");
        return 1;
    }

    write_to_file(buff);

    return 0;
}

char* read_from_file() {
    printf("Reading from file...");
    FILE *imgFile;
    imgFile = fopen("white.bmp", "rb");
    if (imgFile == NULL)
    {
        printf("Failed to open white.bmp\n");
        exit(-1);
    }
    else printf("white.bmp opened successfully\n");

    fseek(imgFile, 0, SEEK_END); /* move file pointer to end of file */
    len = ftell(imgFile); /* get offset from beginning of the file */
    fseek(imgFile, 0, SEEK_SET); /* move to the beginning of file */

    printf("Setting up buffer...");
    unsigned char* buff;
    buff = (unsigned char *)malloc(sizeof(unsigned char) * len);
    if (buff == NULL)
    {
        printf("Error, buffer is empty\n");
        fclose(imgFile);
        exit(-1);
    }
    else printf("Buffer set up successfully\n");

    fread(buff, len, 1, imgFile);
    fclose(imgFile);

    return buff;
}

char* write_to_file(char* buff) {
    printf("Opening file to write to...");
    FILE *imgFile;
    imgFile = fopen("output.bmp", "wb");
    if (imgFile == NULL)
    {
        printf("Failed to open file to write to\n");
        exit(-1);
    }
    else printf("File to write to opened successfully\n");

    fwrite(buff, len, 1, imgFile);
    fclose(imgFile);

    return buff;
}