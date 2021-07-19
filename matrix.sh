#!/bin/bash
declare -a first=("A" "B" "C")
declare -a second=("1" "2")
if [[ $* == *--help* ]]; then
    echo "---------------";
    echo "---------------";
    echo "| Tmux Matrix |"; 
    echo "---------------";
    echo "---------------";
    printf "This program opens up a bunch of tmux windows and passes different arguments to a program of your choice.\n\n"
    
    echo "Usage: ./matrix.sh DIR PROG HOST"
    echo "Where:"
    printf "\tDIR is the directory to traverse to\n"
    printf "\tPROG is the program to execute (without arguments)\n"
    printf "\tHOST is the host to ssh to if necessary. If left out or equal to 'localhost', this does not ssh at all\n"
    echo "Example";
    echo "./matrix.sh \`pwd\` 'python example.py'"
    echo "-----------";
    exit;
fi

if ! { [ "$TERM" = "screen" ] && [ -n "$TMUX" ]; } then
    echo "You are not in a tmux window! Please start one using the 'tmux' command"; exit
fi
# The directory to traverse to
dir=$1
# The program to execute
prog=$2
# The host to ssh to. If it is localhost or left out, then we don't ssh.
host=${3:-localhost}
# Counter
i=0
cmd_for_first=""

# For each pair F, S from the arrays
for F in "${first[@]}"; do
    for S in "${second[@]}"; do
        i=$((i+1))

        # If the host is localhost, then don't ssh.
        if [[ "$host" == "localhost" ]]; then
            cmd="cd $dir &&  $prog $F $S"
        else
            # else do.
            cmd="ssh $host 'cd $dir &&  $prog $F $S'"
        fi

        # Save the first command to be executed and continue.
        # This is because this command must execute in the first, main pane, 
        # but it must first make all the other panes before it can do so
        if [[ "$i" == "1" ]]; then
            cmd_for_first="$cmd"
            continue;
        fi

        # Then split and send the command as keys to the window
        tmux split -v \; send-keys "$cmd" C-m \;
        # and select a tiled layout, to ensure we have enough space.
        tmux select-layout tiled

    done
done
# Execute the first one.
if [[ $cmd_for_first != "" ]]; then
    eval $cmd_for_first
fi
