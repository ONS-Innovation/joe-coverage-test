#!/bin/bash
set -euo pipefail

poetry run pytest -n auto \
  --cov=joe_coverage_test \
  --cov-report term-missing \
  --cov-fail-under=50 \
  tests/ | tee pytest_output.log

COVERAGE=$(grep -Eo 'TOTAL\s+[0-9]+\s+[0-9]+\s+[0-9]+\s+[0-9]+\s+([0-9]+%)' pytest_output.log | tail -1 | grep -Eo '[0-9]+')

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
