#!/usr/bin/env bash
set -euo pipefail

cd -- "$(dirname -- "${BASH_SOURCE[0]}")"

missing_destination=false
for library in html-stream-namespaced html-stream-non-namespaced svg-stream-namespaced; do
  if [[ ! -d "build/$library/src" ]]; then
    echo "Missing output directory: build/$library/src" >&2
    missing_destination=true
  fi
done
if [[ "$missing_destination" == true ]]; then
  echo "Set up all three output destinations before generating; see README.md, Generation setup." >&2
  exit 1
fi

echo "html-stream-namespaced..."

hhvm bin/generate.hack \
  definitions/html/tags.json \
  definitions/html/global_attributes.json \
  build/html-stream-namespaced/src \
  'HTL\HTMLStream' \
  'html-stream-namespaced is MIT licensed, see /LICENSE.' \
  'HTMLElementBase'

echo "html-stream-non-namespaced..."

hhvm bin/generate.hack \
  definitions/html/tags.json \
  definitions/html/global_attributes.json \
  build/html-stream-non-namespaced/src \
  '' \
  'html-stream-non-namespaced is MIT licensed, see /LICENSE.' \
  'HTMLElementBase'

echo "svg-stream-namespaced..."

hhvm bin/generate.hack \
  definitions/svg/tags.json \
  definitions/html/global_attributes.json \
  build/svg-stream-namespaced/src \
  'HTL\SVGStream' \
  'svg-stream-namespaced is MIT licensed, see /LICENSE.' \
  SVGElementBase \
  definitions/svg/global_attributes.json

echo "Done!"
