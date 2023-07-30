/** sgml-stream-codegen is MIT licensed, see /LICENSE. */
namespace HTL\SGMLStreamCodegen;

function cast_to_attr_defs(
  mixed $htl_untyped_variable,
)[]: dict<string, AttributeDefinition> {
  $out__0 = dict[];
  foreach (($htl_untyped_variable as dict<_, _>) as $k__1 => $v__2) {
    $out__0[$k__1 as string] = () ==> {
      $partial__3 = $v__2 as shape(
        ?'help' => string,
        'see' => string,
        'type' => string,
        ?'type_enum_values' => mixed,
      );
      if (Shapes::keyExists($partial__3, 'type_enum_values')) {
        $partial__3['type_enum_values'] = () ==> {
          $out__4 = vec[];
          foreach (($partial__3['type_enum_values'] as vec<_>) as $v__5) {
            $out__4[] = $v__5 as string;
          }
          return $out__4;
        }();
      } else {
        Shapes::removeKey(inout $partial__3, 'type_enum_values');
      }
      return $partial__3;
    }();
  }
  return $out__0;
}
