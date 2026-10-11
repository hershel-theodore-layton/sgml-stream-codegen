/** sgml-stream-codegen is MIT licensed, see /LICENSE. */
namespace HTL\SGMLStreamCodegen;

use namespace HH\Lib\Str;
use namespace HTL\HackCompiler;

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
    await HackCompiler\write_source_async($this->toString(), $this->path);
  }
}
