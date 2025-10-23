#!/bin/bash

#!/usr/bin/env bash
set -euo pipefail

# Run pytest with coverage
poetry run pytest -n auto \
  --cov=joe_coverage_test \
  --cov-report term-missing \
  --cov-fail-under=50 \
  tests/ | tee pytest_output.log

# Extract the coverage percentage from pytest output
COVERAGE=$(grep -Eo 'TOTAL\s+[0-9]+\s+[0-9]+\s+[0-9]+\s+[0-9]+\s+([0-9]+%)' pytest_output.log | tail -1 | grep -Eo '[0-9]+')

# Fallback if no coverage found
if [ -z "$COVERAGE" ]; then
  echo "Error: Could not extract coverage percentage."
  exit 1
fi

cat <<EOF > coverage.json
{
  "coverage": $COVERAGE
}
EOF

echo "Coverage: $COVERAGE%"
echo "Saved to coverage.json"
