/** sgml-stream-codegen is MIT licensed, see /LICENSE. */
namespace HTL\SGMLStreamCodegen;

use namespace HH\Lib\Str;
use namespace HTL\TestChain;
use function HTL\Expect\expect;

<<TestChain\Discover>>
function type_as_string_test(TestChain\Chain $chain)[]: TestChain\Chain {
  return $chain->group(__FUNCTION__)
    ->testWith2Params(
      'preserves_enum_literals',
      enum_literal_cases<>,
      ($values, $expected)[defaults] ==> {
        expect(type_as_string(shape(
          'see' => '',
          'type' => 'enum',
          'type_enum_values' => $values,
        )))->toEqual($expected);
      },
    )
    ->test('preserves_non_enum_types', ()[defaults] ==> {
      expect(type_as_string(shape('see' => '', 'type' => 'string')))
        ->toEqual('string');
    });
}

function enum_literal_cases()[]: vec<(vec<string>, string)> {
  $special = "vec [ ] { } ' \\";
  $long = Str\repeat('a', 60);
  return vec[
    tuple(vec[], 'enum {}'),
    tuple(vec['one', 'two'], "enum {'one', 'two'}"),
    tuple(vec[$special], "enum {'vec [ ] { } \\' \\\\'}"),
    tuple(vec[Str\repeat('a', 47)], "enum {'".Str\repeat('a', 47)."'}"),
    tuple(vec[Str\repeat('a', 48)], "enum {\n  '".Str\repeat('a', 48)."',\n}"),
    tuple(
      vec[$special, $long],
      "enum {\n  'vec [ ] { } \\' \\\\',\n  '".$long."',\n}",
    ),
    tuple(
      vec['prefix vec ['.$long.']'],
      "enum {\n  'prefix vec [".$long."]',\n}",
    ),
  ];

}
