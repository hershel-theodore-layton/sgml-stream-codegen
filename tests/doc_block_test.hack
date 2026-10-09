/** sgml-stream-codegen is MIT licensed, see /LICENSE. */
namespace HTL\SGMLStreamCodegen;

use namespace HTL\TestChain;
use function HTL\Expect\expect;

<<TestChain\Discover>>
function doc_block_test(TestChain\Chain $chain)[]: TestChain\Chain {
  return $chain->group(__FUNCTION__)
    ->test('escapes_and_normalizes_help', ()[defaults] ==> {
      expect(wrap_doc_block("A regex /.*/.\r\nNext\rline\nhere."))
        ->toEqual(" * A regex /.* /. Next line here.\n");
      expect(wrap_doc_block(null))->toEqual('');
    })
    ->test('escapes_attribute_references', ()[defaults] ==> {
      expect(codegen_attributes(dict[
        'pattern' => shape(
          'see' => "Reference */\nnext",
          'help' => 'A regex /.*/.',
          'type' => 'string',
        ),
      ]))->toEqual(
        "attribute\n/**\n * @see Reference * / next\n".
        " * A regex /.* /.\n */\nstring pattern;",
      );
    })
    ->test('escapes_tag_references', ()[defaults] ==> {
      $file = new CodegenFile('unused.hack');
      codegen_tag(
        $file,
        shape(
          'attributes' => dict[],
          'base_class' => 'Base',
          'interfaces' => vec[],
          'traits' => vec[],
          'see' => "Reference */\r\nnext",
        ),
        'Example',
      );
      expect($file->toString())->toEqual(
        "/**\n * @see Reference * / next\n */\n".
        "final xhp class Example extends Base\n{\n\n\n".
        "const string TAG_NAME = 'Example';\n}\n",
      );
    })
    ->test('preserves_plain_documentation', ()[defaults] ==> {
      expect(escape_doc_block_text('Licensed under MIT.'))
        ->toEqual('Licensed under MIT.');
      expect(wrap_doc_block('Plain documentation.'))
        ->toEqual(" * Plain documentation.\n");
    });
}
