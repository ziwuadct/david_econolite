#include <stdio.h>
#include <string.h>

#ifndef GIT_VERSION
#define GIT_VERSION "unknown"
#endif

int main(int argc, char **argv)
{
    int i;
    printf("Git version: %s\n", GIT_VERSION);
#if defined(RELEASE)
    printf("Build type: RELEASE\n");
#else
    printf("Build type: Linux native\n");
#endif
    
    for(i = 1; i < argc; i ++)
    {
        printf("%d: %s\n", i, argv[i]);
    }
    return 0;
}