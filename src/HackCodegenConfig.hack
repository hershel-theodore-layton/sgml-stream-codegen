/** sgml-stream-codegen is MIT licensed, see /LICENSE. */
namespace HTL\SGMLStreamCodegen;

use namespace Facebook\HackCodegen;

final class HackCodegenConfig implements HackCodegen\IHackCodegenConfig {
  const type TConstructorArgument = shape(
    ?'file_header' => ?vec<string>,
    ?'formatter' => ?HackCodegen\ICodegenFormatter,
    ?'max_line_length' => ?int,
    ?'root_dir' => ?string,
    ?'spaces_per_indent' => ?int,
    ?'should_use_tabs' => ?bool,
  );

  public function __construct(
    private this::TConstructorArgument $constructorArgument,
  ) {}

  public function getFileHeader(): ?vec<string> {
    return $this->constructorArgument['file_header'] ?? null;
  }

  public function getFormatter(): ?HackCodegen\ICodegenFormatter {
    return $this->constructorArgument['formatter'] ?? null;
  }

  public function getMaxLineLength(): int {
    return $this->constructorArgument['max_line_length'] ?? 80;
  }

  public function getRootDir(): string {
    return $this->constructorArgument['root_dir'] ?? __DIR__;
  }

  public function getSpacesPerIndentation(): int {
    return $this->constructorArgument['spaces_per_indent'] ?? 2;
  }

  public function shouldUseTabs(): bool {
    return $this->constructorArgument['should_use_tabs'] ?? false;
  }
}
