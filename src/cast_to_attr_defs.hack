/** sgml-stream-codegen is MIT licensed, see /LICENSE. */
namespace HTL\SGMLStreamCodegen;

function cast_to_attr_defs(
  mixed $htl_untyped_variable,
)[]: dict<string, \HTL\SGMLStreamCodegen\AttributeDefinition> {
  $out__1 = dict[];
  foreach (($htl_untyped_variable as dict<_, _>) as $k__1 => $v__1) {
    $out__3 = $v__1 as shape(
      ?'help' => string,
      'see' => string,
      'type' => string,
      ?'type_enum_values' => mixed,
      ...
    );
    if (Shapes::keyExists($out__3, 'type_enum_values')) {
      $out__7 = vec[];
      foreach (($out__3['type_enum_values'] as vec<_>) as $v__7) {
        $out__7[] = $v__7 as string;
      }
      $out__3['type_enum_values'] = $out__7;
    } else {
      Shapes::removeKey(inout $out__3, 'type_enum_values');
    }
    $out__1[$k__1 as string] = $out__3;
  }
  return $out__1;
}
