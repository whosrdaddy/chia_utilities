#!/bin/bash

# Specify the file to monitor
file_to_monitor="/home/diablo/.chia/mainnet/log/debug.log"

# Specify the word combination to search for
word_combination="ERROR    Exception fetching full"

# Specify the command to execute when the combination is found three times
command_to_execute="chia start farmer -r"
# Function to count the occurrences of the word combination in the file
count_occurrences() {
    tail -n 200 "$file_to_monitor" | grep -o "$word_combination" | wc -l
}

# Monitor the file for changes
while true; do
    # Count the occurrences of the word combination
    occurrences=$(count_occurrences)

    # Check if the combination occurs three times or more
    if [ $occurrences -ge 2 ]; then
        # Execute the command
        date
        echo "seeing to many errors, restarting chia"
        eval "$command_to_execute"

        # Exit the script after executing the command
        sleep 30
    fi

    # Sleep for some time before checking again
    sleep 30
done
