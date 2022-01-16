/** sgml-stream-codegen is MIT licensed, see /LICENSE. */
namespace HTL\SGMLStreamCodegen;

use namespace HH\Lib\Vec;
use type Facebook\HackCodegen\{
  CodegenFile,
  HackBuilderValues,
  HackCodegenFactory,
};

function codegen_tag(
  CodegenFile $file,
  HackCodegenFactory $fac,
  TagDefinition $def,
  string $tag_name,
): CodegenFile {
  $tag = $fac->codegenClass($tag_name)
    ->setDocBlock(
      '@see '.
      $def['see'].
      (Shapes::keyExists($def, 'comment') ? "\n".$def['comment'] : ''),
    )
    ->setIsFinal()
    ->setIsXHP()
    ->setExtends($def['base_class'])
    ->addInterfaces(
      Vec\map(
        $def['interfaces'] ?? vec[],
        $i ==> $fac->codegenImplementsInterface($i),
      ),
    )
    ->addTraits(
      Vec\map($def['traits'], $name ==> $fac->codegenUsesTrait($name)),
    )
    ->addXhpAttributes(codegen_attributes($fac, $def['attributes']))
    ->addConstant(
      $fac->codegenClassConstant('TAG_NAME')
        ->setType('string')
        ->setValue($tag_name, HackBuilderValues::export()),
    );

  return $file->addClass($tag);
}
