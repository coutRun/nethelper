#!/bin/bash

# nethelper is a simple console application for pinging and querying a selected host in a text file



# Converts hosts from provided text file into an array
function read_hosts {

	# Gets hosts from file
	hosts=$(cat $1)

	# Appends each host into host_array
	count=1
	while read line; do
		hosts_array[$count]="$line"
		((count+=1))
	done < $1
}

# Prints the hosts and prompts the user to select a host
function pick_host {
	index=1

	# Prints each host from hosts_array and each corresponding index
	for host in ${hosts_array[@]}; do

		# Pretty prints the index and host
		echo "$index) ${hosts_array[$index]}"
		
		# Increments index
		((index+=1))
	done

	# Prompts the user to input the index number of the corresponding host
	read -p "Enter a number to select a host: " hostNumber
	
	# Input validation
	if [ $hostNumber -lt $index ]; then
		echo "${hosts_array[$hostNumber]}"
	else
		echo "Invalid number"
	fi
}

# Executes the read_hosts function with the program's parameters
read_hosts $@

# Redundant while loop to repeat until exit
while [[ choice != "Q" ]]; do
	
	# Prints the menu
	echo "(P) for ping"
	echo "(N) for nslookup"
	echo "(Q) for quit"

	# Gets the user's selected option
	read -p "Select one of the above:  " choice
	
	# Executes the corresponding option
	case $choice in
		p|P)
			# PING
			pick_host
			ping -c 1 "${hosts_array[$hostNumber]}"
			;;

		n|N)
			# NSLOOKUP
			pick_host
			nslookup "${hosts_array[$hostNumber]}"
			;;

		q|Q)
			# QUIT
			exit 1
			;;

		*)
			# ANY INVALID INPUT
			echo "Invalid choice"
			;;
	esac
done
