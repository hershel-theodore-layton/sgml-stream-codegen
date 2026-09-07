/** sgml-stream-codegen is MIT licensed, see /LICENSE. */
namespace HTL\SGMLStreamCodegen;

use type HTL\Pragma\Pragmas;

<<file: Pragmas(vec['PhaLinters', 'digest:570c026d3131e3adbf95'])>>

function cast_to_vec_of_string(mixed $htl_untyped_variable)[]: vec<string> {
  $out__1 = vec[];
  foreach (($htl_untyped_variable as vec<_>) as $v__1) {
    $out__1[] = $v__1 as string;
  }
  return $out__1;
}
