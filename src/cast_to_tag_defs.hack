/** sgml-stream-codegen is MIT licensed, see /LICENSE. */
namespace HTL\SGMLStreamCodegen;

use type HTL\Pragma\Pragmas;

<<file: Pragmas(vec['PhaLinters', 'digest:15bf82482f19dcc181a9'])>>

function cast_to_tag_defs(
  mixed $htl_untyped_variable,
)[]: dict<string, \HTL\SGMLStreamCodegen\TagDefinition> {
  $out__1 = dict[];
  foreach (($htl_untyped_variable as dict<_, _>) as $k__1 => $v__1) {
    $out__3 = $v__1 as shape(
      ?'help' => string,
      'attributes' => mixed,
      'base_class' => string,
      'interfaces' => mixed,
      'traits' => mixed,
      'see' => string,
      ...
    );
    $out__5 = dict[];
    foreach (($out__3['attributes'] as dict<_, _>) as $k__5 => $v__5) {
      $out__7 = $v__5 as shape(
        ?'help' => string,
        'see' => string,
        'type' => string,
        ?'type_enum_values' => mixed,
        ...
      );
      if (Shapes::keyExists($out__7, 'type_enum_values')) {
        $out__11 = vec[];
        foreach (($out__7['type_enum_values'] as vec<_>) as $v__11) {
          $out__11[] = $v__11 as string;
        }
        $out__7['type_enum_values'] = $out__11;
      } else {
        Shapes::removeKey(inout $out__7, 'type_enum_values');
      }
      $out__5[$k__5 as string] = $out__7;
    }
    $out__3['attributes'] = $out__5;
    $out__14 = vec[];
    foreach (($out__3['interfaces'] as vec<_>) as $v__14) {
      $out__14[] = $v__14 as string;
    }
    $out__3['interfaces'] = $out__14;
    $out__16 = vec[];
    foreach (($out__3['traits'] as vec<_>) as $v__16) {
      $out__16[] = $v__16 as string;
    }
    $out__3['traits'] = $out__16;
    $out__1[$k__1 as string] = $out__3;
  }
  return $out__1;
}
