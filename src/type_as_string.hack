/** sgml-stream-codegen is MIT licensed, see /LICENSE. */
namespace HTL\SGMLStreamCodegen;

use namespace HH\Lib\{Str, Vec};
use function var_export_pure;

function type_as_string(AttributeDefinition $def)[defaults]: string {
  if ($def['type'] !== 'enum') {
    return $def['type'];
  }

  $values = Shapes::at($def, 'type_enum_values');

  $literals = Vec\map($values, $t ==> var_export_pure($t) as string);
  $one_line = Str\join($literals, ', ');
  if (Str\length($one_line) < 50) {
    return 'enum {'.$one_line.'}';
  }

  return "enum {\n  ".Str\join($literals, ",\n  ").",\n}";
}
