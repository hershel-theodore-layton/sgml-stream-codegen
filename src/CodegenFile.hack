/** sgml-stream-codegen is MIT licensed, see /LICENSE. */
namespace HTL\SGMLStreamCodegen;

use namespace HH\Lib\{File, Str};

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

  public async function writeToDiskAsync(): Awaitable<void> {
    await $this->writeToDiskFormattedAsync();
    await $this->addXhpClassModifierAndDemangleAsync();
  }

  private async function writeToDiskFormattedAsync(): Awaitable<void> {
    $file = File\open_write_only($this->path, File\WriteMode::TRUNCATE);
    using $file->closeWhenDisposed();
    using $file->tryLockx(File\LockType::EXCLUSIVE);
    await $file->writeAllAsync($this->toString());
    \shell_exec('hackfmt -i '.\escapeshellarg($this->path));
  }

  private async function addXhpClassModifierAndDemangleAsync(
  ): Awaitable<void> {
    $file = File\open_read_write($this->path);
    using $file->closeWhenDisposed();
    using $file->tryLockx(File\LockType::EXCLUSIVE);
    $code = await $file->readAllAsync();
    $file->truncate(0);
    $file->seek(0);
    await $file->writeAllAsync(
      Str\replace($code, 'class _MANGLED_', 'xhp class '),
    );
  }
}
