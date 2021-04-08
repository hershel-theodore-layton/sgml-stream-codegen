/** sgml-stream-codegen is MIT licensed, see /LICENSE. */
namespace HTL\SGMLStreamCodegen;

type AttributeDefinition = shape(
  ?'help' => string,
  'see' => string,
  'type' => string,
  ?'type_enum_values' => vec<string>,
);
