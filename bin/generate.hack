/** sgml-stream-codegen is MIT licensed, see /LICENSE. */
namespace HTL\SGMLStreamCodegen;

use type Facebook\HackCodegen\{
  CodegenFile,
  CodegenFileType,
  HackCodegenFactory,
};
use namespace Facebook\TypeAssert;
use namespace HH\Lib\{C, Str};

const int TAGS_DEFINITION_FILE = 1;
const int GLOBAL_ATTRIBUTES_DEFINITION_FILE = 2;
const int BUILD_DIRECTORY = 3;
const int NAMESPACE_NAME = 4;
const int LICENSE_HEADER = 5;

<<__EntryPoint>>
async function generate_async(): Awaitable<void> {
  require_once __DIR__.'/../vendor/autoload.hack';
  \Facebook\AutoloadMap\initialize();

  $argv = \HH\global_get('argv')
    |> TypeAssert\matches<Container<string>>($$)
    |> vec($$);

  if (C\count($argv) !== 6) {
    \fprintf(
      \STDERR,
      'Usage: hhvm %s %s %s %s %s %s ',
      $argv[0],
      '<tags-definitions-file> ',
      '<global-attributes-definitions-file> ',
      '<build-directory> ',
      '<namespace (empty string for root namespace)> ',
      '<license-header>',
    );
    return;
  }

  $tags_definition_file = \realpath($argv[TAGS_DEFINITION_FILE]) |> mixed($$);
  invariant(
    $tags_definition_file is string,
    '%s not found',
    $argv[TAGS_DEFINITION_FILE],
  );
  $globals = \realpath($argv[GLOBAL_ATTRIBUTES_DEFINITION_FILE]) |> mixed($$);
  invariant(
    $globals is string,
    '%s not found',
    $argv[GLOBAL_ATTRIBUTES_DEFINITION_FILE],
  );
  $build_dir = \realpath($argv[BUILD_DIRECTORY]) |> mixed($$);
  invariant($build_dir is string, '%s not found', $argv[BUILD_DIRECTORY]);
  $namespace = $argv[NAMESPACE_NAME] |> $$ === '' ? null : $$;
  $license_header = $argv[LICENSE_HEADER];
  invariant(
    \is_readable($tags_definition_file),
    'Could not read from tag definition json file %s',
    $tags_definition_file,
  );
  invariant(
    \is_readable($globals),
    'Could not read from global attributes definition json file %s',
    $globals,
  );

  $config = new HackCodegenConfig(
    shape(
      'file_header' => vec[$license_header],
      // This mostly affects comments with an `@see` to the whatwg.
      // These links are sometimes just long enough to not fit after
      // the `@see` on a single 80 char line.
      // Actual code will remain below 80 chars most likely.
      'max_line_length' => 90,
    ),
  );
  $fac = new HackCodegenFactory($config);
  $tags = \file_get_contents($tags_definition_file)
    |> \json_decode($$, true, 512, \JSON_FB_HACK_ARRAYS)
    |> TypeAssert\matches<dict<string, TagDefinition>>($$);

  foreach ($tags as $name => $tag) {
    $path = $build_dir.'/tags/'.$name[0].'/';
    if (!\is_dir($path)) {
      \mkdir($path, 0777, true);
    }
    $uses_interfaces = Str\contains(\json_encode($tag), 'SGMLStreamInterfaces');

    $codegen_file = (new CodegenFile($config, $path.$name.'.hack'))
      ->setFileType(CodegenFileType::DOT_HACK)
      ->useNamespace(
        $uses_interfaces
          ? 'HTL\\{SGMLStream, SGMLStreamInterfaces}'
          : 'HTL\\SGMLStream',
      );
    if ($namespace is nonnull) {
      $codegen_file->setNamespace($namespace);
    }
    codegen_tag($codegen_file, $fac, $tag, $name)->save();
  }

  $codegen_file = (new CodegenFile($config, $build_dir.'/HTMLElementBase.hack'))
    ->setFileType(CodegenFileType::DOT_HACK)
    ->useNamespace('HTL\\{SGMLStream, SGMLStreamInterfaces}');
  if ($namespace is nonnull) {
    $codegen_file->setNamespace($namespace);
  }
  $codegen_file->addClass(
    $fac->codegenClass('HTMLElementBase')
      ->setIsAbstract()
      ->setIsXHP()
      ->setExtends('SGMLStream\\RootElement')
      ->addXhpAttributes(codegen_attributes(
        $fac,
        \file_get_contents($globals)
          |> \json_decode($$, true, 512, \JSON_FB_HACK_ARRAYS)
          |> TypeAssert\matches<dict<string, AttributeDefinition>>($$),
      )),
  )
    ->save();
}
