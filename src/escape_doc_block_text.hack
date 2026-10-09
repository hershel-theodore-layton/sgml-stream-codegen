/** sgml-stream-codegen is MIT licensed, see /LICENSE. */
namespace HTL\SGMLStreamCodegen;

use namespace HH\Lib\Str;

function escape_doc_block_text(string $text)[]: string {
  return Str\replace_every(
    $text,
    dict["\r\n" => ' ', "\r" => ' ', "\n" => ' ', '*/' => '* /'],
  );
}
