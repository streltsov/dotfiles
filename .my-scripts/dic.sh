#! /bin/bash

async_command="sgpt --model=gpt-4 --role dic"

if [ $# -ne 1 ]; then
  echo "Usage: async_program_function <argument>"
  return 1  # Return an error code
fi

argument="$1"

output=$($async_command "$argument" &)

echo "$output"

read -p "Save the output? (Y/n): " -r log_choice
log_choice=${log_choice:-Y}  # Default to "Y" (log)
log_choice=${log_choice^}    # Convert to uppercase

case "$log_choice" in
  [Y]*)  # If the user entered "Y" or just pressed Enter
    echo "$output" >> anki-words.txt
    ;;
  *)  # For any other response from the user
    echo "Output not logged."
    ;;
esac
