# Deprecated: use ./build_all.sh
build_all: build_namespaced build_non_namespaced build_svg_namespaced

build_namespaced:
	hhvm bin/generate.hack \
	definitions/html/tags.json \
	definitions/html/global_attributes.json \
	build/html-stream-namespaced/src \
	"HTL\\HTMLStream" \
	"html-stream-namespaced is MIT licensed, see /LICENSE." \
  'HTMLElementBase'

build_non_namespaced:
	hhvm bin/generate.hack \
	definitions/html/tags.json \
	definitions/html/global_attributes.json \
	build/html-stream-non-namespaced/src \
	"" \
	"html-stream-non-namespaced is MIT licensed, see /LICENSE." \
  'HTMLElementBase'

build_svg_namespaced:
	hhvm bin/generate.hack \
	definitions/svg/tags.json \
	definitions/html/global_attributes.json \
	build/svg-stream-namespaced/src \
	"HTL\\SVGStream" \
	"svg-stream-namespaced is MIT licensed, see /LICENSE." \
	"SVGElementBase" \
	definitions/svg/global_attributes.json

diff_svg_namespaced: build_svg_namespaced
	cd build/svg-stream-namespaced && hh_client restart && hh_client && git diff

diff_namespaced: build_namespaced
	cd build/html-stream-namespaced && hh_client restart && hh_client && git diff

diff_non_namespaced: build_non_namespaced
	cd build/html-stream-non-namespaced && hh_client restart && hh_client && git diff
