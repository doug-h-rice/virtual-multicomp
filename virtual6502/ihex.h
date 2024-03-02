#ifndef IHEX_H
#define IHEX_H 1

void load_ihex(const char *file, unsigned char *memory );

int load_both_formats(char *file, unsigned char *memory );
static void save_nascom(int start, int end, const char *name, unsigned char *ram );

#endif
