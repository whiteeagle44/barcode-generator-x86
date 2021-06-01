#include <stdio.h>
#include <stdlib.h>

//extern int func(char *a);

char* readFromFile();
char* writeToFile(char* buff);

int main(int argc, char** argv)
{
    char* buff = readFromFile();
    writeToFile(buff);


//    if(argc !=  2)
//    {
//        printf("Input argument was not specified correctly! \n ");
//        return -1;
//    }

//    if (result == 0) printf("No shape found.\n");
//    else printf("Shape %i found.\n\n\n", result);

    return 0;
}

char* readFromFile() {
    printf("Reading from file...");
    FILE *imgFile;
    imgFile = fopen("white.bmp", "rb");
    if (imgFile == NULL)
    {
        printf("Failed to open file\n");
        exit(-1);
    }
    else printf("File opened successfully\n");

    unsigned int len;
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

char* writeToFile(char* buff) {
    printf("Opening file to write to...");
    FILE *imgFile;
    imgFile = fopen("output.bmp", "wb");
    if (imgFile == NULL)
    {
        printf("Failed to open file to write to\n");
        exit(-1);
    }
    else printf("File to write to opened successfully\n");

    int width =*(int * )( & buff[18] ); // width = 600
    int height =*(int * )( & buff[22] ); // height = 50
    int size = ((width * 3 + 3) & ~3) * height + 54;
    fwrite(buff, size, 1, imgFile);
    fclose(imgFile);

    return buff;
}