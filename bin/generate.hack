/** sgml-stream-codegen is MIT licensed, see /LICENSE. */
namespace HTL\SGMLStreamCodegen;

use namespace HH;
use namespace HH\Lib\{C, IO, Str, Vec};
use type HTL\Pragma\Pragmas;
use function file_get_contents,
  is_dir,
  is_readable,
  json_decode,
  json_encode,
  mkdir,
  preg_match,
  realpath;
use const JSON_FB_HACK_ARRAYS;

<<file: Pragmas(vec['PhaLinters', 'fixme:autoload_your_code'])>>

const int TAGS_DEFINITION_FILE = 1;
const int GLOBAL_ATTRIBUTES_DEFINITION_FILE = 2;
const int BUILD_DIRECTORY = 3;
const int NAMESPACE_NAME = 4;
const int LICENSE_HEADER = 5;
const int BASE_CLASS_NAME = 6;
const int ADDITIONAL_GLOBAL_ATTRIBUTES_FILE = 7;

<<__EntryPoint>>
async function generate_async()[defaults]: Awaitable<void> {
  $autoloader = __DIR__.'/../vendor/autoload.hack';
  if (HH\could_include($autoloader)) {
    require_once $autoloader;
    HH\dynamic_fun('Facebook\AutoloadMap\initialize')();
  }

  $argv = HH\global_get('argv') |> cast_to_vec_of_string($$);

  if (C\count($argv) < 6 || C\count($argv) > 8) {
    $stderr = IO\request_error() as nonnull;
    await $stderr->writeAllAsync(Str\format(
      "Usage: hhvm %s %s %s %s %s %s %s %s\n",
      $argv[0],
      '<tags-definitions-file> ',
      '<global-attributes-definitions-file> ',
      '<build-directory> ',
      '<namespace (empty string for root namespace)> ',
      '<license-header>',
      '[<base-class-name>',
      '[<additional-global-attributes-file>]]',
    ));
    exit(64);
  }

  $tags_definition_file = realpath($argv[TAGS_DEFINITION_FILE]) |> mixed($$);
  invariant(
    $tags_definition_file is string,
    '%s not found',
    $argv[TAGS_DEFINITION_FILE],
  );
  $globals = realpath($argv[GLOBAL_ATTRIBUTES_DEFINITION_FILE]) |> mixed($$);
  invariant(
    $globals is string,
    '%s not found',
    $argv[GLOBAL_ATTRIBUTES_DEFINITION_FILE],
  );
  $build_dir = realpath($argv[BUILD_DIRECTORY]) |> mixed($$);
  invariant($build_dir is string, '%s not found', $argv[BUILD_DIRECTORY]);
  $namespace = $argv[NAMESPACE_NAME] |> $$ === '' ? null : $$;
  $license_header = $argv[LICENSE_HEADER];
  $base_class = $argv[BASE_CLASS_NAME] ?? 'HTMLElementBase';
  invariant(
    preg_match('/\A[A-Za-z_][A-Za-z0-9_]*\z/', $base_class) === 1,
    'Invalid base class name: %s',
    $base_class,
  );
  invariant(
    is_readable($tags_definition_file),
    'Could not read from tag definition json file %s',
    $tags_definition_file,
  );
  invariant(
    is_readable($globals),
    'Could not read from global attributes definition json file %s',
    $globals,
  );

  $global_attributes = file_get_contents($globals) as string
    |> json_decode($$, true, 512, JSON_FB_HACK_ARRAYS)
    |> cast_to_attr_defs($$);
  $additional_globals = $argv[ADDITIONAL_GLOBAL_ATTRIBUTES_FILE] ?? null;
  if ($additional_globals is nonnull) {
    invariant(
      is_readable($additional_globals),
      'Could not read from global attributes definition json file %s',
      $additional_globals,
    );
    $additional_attributes = file_get_contents($additional_globals) as string
      |> json_decode($$, true, 512, JSON_FB_HACK_ARRAYS)
      |> cast_to_attr_defs($$);
    foreach ($additional_attributes as $name => $attribute) {
      invariant(
        !C\contains_key($global_attributes, $name),
        'Duplicate global attribute: %s',
        $name,
      );
      $global_attributes[$name] = $attribute;
    }
  }

  $new_file = $path ==> {
    $codegen_file = new CodegenFile($path);
    $codegen_file->append('/** '.$license_header.' */ ');
    $codegen_file->append(
      "/**\n * This file is generated. Do not modify it manually!\n */",
    );
    return $codegen_file;
  };

  $tags = file_get_contents($tags_definition_file) as string
    |> json_decode($$, true, 512, JSON_FB_HACK_ARRAYS)
    |> cast_to_tag_defs($$);

  $files = Vec\map_with_key($tags, ($name, $tag) ==> {
    $path = $build_dir.'/tags/'.$name[0].'/';
    if (!is_dir($path)) {
      mkdir($path, 0777, true);
    }
    $uses_interfaces =
      Str\contains(json_encode($tag) as string, 'SGMLStreamInterfaces');

    $codegen_file = $new_file($path.$name.'.hack');

    if ($namespace is nonnull) {
      $codegen_file->append('namespace '.$namespace.';');
    }

    $codegen_file->append(
      $uses_interfaces
        ? 'use namespace HTL\\{SGMLStream, SGMLStreamInterfaces};'
        : 'use namespace HTL\\SGMLStream;',
    );

    $codegen_file->append(
      "use type HTL\\Pragma\\Pragmas;\n\n<<file: Pragmas(vec['PhaLinters', 'digest:'])>>",
    );
    $codegen_file->newline();

    codegen_tag($codegen_file, $tag, $name);
    return $codegen_file;
  });

  $codegen_file = $new_file($build_dir.'/'.$base_class.'.hack');

  if ($namespace is nonnull) {
    $codegen_file->append('namespace '.$namespace.';');
  }

  $codegen_file->append(
    'use namespace HTL\\{SGMLStream, SGMLStreamInterfaces};',
  );

  $codegen_file->append(
    "use type HTL\\Pragma\\Pragmas;\n\n<<file: Pragmas(vec['PhaLinters', 'digest:'])>>",
  );
  $codegen_file->newline();

  $codegen_file->append(
    'abstract xhp class '.
    $base_class.
    " extends SGMLStream\\RootElement {\n".
    "  const ctx INITIALIZATION_CTX = [];\n",
  );

  $codegen_file->append(codegen_attributes($global_attributes));

  $codegen_file->append('}');

  $files[] = $codegen_file;

  await Vec\map_async($files, async $f ==> await $f->writeToDiskAsync());
}
