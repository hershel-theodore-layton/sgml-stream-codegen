/** sgml-stream-codegen is MIT licensed, see /LICENSE. */
namespace HTL\SGMLStreamCodegen;

use namespace HH;
use namespace HH\Lib\{File, Str};
use namespace HTL\TypeVisitor;
use function HTL\StaticTypeAssertionCodegen\{
  emit_body_for_assertion_function,
  from_type,
};

<<__EntryPoint>>
async function generate_type_asserters_async()[defaults]: Awaitable<void> {
  $autoloader = __DIR__.'/../vendor/autoload.hack';
  if (HH\could_include($autoloader)) {
    require_once $autoloader;
    HH\dynamic_fun('Facebook\AutoloadMap\initialize')();
  }

  await write_file_async<dict<string, AttributeDefinition>>(
    'cast_to_attr_defs',
  );
  await write_file_async<dict<string, TagDefinition>>('cast_to_tag_defs');
  await write_file_async<vec<string>>('cast_to_vec_of_string');
}

async function write_file_async<reify T>(
  string $file_name,
)[defaults]: Awaitable<void> {
  $code = emit_body_for_assertion_function(from_type<T>(dict[], ($err)[] ==> {
    throw new \RuntimeException($err);
  }));

  $type_name = TypeVisitor\visit<T, _, _>(new TypeVisitor\TypenameVisitor());
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
