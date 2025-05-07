#include "kernel/types.h"
#include "kernel/fcntl.h"
#include "user/user.h"

#define RD_END 0
#define WRT_END 1
#define MAX 280

void sieve(int* p);

int main() {
    int init_pipe[2];
    if (pipe(init_pipe) < 0) {
        fprintf(2, "[main] error: pipe failed\n");
        exit(1);
    }
    printf("init_pipe: %d, %d\n", init_pipe[0], init_pipe[1]);
    int pid = fork();
    if (pid < 0) {
        fprintf(2, "[main] error: fork failed\n");
        exit(1);
    } else if (pid) {
        // parent process only writes values
        close(init_pipe[RD_END]);
        for (int i = 2; i <= MAX; i++) {
            if (write(init_pipe[WRT_END], &i, sizeof(int)) < 0) {
                fprintf(2, "[main] error: write failed at %d\n", i);
                exit(1);
            }
        }
        close(init_pipe[WRT_END]);
        wait(0);
    } else {
        sieve(init_pipe);
    }
    return 0;
}

void sieve(int* prev_stage) {
    close(prev_stage[WRT_END]);
    int p, n;
    int ret = read(prev_stage[RD_END], &p, sizeof(int));
    if (ret < 0) {
        fprintf(2, "[sieve 42] error: read failed\n");
        exit(1);
    } else if (ret == 0) {
        // no more data to read, end of the pipeline
        close(prev_stage[RD_END]);
        exit(0);
    } else {
        printf("prime %d\n", p);
        int next_stage[2];
        int ret = pipe(next_stage);
        if (ret < 0) {
            fprintf(2, "[sieve 51] error: pipe failed\n");
            exit(1);
        }
        int pid = fork();
        if (pid < 0) {
            fprintf(2, "[sieve 56] error: fork failed\n");
            exit(1);
        } else if (pid) {
            close(prev_stage[RD_END]);
            sieve(next_stage);
        } else {
            close(next_stage[RD_END]);
            while (read(prev_stage[RD_END], &n, sizeof(int))) {
                if (n % p) {
                    write(next_stage[WRT_END], &n, sizeof(int));
                }
            }
            close(next_stage[WRT_END]);
            wait(0);
        }
    }
    
}
