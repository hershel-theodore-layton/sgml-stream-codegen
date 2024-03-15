/** sgml-stream-codegen is MIT licensed, see /LICENSE. */
namespace HTL\SGMLStreamCodegen;

use namespace HH\Lib\{File, Str};
use function HTL\StaticTypeAssertionCodegen\{
  emit_body_for_assertion_function,
  from_type,
};

<<__EntryPoint>>
async function generate_type_asserters_async(): Awaitable<void> {
  require_once __DIR__.'/../vendor/autoload.hack';
  \Facebook\AutoloadMap\initialize();

  await write_file_async<dict<string, AttributeDefinition>>(
    'cast_to_attr_defs',
    'dict<string, AttributeDefinition>',
  );
  await write_file_async<dict<string, TagDefinition>>(
    'cast_to_tag_defs',
    'dict<string, TagDefinition>',
  );
  await write_file_async<vec<string>>('cast_to_vec_of_string', 'vec<string>');
}

async function write_file_async<reify T>(
  string $file_name,
  string $type_name,
): Awaitable<void> {
  $code = emit_body_for_assertion_function(from_type<T>(dict[], ($err)[] ==> {
    throw new \RuntimeException($err);
  }));

  $path = __DIR__.'/../src/'.$file_name.'.hack';
  $file = File\open_write_only($path, File\WriteMode::TRUNCATE);
  using $file->closeWhenDisposed();
  using $file->tryLockx(File\LockType::EXCLUSIVE);

  // hackfmt-ignore
  await $file->writeAllAsync(Str\format(<<<'code'
/** sgml-stream-codegen is MIT licensed, see /LICENSE. */
namespace HTL\SGMLStreamCodegen;

function %s(mixed $htl_untyped_variable)[]: %s {
  %s
}

code
    ,
    $file_name,
    $type_name,
    $code,
  ));

  \shell_exec('hackfmt -i '.\escapeshellarg($path));
}
