/** sgml-stream-codegen is MIT licensed, see /LICENSE. */
namespace HTL\SGMLStreamCodegen;

use namespace HH\Lib\{File, Str};
use function HTL\PhaLintersServer\hackfmt_and_sign_hack_source_do_not_use_async;

final class CodegenFile {
  private string $buffer = '';

  public function __construct(private string $path)[] {}

  public function getPath()[]: string {
    return $this->path;
  }

  public function append(string $str)[write_props]: void {
    if ($str !== '') {
      $this->buffer .= Str\trim_right($str)."\n";
    }
  }

  public function newline()[write_props]: void {
    $this->buffer .= "\n";
  }

  public function toString()[]: string {
    return $this->buffer;
  }

  public async function writeToDiskAsync()[defaults]: Awaitable<void> {
    $code = Str\replace($this->toString(), 'class _MANGLED_', 'xhp class ');
    $signed = await hackfmt_and_sign_hack_source_do_not_use_async($code);
    $file = File\open_write_only($this->path, File\WriteMode::TRUNCATE);
    using $file->closeWhenDisposed();
    using $file->tryLockx(File\LockType::EXCLUSIVE);
    await $file->writeAllAsync($signed);
  }
}
