/** sgml-stream-codegen is MIT licensed, see /LICENSE. */
namespace HTL\SGMLStreamCodegen;

use namespace HH\Lib\{C, File};
use namespace HTL\TestChain;
use function HTL\Expect\expect;
use function json_decode;
use const JSON_FB_HACK_ARRAYS;

<<TestChain\Discover>>
function html_rendering_traits_test(TestChain\Chain $chain)[]: TestChain\Chain {
  return $chain->group(__FUNCTION__)
    ->testAsync('html_element_categories', async ()[defaults] ==> {
      $file = File\open_read_only(__DIR__.'/../definitions/html/tags.json');
      using $file->closeWhenDisposed();
      $tags = await $file->readAllAsync()
        |> json_decode($$, true, 512, JSON_FB_HACK_ARRAYS)
        |> cast_to_tag_defs($$);
      // https://html.spec.whatwg.org/multipage/syntax.html#void-elements
      // Retain obsolete param with the void behavior required by HTML parsing.
      $void = keyset[
        'area',
        'base',
        'br',
        'col',
        'embed',
        'hr',
        'img',
        'input',
        'link',
        'meta',
        'param',
        'source',
        'track',
        'wbr',
      ];
      foreach ($void as $name) {
        expect(C\contains_key($tags, $name))->toEqual(true);
      }
      foreach ($tags as $name => $tag) {
        $expected = C\contains($void, $name)
          ? 'SGMLStream\\ElementWithOpenTagOnly'
          : (
              C\contains(keyset['script', 'style'], $name)
                ? 'SGMLStream\\ElementWithOpenAndCloseTagsAndUnescapedContent'
                : 'SGMLStream\\ElementWithOpenAndCloseTags'
            );
        expect(tuple($name, $tag['traits']))
          ->toEqual(tuple($name, vec[$expected]));
      }
    });
}
