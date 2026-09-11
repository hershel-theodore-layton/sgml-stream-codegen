/** sgml-stream-codegen is MIT licensed, see /LICENSE. */
namespace HTL\SGMLStreamCodegen;

use namespace HH;
use namespace HH\Lib\{File, Str};
use namespace HTL\TypeVisitor;
use type HTL\Pragma\Pragmas;
use type RuntimeException;
use function HTL\PhaLintersServer\hackfmt_and_sign_hack_source_do_not_use_async;
use function HTL\StaticTypeAssertionCodegen\{
  emit_body_for_assertion_function,
  from_type,
};

<<file: Pragmas(vec['PhaLinters', 'fixme:autoload_your_code'])>>

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
    throw new RuntimeException($err);
  }));

  $type_name = TypeVisitor\visit<T, _, _>(new TypeVisitor\TypenameVisitor());
  $path = __DIR__.'/../src/'.$file_name.'.hack';
  $source = Str\format(
    <<<'code'
/** sgml-stream-codegen is MIT licensed, see /LICENSE. */
namespace HTL\SGMLStreamCodegen;

use type HTL\Pragma\Pragmas;

<<file: Pragmas(vec['PhaLinters', 'digest:'])>>

function %s(mixed $htl_untyped_variable)[]: %s {
  %s
}

code
    ,
    $file_name,
    $type_name,
    $code,
  );
  $signed = await hackfmt_and_sign_hack_source_do_not_use_async($source);
  $file = File\open_write_only($path, File\WriteMode::TRUNCATE);
  using $file->closeWhenDisposed();
  using $file->tryLockx(File\LockType::EXCLUSIVE);
  await $file->writeAllAsync($signed);
}
