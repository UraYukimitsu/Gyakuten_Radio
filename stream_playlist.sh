#!/bin/bash

# Stream the shuffled playlist forever
while true; do
    c=$(wc -l playlist.txt)
    i=1
    while IFS= read -r SOURCE; do

	# Can override the current playlist to force playing a certain song
	if [[ -f overrideList.txt ]]; then
            j=1
		oc=$(wc -l overrideList.txt)
		while IFS= read -r OVERRIDE; do
			echo "$j/$oc"
            ./stream.sh "$OVERRIDE" < /dev/null
			j=$((j+1))
		done < <(cat "overrideList.txt")
		rm -f overrideList.txt
	fi

	echo "$i/$c"
        ./stream.sh "$SOURCE" < /dev/null
	i=$((i+1))
    done < <(shuf "playlist.txt")
done
