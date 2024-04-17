key="语法"

for file in *; do
    if [[ ${file} == *${key}* ]]; then
        filename=$(echo "${file}" | sed 's/语法/_syntax/')
        mv ${file} ${filename}
    fi
done
