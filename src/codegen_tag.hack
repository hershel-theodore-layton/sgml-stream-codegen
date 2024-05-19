/** sgml-stream-codegen is MIT licensed, see /LICENSE. */
namespace HTL\SGMLStreamCodegen;

use namespace HH\Lib\{C, Str};

function codegen_tag(
  CodegenFile $file,
  TagDefinition $def,
  string $tag_name,
): void {
  // If I emit `xhp class`, the file can not format.
  // If I emit `class var` (var is an element name),
  // the file fails to parse.
  $file->append(
    Str\format(
      "/**\n * @see %s\n */\nfinal class _MANGLED_%s extends %s",
      $def['see'],
      $tag_name,
      $def['base_class'],
    ),
  );

  if (!C\is_empty($def['interfaces'])) {
    $file->append(' implements '.Str\join($def['interfaces'], ', '));
  }

  $file->append('{');
  $file->newline();

  foreach ($def['traits'] as $trait) {
    $file->append(Str\format('use %s;', $trait));
  }

  $file->newline();

  $file->append(
    Str\format('const string TAG_NAME = %s;', \var_export($tag_name, true)),
  );

  $file->append(codegen_attributes($def['attributes']));

  $file->append('}');
}
