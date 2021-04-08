/** sgml-stream-codegen is MIT licensed, see /LICENSE. */
namespace HTL\SGMLStreamCodegen;

use namespace HH\Lib\Vec;
use type Facebook\HackCodegen\{CodegenXHPAttribute, HackCodegenFactory};

function codegen_attributes(
  HackCodegenFactory $fac,
  dict<string, AttributeDefinition> $attributes,
): vec<CodegenXHPAttribute> {
  return Vec\map_with_key(
    $attributes,
    ($name, $attr) ==> $fac->codegenXHPAttribute($name)
      ->setInlineComment(
        '@see '.
        $attr['see'].
        (Shapes::keyExists($attr, 'help') ? "\n".$attr['help'] : ''),
      )
      ->setType(type_as_string($attr)),
  );
}
