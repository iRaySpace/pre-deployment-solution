#!/bin/bash

API_URL="https://api.mockrepo.com"


mock_curl() {
    local url=$1

    local service_name=$(echo "$url" | awk -F/ '{print $(NF-1)}')
    local version=$(echo "$url" | awk -F/ '{print $NF}')

    if [ "$service_name" == "user-service" ] && [ "$version" == "1.2.3" ]; then
        echo '{"status":"available"}'
        echo '200'
        return 0
    elif [ "$service_name" == "user-service" ] || [ "$service_name" == "product-service" ]; then
        echo '{"status":"unavailable"}'
        echo '200'
        return 0
    else
        # Note: If CURL is "Failed to connect to host"
        return 7
    fi
}


check_artifact() {
    local service_name=$1
    local version=$2

    if [ "$version" == "unknown" ]; then
        echo "n/a"
        return 0
    fi

    local url="$API_URL/check-artifact/$service_name/$version"

    local response
    # response=$(curl -sS -w "\n%{http_code}" "$url")
    response=$(mock_curl "$url")
    local curl_code=$?
    if [ $curl_code -ne 0 ]; then
        echo "error_checking_artifact"
        return 1
    fi

    local http_code=$(echo "$response" | tail -n1)
    if [ $http_code != "200" ]; then
        echo "error_checking_artifact"
        return 1
    fi

    local body=$(echo "$response" | head -n -1 | jq -r ".status")
    echo $body
    return 0
}