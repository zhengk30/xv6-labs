#include "kernel/types.h"
#include "user/user.h"

int main(int argc, char** argv) {
    if (argc < 2) {
        fprintf(2, "error: missing nticks\n");
        exit(1);
    }
    int nticks = atoi(argv[1]);
    if (nticks < 0) {
        fprintf(2, "error: invalid nticks, should be nonnegative\n");
        exit(1);
    }
    if (sleep(nticks) < 0) {
        fprintf(2, "error: sleep failed\n");
        exit(1);
    }
    exit(0);
} 
