
#define _POSIX_C_SOURCE 200809L

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/wait.h>

#define MAX_ARGS 64



static int parse_line(char *line, char **argv) {
    int argc = 0;
    char *token = strtok(line, " \t\n");

    while (token != NULL && argc < MAX_ARGS - 1) {
        argv[argc] = token;
        argc++;
        token = strtok(NULL, " \t\n");
    }

    argv[argc] = NULL;
    return argc;
}


static void run_command(char **argv) {
    pid_t pid = fork();

    if (pid < 0) { 
        perror ("fork");
        return;

    }
    if (pid == 0) {
        execvp (argv[0], argv);
        perror(argv[0]); 
        _exit(127);

    }
    int status;
    waitpid(pid, &status,0);
}

static int run_builtin(char *argv){
    if (strcmp(argv[0], "exit") == 0) {
        exit(0);


    }
    
    if (strcmp(argv[0], "cd") == 0) { 
        const char *patch = argv[1];

        if (path == NULL) 
        path = getenv ("HOME");

        if (path == NULL || chdir (path) != 0)
        perror("cd");

        return 1;

    }

    return 0;
}

int main(void) {
    char *line = NULL;
    size_t cap = 0;
    char *argv[MAX_ARGS];

    while (1) {
        printf("mysh> ");
        fflush(stdout);

        if (getline(&line, &cap, stdin) == -1) {
            printf("\n");
            break;
        }

        int argc = parse_line(line, argv);

        if (argc == 0)
            continue;

        run_command(argv);
    }

    free(line);
    return 0;
}