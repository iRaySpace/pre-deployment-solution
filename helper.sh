#!/bin/bash


extract_service_name() {
    local directory_path=$1
    echo "$directory_path" | awk -F/ '{print $NF}'
}


extract_version_from_path() {
    local service=$1
    if [ -f "$service/version.txt" ]; then
        local version=$(cat "$service/version.txt")
        echo "$version"
    elif [ -f "$service/package.json" ]; then
        local version=$(jq -r ".version" "$service/package.json" 2>/dev/null)
        echo "$version"
    else
        echo "unknown"
    fi
}

read_manifest() {
    local manifest_path=$1

    if [ ! -f "$manifest_path" ]; then
        echo "File not found: $manifest_path" >&2
        return 1
    fi

    # Read each line in the manifest
    while IFS= read -r line || [ -n "$line" ]; do
        echo "$line"
    done < "$manifest_path"
}
