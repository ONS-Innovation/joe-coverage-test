#!/bin/bash
set -euo pipefail

poetry run pytest -n auto \
  --cov=joe_coverage_test \
  --cov-report term-missing \
  --cov-fail-under=50 \
  tests/ | tee pytest_output.log

# Handles format "TOTAL 45 5 89%"
COVERAGE=$(grep -Eo 'TOTAL\s+.*[0-9]+%' pytest_output.log | tail -1 | grep -Eo '[0-9]+%' | tr -d '%')

if [ -z "${COVERAGE:-}" ]; then
  echo "Could not parse coverage percentage from pytest_output.log"
  exit 1
fi

cat <<EOF > coverage_summary.json
{
  "coverage": $COVERAGE
}
EOF

echo "Saved to coverage_summary.json"
