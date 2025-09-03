#!/bin/bash

HOSTLIST="hostlist.txt"
SUDORULES="sudo-rules.txt"
TIMEOUT="timeout.txt"
SSH_CONNECT_TIMEOUT=5

# Empties the files if they already exist/are filled
> "$SUDORULES"
> "$TIMEOUT"

# Build SSH connection to host
for host in $(cat "$HOSTLIST"); do
  echo "Connecting to $host ..."
  echo -e "\n_________________________________________\n\nhost: $host \n_________________________________________" >> $SUDORULES
  ssh_connection="ssh -o StrictHostKeyChecking=accept-new -o ConnectTimeout=$SSH_CONNECT_TIMEOUT $host"
  
  # Collect users and their sudo rules in an SSH session—starting from the host currently being analyzed
  # Customize the ignore-list to your needs
  user_and_sudo=$($ssh_connection 'users=$(getent passwd | awk -F":" "{print \$1}" | grep -v -E "^(root|adm|bin|daemon|sync|lp|shutdown|halt|mail|operator|games|ftp|nobody|dbus|polkitd|unbound|sssd|sshd)$" );

    for user in $users; do
      sudo_rules=$(sudo -lU "$user" | grep -v "not allowed to run sudo");
      if [ -n "$sudo_rules" ]; then
        echo "$sudo_rules";
      fi;
    done;
  ')

  if [ $? -ne 0 ]; then
    echo -e "\n***ERROR*** Timeout while connecting to $host.\n\n" >> $TIMEOUT
  else
    echo "$user_and_sudo" >> "$SUDORULES"
  fi

  echo -e "\n\n***HOST $host FINISHED*** Sudo rules are listed in $SUDORULES.\n\n"

done

echo -e "\n***SCRIPT FINISHED*** All user sudo rules have been listed in $SUDORULES."
