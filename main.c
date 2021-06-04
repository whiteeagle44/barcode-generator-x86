#include <stdio.h>
#include <stdlib.h>

extern int put_pixel(char* pixels, int x, int y);
extern int put_thin_bar(char* pixels, int x, int width);
extern int put_thick_bar(char* pixels, int x, int width);
extern int put_char(char* pixels, int x, int width, char character);

char* read_from_file();
char* write_to_file(char* buff);

unsigned int len;

int main(int argc, char** argv)
{
    char* buff = read_from_file();
    char* pixels = buff + 10;
    pixels = buff + pixels[0];
    // pixels pointer now points to the pixels section of .bmp
    int ret = put_char(pixels, 10, 10, 'B');
    if(ret == -1) {
        printf("Error 1: Text contains characters which cannot be encoded");
        return 1;
    }


//    put_pixel(pixels, 20, 20);
//    int ret = put_thick_bar(pixels, 20, 2);
//    printf("%d", ret);
//    put_thin_bar(pixels, ret, 2);

    write_to_file(buff);


//    if(argc !=  2)
//    {
//        printf("Input argument was not specified correctly! \n ");
//        return -1;
//    }

//    if (result == 0) printf("No shape found.\n");
//    else printf("Shape %i found.\n\n\n", result);

    return 0;
}

char* read_from_file() {
    printf("Reading from file...");
    FILE *imgFile;
    imgFile = fopen("white.bmp", "rb");
    if (imgFile == NULL)
    {
        printf("Failed to open file\n");
        exit(-1);
    }
    else printf("File opened successfully\n");

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

//    int width =*(int * )( & buff[18] ); // width = 600
//    int width = 600;
//    int height =*(int * )( & buff[22] ); // height = 50
//    int height = 50;
    int size = ((600 * 3 + 3) & ~3) * 50 + 54;
    fwrite(buff, len, 1, imgFile);
    fclose(imgFile);

    return buff;
}