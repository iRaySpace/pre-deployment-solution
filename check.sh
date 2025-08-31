#!/bin/bash

# Load helper and service scripts
source helper.sh
source service.sh

# Validation: If no input is given
if [ $# -lt 1 ]; then
    echo "Usage: $0 <manifest-file>" >&2
    exit 1
fi

# Validation: If manifest file is not found
manifest_file=$1
if [ ! -f "$manifest_file" ]; then
    echo "Manifest file not found: $manifest_file" >&2
    exit 1
fi

# Validation: If empty manifest file
if [ ! -s "$manifest_file" ]; then
    echo "Manifest file is empty: $manifest_file" >&2
    exit 1
fi

# Validation: Malformed entry
services=($(read_manifest "$manifest_file"))
for i in "${!services[@]}"; do
    service="${services[$i]}"
    service_name=$(extract_service_name "$service")
    if [ -z "$service_name" ]; then
        echo "Malformed entry: $service. Please fix the manifest file." >&2
        exit 1
    fi
    if [ ! -d "$service" ]; then
        echo "Service directory not found: $service" >&2
        exit 1
    fi
done

echo "Service Pre-Deployment Check Report:"
echo "===================================="
# NOTE: TBH, I just ChatGPTed this for loop.
for i in "${!services[@]}"; do
    service="${services[$i]}"
    service_name=$(extract_service_name "$service")
    version=$(extract_version_from_path "$service")
    artifact=$(check_artifact "$service_name" "$version")

    echo "Service: $service_name"
    echo "Version: $version"
    echo "Artifact: $artifact"

    # Print separator only if not last
    if [ $i -lt $(( ${#services[@]} - 1 )) ]; then
        echo "------------------------------------"
    fi
done
echo "===================================="
