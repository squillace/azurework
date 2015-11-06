#!/bin/bash

groupstotest=$# # this passes the number of arguments passed **after** the command name, which is always the first argument

if [[ $# -eq 1 ]];
	then 
	echo "one group passed."
else
	echo "There were $groupstotest groups passed.";
fi

declare -a missing
count=0

for ((i=1; i<$(($groupstotest + 1)); i++))
	do 
# debugging
		lastlinecount=${#thisstring}
		thisstring="${!i}"
#		echo "Examining the \"$thisstring\" resource group."
#		echo "length of this string is ${#thisstring}"

# stash any 404 results in the missing array
#		printf "\r%d of %d... ($count bad links so far)" "$i" 
# 		echo $groupstotest
#		result=$(curl -sL -w "%{http_code} %{url_effective}\\n" "${!i}" -o /dev/null | grep ^404)
			if [[ true ]]; then
#				printf " =====  %s\n" "$result"
				missing[$count]="${!i}"
				((count++))
			fi
done
# printf "\n"
for ((i=0; i<$count; i++))
	do
		printf " ===== Resource group: %s\n" "${missing[$i]}"
		currentgroup=$(azure vm list "${missing[$i]}" --json | jq -r '.[].storageProfile.oSDisk.virtualHardDisk.uri')
		printf " =====  VHD file: %s\n" "$currentgroup"
		classix=$(azure group show "${missing[$i]}"  --json | jq -r '.resources[] | select(.id | contains("Classic")) | .id')
		
#		if [[ "$classix" -ne "" ]]; then
			printf " ===== Classic Resources: %s\n" "$classix"
#		echo "$classix"
#		fi
done



