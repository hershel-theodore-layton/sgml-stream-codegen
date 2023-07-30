/** sgml-stream-codegen is MIT licensed, see /LICENSE. */
namespace HTL\SGMLStreamCodegen;

type TagDefinition = shape(
  'attributes' => dict<string, AttributeDefinition>,
  'base_class' => string,
  'interfaces' => vec<string>,
  'traits' => vec<string>,
  'see' => string,
);
