/** sgml-stream-codegen is MIT licensed, see /LICENSE. */
namespace HTL\SGMLStreamCodegen;

use namespace HH;
use namespace HH\Lib\{C, Str, Vec};

const int TAGS_DEFINITION_FILE = 1;
const int GLOBAL_ATTRIBUTES_DEFINITION_FILE = 2;
const int BUILD_DIRECTORY = 3;
const int NAMESPACE_NAME = 4;
const int LICENSE_HEADER = 5;

<<__EntryPoint>>
async function generate_async()[defaults]: Awaitable<void> {
  $autoloader = __DIR__.'/../vendor/autoload.hack';
  if (HH\could_include($autoloader)) {
    require_once $autoloader;
    HH\dynamic_fun('Facebook\AutoloadMap\initialize')();
  }

  $argv = \HH\global_get('argv') |> cast_to_vec_of_string($$);

  if (C\count($argv) !== 6) {
    echo Str\format(
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

  $new_file = $path ==> {
    $codegen_file = new CodegenFile($path);
    $codegen_file->append('/** '.$license_header.' */ ');
    $codegen_file->append(
      "/**\n * This file is generated. Do not modify it manually!\n */",
    );
    return $codegen_file;
  };

  $tags = \file_get_contents($tags_definition_file) as string
    |> \json_decode($$, true, 512, \JSON_FB_HACK_ARRAYS)
    |> cast_to_tag_defs($$);

  $files = Vec\map_with_key($tags, ($name, $tag) ==> {
    $path = $build_dir.'/tags/'.$name[0].'/';
    if (!\is_dir($path)) {
      \mkdir($path, 0777, true);
    }
    $uses_interfaces =
      Str\contains(\json_encode($tag) as string, 'SGMLStreamInterfaces');

    $codegen_file = $new_file($path.$name.'.hack');

    if ($namespace is nonnull) {
      $codegen_file->append('namespace '.$namespace.';');
    }

    $codegen_file->append(
      $uses_interfaces
        ? 'use namespace HTL\\{SGMLStream, SGMLStreamInterfaces};'
        : 'use namespace HTL\\SGMLStream;',
    );

    $codegen_file->newline();

    codegen_tag($codegen_file, $tag, $name);
    return $codegen_file;
  });

  $codegen_file = $new_file($build_dir.'/HTMLElementBase.hack');

  if ($namespace is nonnull) {
    $codegen_file->append('namespace '.$namespace.';');
  }

  $codegen_file->append(
    'use namespace HTL\\{SGMLStream, SGMLStreamInterfaces};',
  );

  $codegen_file->newline();

  $codegen_file->append(
    "abstract class _MANGLED_HTMLElementBase extends SGMLStream\\RootElement {\n".
    "  const ctx INITIALIZATION_CTX = [];\n",
  );

  $codegen_file->append(codegen_attributes(
    \file_get_contents($globals) as string
      |> \json_decode($$, true, 512, \JSON_FB_HACK_ARRAYS)
      |> cast_to_attr_defs($$),
  ));

  $codegen_file->append('}');

  $files[] = $codegen_file;

  await Vec\map_async($files, async $f ==> await $f->writeToDiskAsync());
}
