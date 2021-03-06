fswatch -0 -r --event Created /home/alfred/webapps/odyssey-tours/content/english/states \
| while read -d '' file; do \

  if [[ -d ${file} ]] ; then
	
	char="/"
    cnt=$(awk -F"${char}" '{print NF-1}' <<< "${file}")

    if [ $cnt == 10 ]; then

        result="${file%"${file##*[!/]}"}" # extglob-free multi-trailing-/ trim
        result="${result##*/}"            # remove everything before the last /
        
    	echo "bingo! Created ${result}"
        echo "Now adding to ${file}"

        path="$(echo ${file} | awk '{print tolower(substr($1,1))}' )"
        mv "${file}" "${path}" 

    	cp "/home/alfred/webapps/odyssey-tours/content/template/_index.md" "${path}/_index.md"
        mkdir "${path}/excursions"
        cp "/home/alfred/webapps/odyssey-tours/content/template/excursions/_index.md" "${path}/excursions/_index_md"
        mkdir "${path}/hotels"
        cp "/home/alfred/webapps/odyssey-tours/content/template/hotels/_index.md" "${path}/hotels/_index.md"

        city="$(echo ${result} | awk '{print tolower(substr($1,1))}' )"
        sed -i -e "s/-CITY-/${city}/g" "${path}/_index.md"
        sed -i -e "s/city/${city}/g"   "${path}/excursions/_index_md"

        city="$(echo ${result} | awk '{print toupper(substr($1,1,1)) tolower(substr($1,2))}' )"
        sed -i -e "s/CITY/${city}/g" "${path}/_index.md"
        sed -i -e "s/CITY/${city}/g" "${path}/hotels/_index.md"
        sed -i -e "s/CITY/${city}/g" "${path}/excursions/_index_md"
	fi
  fi
done