build_all: build_namespaced build_non_namespaced

build_namespaced:
	hhvm bin/generate.hack \
	definitions/html/tags.json \
	definitions/html/global_attributes.json \
	build/html-stream-namespaced/src \
	"HTL\\HTMLStream" \
	"html-stream-namespaced is MIT licensed, see /LICENSE."

build_non_namespaced:
	hhvm bin/generate.hack \
	definitions/html/tags.json \
	definitions/html/global_attributes.json \
	build/html-stream-non-namespaced/src \
	"" \
	"html-stream-non-namespaced is MIT licensed, see /LICENSE."

diff_namespaced: build_namespaced
	cd build/html-stream-namespaced && hh_client restart && hh_client && git diff

diff_non_namespaced: build_non_namespaced
	cd build/html-stream-non-namespaced && hh_client restart && hh_client && git diff
