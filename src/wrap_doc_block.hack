/** sgml-stream-codegen is MIT licensed, see /LICENSE. */
namespace HTL\SGMLStreamCodegen;

use namespace HH\Lib\{Str, Vec};

function wrap_doc_block(?string $contents)[]: string {
  if ($contents is null) {
    return '';
  }

  $words = Str\split($contents, ' ');

  $output = vec[];
  $current = vec[];
  $current_length = 0;
  $max_length = 82;

  foreach ($words as $word) {
    $length = Str\length($word);

    if ($length + $current_length > $max_length) {
      $output[] = $current;
      $current_length = 0;
      $current = vec[];
    }

    $current[] = $word;
    $current_length += $length + 1;
  }

  $output[] = $current;

  return Vec\map($output, $str ==> ' * '.Str\join($str, ' '))
    |> Str\join($$, "\n")."\n";
}
