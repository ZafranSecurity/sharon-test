#!/bin/bash

# Check if three arguments are provided
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <chart_name> <helm_chart_path> <helm_values_file_path>"
    exit 1
fi

# Assign the input arguments to variables
CHART_NAME="$1"
HELM_CHART_PATH="$2"
HELM_VALUES_FILE_PATH="$3"
echo "==================== Helm Diff for $(basename "$DIR_NAME") ===================="
helm diff upgrade --allow-unreleased $CHART_NAME $HELM_CHART_PATH -f "$HELM_VALUES_FILE_PATH"
if [ $? -ne 0 ]; then
    echo "Check diff failed for $(basename "$DIR_NAME")"
    exit 1
fi