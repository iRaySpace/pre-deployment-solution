#!/bin/bash

pass=0
fail=0


assert_equals() {
    local expected="$1"
    local actual="$2"
    local message="$3"

    if [ "$expected" == "$actual" ]; then
        echo "✔ PASS: $message"
        ((pass++))
    else
        echo "✘ FAIL: $message (expected '$expected', got '$actual')"
        ((fail++))
    fi
}

echo "Running tests..."
echo "Load functions to test..."
source ./service.sh
source ./helper.sh

# TEST: check_artifact
result=$(check_artifact "unknown-service" "unknown")
assert_equals "n/a" "$result" "Version unknown of unknown-service should return [n/a]"

result=$(check_artifact "user-service" "1.2.3")
assert_equals "available" "$result" "Version 1.2.3 of user-service should return [available]"

result=$(check_artifact "user-service" "2.0.0")
assert_equals "unavailable" "$result" "Version 2.0.0 of user-service should return [unavailable]"

# NOTE: For edge case
result=$(check_artifact "edge-case-service" "")
assert_equals "error_checking_artifact" "$result" "Version - of edge-case-service should return [error_checking_artifact]"

# Test: extract_service_name
result=$(extract_service_name "app/user-service")
assert_equals "user-service" "$result" "Extract service name for app/user-service should return [user-service]"

result=$(extract_service_name "app/product-service")
assert_equals "product-service" "$result" "Extract service name for app/product-service should return [product-service]"

result=$(extract_service_name "app/common-utils")
assert_equals "common-utils" "$result" "Extract service name for app/common-utils should return [common-utils]"

# ===============================
# Test: extract_version_from_file
# ===============================
result=$(extract_version_from_path "app/user-service")
assert_equals "1.2.3" "$result" "Version from app/user-service should return [1.2.3]"

result=$(extract_version_from_path "app/product-service")
assert_equals "0.5.0" "$result" "Version from app/product-service should return [0.5.0]"

result=$(extract_version_from_path "lib/common-utils")
assert_equals "unknown" "$result" "Version from lib/common-utils should return [unknown]"


# Test: read_manifest
result=$(read_manifest "file-not-found.txt")
assert_equals "1" "$?" "File not found should return an error"

result=$(read_manifest "services.txt")
expected="app/user-service
app/product-service
lib/common-utils"
assert_equals "$expected" "$result" "Should be able to read '$expected' from services.txt"

echo
echo "Tests: $((pass+fail)), Passed: $pass, Failed: $fail"
[ $fail -eq 0 ] || exit 1
