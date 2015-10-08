#!/bin/bash

groupstotest=$# # this passes the number of arguments passed **after** the command name, which is always the first argument

if [[ $# -eq 1 ]];
	then 
	echo "no groups passed."
else
	echo "There were $groupstotest groups passed.";
fi

declare -a missing
count=0

for ((i=1; i<$(($linkstotest + 1)); i++))
	do 
# debugging
		lastlinecount=${#thisstring}
		thisstring="${!i}"
		echo "working on: $thisstring"
		echo "length of this string is ${#thisstring}"

# stash any 404 results in the missing array
		printf "\r%d of %d... ($count bad links so far)" "$i" $groupstotest
#		result=$(curl -sL -w "%{http_code} %{url_effective}\\n" "${!i}" -o /dev/null | grep ^404)
			if [[ "$result" ]]; then
#				printf " =====  %s\n" "$result"
				missing[$count]="$result"
				((count++))
			fi
done
printf "\n"
for ((i=0; i<$count; i++))
	do
		echo "${missing[$i]}"
done



