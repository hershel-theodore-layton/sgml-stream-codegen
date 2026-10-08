#!/usr/bin/env bash
# sgml-stream-codegen is MIT licensed, see /LICENSE.
set -euo pipefail
cd "$(dirname "$0")/.."

scratch=$(mktemp -d)
trap 'rm -rf "$scratch"' EXIT
mkdir "$scratch/output"
printf '{}\n' > "$scratch/tags.json"
printf '{}\n' > "$scratch/globals.json"
printf 'existing output\n' > "$scratch/output/HTMLElementBase.hack"
cp "$scratch/output/HTMLElementBase.hack" "$scratch/original"

check_usage_error() {
  local status=0
  hhvm bin/generate.hack "$@" > "$scratch/stdout" 2> "$scratch/stderr" || status=$?
  if [[ "$status" != 64 ]]; then
    echo "Expected usage exit status 64, got $status" >&2
    exit 1
  fi
  [[ ! -s "$scratch/stdout" ]]
  grep -q '^Usage: hhvm ' "$scratch/stderr"
  cmp "$scratch/original" "$scratch/output/HTMLElementBase.hack"
  [[ $(find "$scratch/output" -type f | wc -l) == 1 ]]
}

check_usage_error
check_usage_error "$scratch/tags.json" "$scratch/globals.json" \
  "$scratch/output" ''
check_usage_error "$scratch/tags.json" "$scratch/globals.json" \
  "$scratch/output" '' 'Test license.' 'HTMLElementBase' \
  "$scratch/globals.json" 'unexpected'

# Exercise both optional arguments as well as the minimal valid invocation.
for optional_count in 0 1 2; do
  destination="$scratch/valid-$optional_count"
  mkdir "$destination"
  args=("$scratch/tags.json" "$scratch/globals.json" "$destination" '' 'Test license.')
  base_class=HTMLElementBase
  if [[ "$optional_count" -ge 1 ]]; then
    base_class=CustomBase
    args+=("$base_class")
  fi
  if [[ "$optional_count" -eq 2 ]]; then
    args+=("$scratch/globals.json")
  fi
  hhvm bin/generate.hack "${args[@]}" > "$scratch/stdout" 2> "$scratch/stderr"
  [[ ! -s "$scratch/stdout" && ! -s "$scratch/stderr" ]]
  [[ -s "$destination/$base_class.hack" ]]
  hhvm --lint "$destination/$base_class.hack"
done

echo 'Generator CLI checks passed.'
