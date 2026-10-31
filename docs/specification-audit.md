# HTML and SVG specification audit

Reviewed 29 October 2026 against the WHATWG HTML Living Standard, last updated 26 October 2026, and the SVG 2 Editor's Draft, including its linked animation, filter, and masking specifications. The audit covers the declarative surface this generator can represent: elements, attributes, canonical values, documentation, and rendering traits. It also triages the complete specifications' tables of contents for capabilities outside the definition files.

All 113 current HTML-namespace elements and all 63 current SVG elements are represented. HTML's obsolete `param` is retained as a 114th compatibility class. The element and attribute indices were cross-checked with normative element definitions and IDL: the indices alone omit valid features such as `dialog.closedby` and SVG root window handlers. [HTML indices](https://html.spec.whatwg.org/multipage/indices.html), [SVG elements](https://svgwg.org/svg2-draft/eltindex.html), [SVG attributes](https://svgwg.org/svg2-draft/attindex.html).

## Definition updates

| Area | Correction and useful example |
| --- | --- |
| Editing and translation | Admit `contenteditable="plaintext-only"` and the valid empty aliases for `contenteditable`, `spellcheck`, and `translate`. [Editing](https://html.spec.whatwg.org/multipage/interaction.html#attr-contenteditable), [spellcheck](https://html.spec.whatwg.org/multipage/interaction.html#attr-spellcheck), [translate](https://html.spec.whatwg.org/multipage/dom.html#attr-translate). |
| Fetch settings | Admit `crossorigin=""` on HTML media, images, links, and scripts, and `preload=""` on media. Model `blocking` as a token-set string, accepting both `""` and `" render "`. [CORS](https://html.spec.whatwg.org/multipage/urls-and-fetching.html#cors-settings-attributes), [preload](https://html.spec.whatwg.org/multipage/media.html#attr-media-preload), [blocking](https://html.spec.whatwg.org/multipage/urls-and-fetching.html#blocking-attributes). |
| Numeric HTML values | Retain `float` for `meter` and `progress`, preserving nullable-float property reads. Integer counters require an explicit conversion; widening to `num` would break existing readers. Fix the swapped progress documentation links. [Progress and meter](https://html.spec.whatwg.org/multipage/form-elements.html#the-progress-element). |
| Shadow styling | Add `part` and `exportparts`, including space-separated part names and comma-separated forwarding mappings. [CSS Shadow](https://drafts.csswg.org/css-shadow-1/#part-attr). |
| Content event handlers | Complete HTML's `GlobalEventHandlers`, including its four legacy WebKit aliases. Include content handlers defined by CSS animation/transition/scroll snapping, Pointer Events, Selection, Touch Events, and WebXR overlays. Each definition links its defining specification. These declarations describe markup syntax; event delivery depends on browser support and context. [HTML handlers](https://html.spec.whatwg.org/multipage/webappapis.html#globaleventhandlers). |
| Media extensions | Add remote-playback control on audio/video, picture-in-picture controls and events on video, and encrypted-media handlers on audio/video. [Remote Playback](https://w3c.github.io/remote-playback/#the-disableremoteplayback-attribute), [Picture-in-Picture](https://w3c.github.io/picture-in-picture/), [Encrypted Media](https://w3c.github.io/encrypted-media/#dom-htmlmediaelement-onencrypted). |
| Capture and frame policy | Add file-input `capture` and the `iframe.csp` content attribute. CSP Embedded Enforcement remains a Working Group draft. [HTML Media Capture](https://www.w3.org/TR/html-media-capture/#the-capture-attribute), [embedded CSP](https://w3c.github.io/webappsec-cspee/#csp-attribute). |
| SVG filter regions | Change `feOffset.x/y` and `feDropShadow.x/y` to strings, matching other primitive regions and accepting `x="-10%"` or `y="-2px"`. Numeric displacements `dx/dy` stay numeric. [Common filter attributes](https://drafts.csswg.org/filter-effects-1/#CommonAttributes). |
| SVG root events | Add the missing `WindowEventHandlers` required by `SVGSVGElement`, such as `onhashchange` and `onbeforeprint`. [SVG root interface](https://svgwg.org/svg2-draft/struct.html#InterfaceSVGSVGElement), [window handlers](https://html.spec.whatwg.org/multipage/webappapis.html#windoweventhandlers). |
| Generated help | Correct direction-field submission, script types, navigable names, icon-size sets, time values, template markers, and custom button commands. Add tag-level help so retained obsolete `param`, area attributes, object `usemap`, and input `datetime` can be identified as compatibility surfaces. |

Working Group draft additions are included deliberately as specification-defined authoring surfaces, alongside legacy event aliases. Generated help identifies the status of WebXR DOM Overlays, CSS Scroll Snap Level 2, iframe CSP, and the added WebKit aliases. The current shared-global pipeline also exposes the new global declarations to SVG; separating that pipeline remains open below.

Changing filter-region coordinates from `num` to `string` requires existing numeric callers, including `x={0}` literals, to supply strings such as `x="0"`. Meter/progress retain their existing `float` declarations and `?float` read types.

## Coverage retained

All five microdata globals are present. Every current per-element HTML attribute in the index is represented; normative sections resolve index discrepancies. SVG coverage includes all 35 core/animation element summaries, all 28 linked filter/masking summaries, and the canonical per-element enums. The 58 generic SVG presentation attributes are already strings, admitting CSS-wide keywords and `var()` values. Arbitrary CSS properties do not automatically become SVG presentation attributes. [Microdata](https://html.spec.whatwg.org/multipage/microdata.html), [SVG presentation attributes](https://svgwg.org/svg2-draft/styling.html#PresentationAttributes).

HTML void elements and HTML script/style rendering traits match their syntax categories. SVG script/style correctly use escaped text; paired empty SVG tags, camelCase names, and namespace prefixes are preserved. Animation `fill="freeze"` remains distinct from paint `fill`. [HTML syntax](https://html.spec.whatwg.org/multipage/syntax.html#elements-2), [SVG attribute syntax](https://svgwg.org/svg2-draft/types.html#syntax), [SVG animation](https://svgwg.org/specs/animations/).

Existing XLink and other legacy SVG declarations remain available. Removed SVG fonts and `animateColor`, SVG Tiny-only features, arbitrary incubation proposals such as `webkitdirectory`, and explicitly non-conforming generator attributes are outside the current-element inventory. Fullscreen's event properties deliberately have no content attributes. [SVG changes](https://svgwg.org/svg2-draft/changes.html), [Directory Entries draft status](https://wicg.github.io/entries-api/), [Fullscreen](https://fullscreen.spec.whatwg.org/#api).

## Remaining work

These findings need a broader API or runtime change and remain open.

| Priority | Finding | Required change |
| --- | --- | --- |
| High | `hidden="until-found"` is rejected by the BooleanAttribute declaration. | Design a representation retaining existing `SET`/`NOT_SET` callers. Replacing it with a string breaks those callers; widening to `mixed` loses checking. Typed unions require unstable syntax, and boolean literals are rejected by XHP enum typing on the checked HHVM version. [Hidden states](https://html.spec.whatwg.org/multipage/interaction.html#the-hidden-attribute). |
| High | A leading LF in `pre` or `textarea` loses one character after HTML parsing. Literal CR/NUL also have parser-normalization semantics. | Fix character preservation in sgml-stream's streaming serializer. A plain tag-trait choice cannot inspect the first rendered character across asynchronous children. [Element restrictions](https://html.spec.whatwg.org/multipage/syntax.html#element-restrictions), [input preprocessing](https://html.spec.whatwg.org/multipage/parsing.html#preprocessing-the-input-stream). |
| Medium | SVG inherits the entire HTML global set, permitting misleading attributes such as `accesskey`. Adding HTML's XHTML `xmlns` also collides with SVG's declaration. | Separate shared core/events from namespace-specific globals with a compatibility plan. This also enables typed XHTML namespace declarations for `foreignObject` descendants. [SVG focus](https://svgwg.org/svg2-draft/interact.html#Focus), [HTML globals](https://html.spec.whatwg.org/multipage/dom.html#global-attributes). |
| Medium | Autonomous custom-element names require a hyphen, which is not a legal modern Hack class identifier. | Separate generated class identifiers from serialized tag names, validate identifiers and collisions, and retain built-in defaults. [Custom-element names](https://html.spec.whatwg.org/multipage/custom-elements.html#valid-custom-element-name). |
| Medium | `template.for` is declared, but its `<?marker?>` and `<?start?>…<?end>` targets have no standard streaming node. | Add safely serialized processing-instruction helpers outside the element JSON inventory. A complete-document doctype helper is another convenience opportunity. [Processing instructions](https://html.spec.whatwg.org/multipage/syntax.html#processing-instructions), [template targets](https://html.spec.whatwg.org/multipage/scripting.html#attr-template-for). |
| Separate output contract | Adding `xmlns` does not produce standalone XML: boolean `SET` emits a bare attribute and embedded HTML void tags use HTML syntax. | Define and implement an XML serialization mode in the runtime before claiming standalone SVG or XHTML support. The SVG library already documents inline HTML SVG as its output contract. [SVG conformance](https://svgwg.org/svg2-draft/conform.html#ConformingSVGStandAloneFiles), [XML syntax](https://html.spec.whatwg.org/multipage/xhtml.html). |

The typed API intentionally uses canonical enum spellings and Hack numeric values. It accepts less than the complete lexical grammar: HTML `dir="RTL"` is conforming but rejected by the canonical enum, and numeric SVG declarations cannot carry arbitrary CSS expressions. A broader lexical API needs a deliberate design. Content models, required attribute combinations, URL grammars, numeric ranges, and accessibility semantics remain author responsibilities. Raw HTML script/style content follows the existing runtime escaping contract. [HTML enums](https://html.spec.whatwg.org/multipage/common-microsyntaxes.html#keywords-and-enumerated-attributes), [SVG types](https://svgwg.org/svg2-draft/types.html#syntax).

## Specification triage

| Specification areas | Disposition |
| --- | --- |
| HTML chapters 1–3: introduction, infrastructure, document semantics | Checked scope, microsyntaxes, globals, and content-model boundaries. |
| HTML chapters 4–6: elements, microdata, interaction | Checked element/attribute inventories and normative definitions, custom elements, editing, hidden states, and templates. |
| HTML chapters 7–8: loading and web application APIs | Checked declarative settings and content handlers; browser scheduling and execution algorithms are outside this generator. |
| HTML chapters 9–12: communication, workers, worklets, storage | Browser APIs; their relevant declarative surface is window content handlers. |
| HTML chapters 13–14: HTML and XML syntax | Checked rendering traits, escaping boundaries, character preservation, namespaces, doctypes, and processing instructions. |
| HTML chapters 15–17: rendering, obsolete features, IANA | Browser layout stays outside codegen; retained legacy surfaces and output-contract documentation are relevant. |
| SVG concepts, rendering model, types, structure, styling | Checked serialization boundaries, common attributes, geometry/presentation distinctions, and namespaces. |
| SVG coordinates, paths, shapes, text, embedded content, painting, paint servers, linking, interaction | Checked their complete indexed definition surface and normative element summaries. Layout, rasterization, DOM behavior, and accessibility mappings are browser work. |
| Linked SVG Animation, Filter Effects, CSS Masking | Checked all relevant element summaries and canonical attribute values. |

This audit covers the generator's declarative surface and triages the remaining specification chapters. It does not verify implementations of browser algorithms.

## Reproducing the examples

Run `./build_all.sh` first. The [attribute fixture](../tests/fixtures/spec_attributes.hack.txt) contains typed examples and exact serialized expectations for both HTML variants and SVG. Like the existing rendering fixture, it runs in an isolated project containing the generated classes and their shared runtime dependencies:

```sh
audit_dir=$(mktemp -d /tmp/sgml-spec-check.XXXXXX)
cp .hhconfig .hhvmconfig.hdf "$audit_dir/"
cp -a vendor "$audit_dir/"
mkdir "$audit_dir/src"
for library in html-stream-namespaced html-stream-non-namespaced \
  svg-stream-namespaced; do
  cp -a "../$library/src" "$audit_dir/src/$library"
done
for runtime in \
  sgml-stream@4710fe8d5c4b23463e2a46151b5d5b4e593f77ca \
  sgml-stream-interfaces@0ac7112221a0c33be7f1da645cd3f66d2ef36ca9; do
  library=${runtime%@*}
  revision=${runtime#*@}
  mkdir "$audit_dir/src/$library"
  git -C "../$library" archive "$revision" src | \
    tar -x -C "$audit_dir/src/$library" --strip-components=1
done
cp tests/fixtures/spec_attributes.hack.txt "$audit_dir/spec_attributes.hack"
docker run --rm --cpus=2 \
  -v "$audit_dir:/mnt/project" \
  -v "$audit_dir/.hhconfig:/etc/hh.conf:ro" \
  -w /mnt/project hersheltheodorelayton/hhvm-full:26.09.29 \
  bash -c 'hh_client --timeout 60 --config max_workers=2 && \
    hhvm -dhhvm.autoload.db.path=/tmp/facts.db spec_attributes.hack'
```

These examples establish typed acceptance and serialization, rather than browser support or event delivery. Regeneration and the generator's normal test, lint, and strict type checks are separate checks.
