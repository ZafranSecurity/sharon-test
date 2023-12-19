#!/bin/bash

# Check if two arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <helm_chart_path> <helm_values_file_path>"
    exit 1
fi

# Assign the input arguments to variables
HELM_CHART_PATH="$1"
HELM_VALUES_FILE_PATH="$2"

# Main script logic
if [ -f "$HELM_VALUES_FILE_PATH" ]; then
    DIR_NAME=$(dirname "$HELM_VALUES_FILE_PATH")

    echo "==================== Dry run Helm Chart with $(basename "$DIR_NAME") values ===================="
    helm install --dry-run --debug test-release $HELM_CHART_PATH -f "$HELM_VALUES_FILE_PATH"
    if [ $? -ne 0 ]; then
      echo "Dry run test failed for $(basename "$DIR_NAME")"
      exit 1
    fi

    echo "==================== Helm Diff for $(basename "$DIR_NAME") ===================="
    helm diff upgrade --allow-unreleased test-release $HELM_CHART_PATH -f "$HELM_VALUES_FILE_PATH"
    if [ $? -ne 0 ]; then
      echo "Check diff failed for $(basename "$DIR_NAME")"
      exit 1
    fi
fi
