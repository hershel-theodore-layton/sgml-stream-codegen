/** sgml-stream-codegen is MIT licensed, see /LICENSE. */
namespace HTL\SGMLStreamCodegen;

use namespace HH\Lib\{C, Str, Vec};

function codegen_attributes(
  dict<string, AttributeDefinition> $attributes,
)[defaults]: string {
  if (C\is_empty($attributes)) {
    return '';
  }

  return Vec\map_with_key(
    $attributes,
    ($name, $attr) ==> Str\format(
      "/**\n * @see %s\n%s */\n%s %s",
      $attr['see'],
      wrap_doc_block(Shapes::idx($attr, 'help')),
      type_as_string($attr),
      $name,
    ),
  )
    |> "attribute\n".Str\join($$, ",\n").';';
}
