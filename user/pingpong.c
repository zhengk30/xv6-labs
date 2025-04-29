#include "kernel/types.h"
#include "user/user.h"

int main() {
    int p[2];  // p[0] for read, p[1] for write
    if (pipe(p) < 0) {
        fprintf(2, "error: pipe failed\n");
        exit(1);
    }
    // No need to close ends of pipe because of the wait system call
    // made by parent process
    int pid = fork();
    if (pid == 0) {
        // in child
        printf("%d: received ping\n", getpid());
        write(p[1], "x", 1);
        exit(0);
    } else {
        wait(0);
        char buf;
        printf("%d: received pong\n", getpid());
        read(p[0], &buf, 1);
        exit(0);
    }
}
