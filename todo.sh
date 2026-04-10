#!/bin/bash

Task_file="task.txt"
touch "$Task_file"

Green='\033[0;32m'
Red='\033[0;31m'
NC='\033[0m' # No Color thus resets output

if [ $# -eq 0 ]; then
  echo "Usage:"
  echo " $0 add \"Task description\""  # Add a new task"
  echo " $0 list"                      # List all tasks"
  echo " $0 del <number>"              # This deletes a task by its number"
  echo " $0 clear"
  exit 1
fi

  COMMAND=$1

case "$COMMAND" in
    add)
        if [ -z "$2" ]; then
            echo -e "${Red}Error: Task description cannot be empty"
            exit 1
        fi

        # Prevent duplicated tasks (case-insensitive check)
        if grep -iq "\] $2$" "$Task_file"; then
            echo -e "${Red}Error: Task '$2' already exists in your list${NC}"
            exit 1
        fi

        Timestamp=$(date "+%Y-%m-%d %H:%M")
        #This saves the task with a timestamp
        echo "[$Timestamp] $2" >> "$Task_file"
        echo -e "${Green}Task added: $2${NC}"
        ;;

    list)
        if [ ! -s "$Task_file" ]; then
            echo "Your to-do list is currently empty"
        else
            echo -e "${Green}====Your to-do list===${NC}"
            #to color the actual file
            echo -ne "${Green}"
            # Using 'nl' to display tasks with line numbers
            nl -w1 -s'. ' "$Task_file"
            echo -ne "${NC}"
        fi
        ;;       

    del)
        # Check if task number is provided
        if [ -z "$2" ]; then
            echo -e "${Red}Error: Enter task number to delete"${NC}
            exit 1
        fi

        # Check if file is empty
        if [ ! -s "$Task_file" ]; then
            echo -e "${Red}Error: No tasks to delete"${NC}
            exit 1
        fi

         # Validate that input is a number
        if ! [[ "$2" =~ ^[0-9]+$ ]]; then
            echo -e "${Red}Error: Not a valid number surely an interger"${NC}
            exit 1
        fi
        # Using awk to obtain total number of lines.
        Total_Tasks=$(awk 'END {print NR}' "$Task_file")

        if [ "$2" -gt "$Total_Tasks" ] || [ "$2" -le 0 ]; then
            echo -e "${Red}Error: Task number $2 does not exist${NC}"
            exit 1
        fi
        
        sed -i "${2}d" "$Task_file"
        echo -e "${Green}Task $2 deleted ${NC}"
        ;;
    clear)
        > "$Task_file"
        echo -e "${Green}All task cleared!${NC}"
        ;;

    *)

        echo -e "${Red}Invalid command: $1${NC}"
        exit 1
        ;;
esac