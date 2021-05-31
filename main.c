#include <stdio.h>


extern int func(char *a);

int main(void)
{

    char text[20] = "abracadabra";

    printf("Input string      > %s\n", text);
    func(&text[0]); // &text[0] = &text
    printf("Conversion results> %s\n", text);

    return 0;
}
