# Tmux Matrix
This program opens up a bunch of tmux windows and passes different arguments to a program of your choice.


It basically does the following:
For each pair of parameter configurations, it first makes a new pane for them, cd's into a specified directory and runs a program, giving it the current pair of parameters as arguments.

It also has the support of doing this on a remote machine using ssh.
## Usages
First, start a tmux session (by typing `tmux`) and then you can run

`./matrix.sh DIR PROG HOST`

Where,
- DIR is the directory to traverse to.
- PROG is the program to execute (without arguments).
- HOST is the host to ssh to if necessary. If left out or equal to 'localhost', this does not ssh at all.
## Example
Will add soon.
## Use cases
There are a couple of use cases, among others:

1. Optimising combinations of compilers and MPI implementations for a specific project to optimise speed (the matrix is only for building in parallel)
2. If you have to run the same program multiple times (with or without multiple arguments), and would like to see the output on one screen without tediously making the panes yourself.