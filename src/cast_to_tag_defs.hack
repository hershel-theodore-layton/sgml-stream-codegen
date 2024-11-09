/** sgml-stream-codegen is MIT licensed, see /LICENSE. */
namespace HTL\SGMLStreamCodegen;

function cast_to_tag_defs(
  mixed $htl_untyped_variable,
)[]: dict<string, \HTL\SGMLStreamCodegen\TagDefinition> {
  $out__1 = dict[];
  foreach (($htl_untyped_variable as dict<_, _>) as $k__1 => $v__1) {
    $out__3 = $v__1 as shape(
      'attributes' => mixed,
      'base_class' => string,
      'interfaces' => mixed,
      'traits' => mixed,
      'see' => string,
      ...
    );
    $out__4 = dict[];
    foreach (($out__3['attributes'] as dict<_, _>) as $k__4 => $v__4) {
      $out__6 = $v__4 as shape(
        ?'help' => string,
        'see' => string,
        'type' => string,
        ?'type_enum_values' => mixed,
        ...
      );
      if (Shapes::keyExists($out__6, 'type_enum_values')) {
        $out__10 = vec[];
        foreach (($out__6['type_enum_values'] as vec<_>) as $v__10) {
          $out__10[] = $v__10 as string;
        }
        $out__6['type_enum_values'] = $out__10;
      } else {
        Shapes::removeKey(inout $out__6, 'type_enum_values');
      }
      $out__4[$k__4 as string] = $out__6;
    }
    $out__3['attributes'] = $out__4;
    $out__13 = vec[];
    foreach (($out__3['interfaces'] as vec<_>) as $v__13) {
      $out__13[] = $v__13 as string;
    }
    $out__3['interfaces'] = $out__13;
    $out__15 = vec[];
    foreach (($out__3['traits'] as vec<_>) as $v__15) {
      $out__15[] = $v__15 as string;
    }
    $out__3['traits'] = $out__15;
    $out__1[$k__1 as string] = $out__3;
  }
  return $out__1;
}
