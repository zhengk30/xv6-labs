#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"
#include "kernel/fcntl.h"

void _extract_filename(char* dest, char* path) {
    int i = strlen(path)-1;
    while (i >= 0 && path[i] != '/') {
        i--;
    }
    i++;
    int len = strlen(path) - i;
    memcpy(dest, path+i, len);
}

void find(const char* path, const char* target) {
    int fd;
    struct dirent de;
    struct stat st;
    
    if ((fd = open(path, O_RDONLY)) < 0) {
        fprintf(2, "find: cannot open %s\n", path);
        return;
    }
    if (fstat(fd, &st) < 0) {
        fprintf(2, "find: cannot stat %s\n", path);
        close(fd);
        return;
    }

    if (st.type == T_FILE) {
        if (!strcmp(path, target)) {
            printf("%s\n", path);
        }
        close(fd);
    } else if (st.type == T_DIR) {
        char buf[512] = {0};
        if (strlen(path) + 1 + DIRSIZ + 1 > sizeof buf) {
            fprintf(2, "find: path too long\n");
            close(fd);
            return;
        }
        strcpy(buf, path);
        char* p = buf + strlen(buf);
        *(p++) = '/';
        while (read(fd, &de, sizeof(de)) == sizeof(de)) {
            if (de.inum == 0) continue;
            if (!strcmp(de.name, ".") || !strcmp(de.name, "..")) continue;
            memmove(p, de.name, DIRSIZ);
            p[DIRSIZ] = 0;
            if (stat(buf, &st) < 0) {
                fprintf(2, "find: cannot stat %s\n", buf);
                close(fd);
                return;
            }
            if (st.type == T_FILE) {
                char filename[512] = {0};
                _extract_filename(filename, buf);
//                printf("filename=%s\n", filename);
                if (!strcmp(filename, target)) {
                    printf("%s\n", buf);
                }
            } else {
                find(buf, target);
            }
        }
    } else {
        close(fd);
    }
}

int main(int argc, char** argv) {
    if (argc != 3) {
        fprintf(2, "usage: ./find <path> <target>\n");
        exit(1);
    }
    char* path = argv[1];
    char* target = argv[2];
    find(path, target);
    exit(0);
}
