#!/usr/bin/env bash
set -euo pipefail

cd -- "$(dirname -- "${BASH_SOURCE[0]}")"

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
