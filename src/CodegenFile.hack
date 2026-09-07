/** sgml-stream-codegen is MIT licensed, see /LICENSE. */
namespace HTL\SGMLStreamCodegen;

use namespace HH\Lib\{File, Str};
use function escapeshellarg, exec, shell_exec;

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
    await $this->writeToDiskFormattedAsync();
    await $this->addXhpClassModifierAndDemangleAsync();
    $output = vec[];
    $status = 0;
    exec(
      escapeshellarg(
        __DIR__.
        '/../vendor/hershel-theodore-layton/portable-hack-ast-linters-server/bin/pha-sign-hack-source.sh',
      ).
      ' '.
      escapeshellarg($this->path),
      inout $output,
      inout $status,
    );
    invariant($status === 0, 'Could not sign generated HTML class');
  }

  private async function writeToDiskFormattedAsync(
  )[defaults]: Awaitable<void> {
    $file = File\open_write_only($this->path, File\WriteMode::TRUNCATE);
    using $file->closeWhenDisposed();
    using $file->tryLockx(File\LockType::EXCLUSIVE);
    await $file->writeAllAsync($this->toString());
    shell_exec('hackfmt -i '.escapeshellarg($this->path));
  }

  private async function addXhpClassModifierAndDemangleAsync(
  )[defaults]: Awaitable<void> {
    $file = File\open_read_write($this->path);
    using $file->closeWhenDisposed();
    using $file->tryLockx(File\LockType::EXCLUSIVE);
    $code = await $file->readAllAsync();
    $file->truncate();
    $file->seek(0);
    $code = Str\replace($code, 'class _MANGLED_', 'xhp class ');
    await $file->writeAllAsync($code);
  }
}
