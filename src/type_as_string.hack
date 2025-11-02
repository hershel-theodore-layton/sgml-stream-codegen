/** sgml-stream-codegen is MIT licensed, see /LICENSE. */
namespace HTL\SGMLStreamCodegen;

use namespace HH\Lib\{Str, Vec};
function type_as_string(AttributeDefinition $def)[defaults]: string {
  if ($def['type'] !== 'enum') {
    return $def['type'];
  }

  $values = Shapes::at($def, 'type_enum_values');

  $one_line = Vec\map($values, $t ==> \var_export_pure($t) as string)
    |> Str\join($$, ', ');
  if (Str\length($one_line) < 50) {
    return 'enum {'.$one_line.'}';
  }

  // This ends up creating a multi line `enum {`.
  return \var_export_pure($values) as string
    |> Str\replace_every($$, dict['vec [' => 'enum {', ']' => '}']);
}
