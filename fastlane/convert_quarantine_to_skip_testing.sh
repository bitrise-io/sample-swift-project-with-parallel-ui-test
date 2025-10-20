#!/bin/bash
set -e

# Read JSON from environment variable
export BITRISE_QUARANTINED_TESTS_JSON='[{"testSuiteName":["BullsEyeFailingTests"],"className":"BullsEyeRandomlyFailingTests","testCaseName":"testRandomlyFail"},{"testSuiteName":["BullsEyeFailingTests"],"className":"BullsEyeRandomlyFailingTests","testCaseName":"testRandomlyFail2"}]'
json="$BITRISE_QUARANTINED_TESTS_JSON"

# Convert to array of TestTarget/TestSuite/TestCase
test_array=($(echo "$json" | jq -r '.[] | "\(.testSuiteName[0])/\(.className)/\(.testCaseName)"'))

# Join the array elements with a comma
skip_testing_list=$(IFS=, ; echo "${test_array[*]}")

envman add --key BITRISE_QUARANTINED_TESTS_LIST --value "$skip_testing_list"

# Print the comma-separated string
echo "$skip_testing_list"