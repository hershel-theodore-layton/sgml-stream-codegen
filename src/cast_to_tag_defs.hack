/** sgml-stream-codegen is MIT licensed, see /LICENSE. */
namespace HTL\SGMLStreamCodegen;

function cast_to_tag_defs(
  mixed $htl_untyped_variable,
)[]: dict<string, TagDefinition> {
  $out__0 = dict[];
  foreach (($htl_untyped_variable as dict<_, _>) as $k__1 => $v__2) {
    $out__0[$k__1 as string] = () ==> {
      $partial__3 = $v__2 as shape(
        'attributes' => mixed,
        'base_class' => string,
        'interfaces' => mixed,
        'traits' => mixed,
        'see' => string,
      );
      $partial__3['attributes'] = () ==> {
        $out__4 = dict[];
        foreach (($partial__3['attributes'] as dict<_, _>) as $k__5 => $v__6) {
          $out__4[$k__5 as string] = () ==> {
            $partial__7 = $v__6 as shape(
              ?'help' => string,
              'see' => string,
              'type' => string,
              ?'type_enum_values' => mixed,
            );
            if (Shapes::keyExists($partial__7, 'type_enum_values')) {
              $partial__7['type_enum_values'] = () ==> {
                $out__8 = vec[];
                foreach (($partial__7['type_enum_values'] as vec<_>) as $v__9) {
                  $out__8[] = $v__9 as string;
                }
                return $out__8;
              }();
            } else {
              Shapes::removeKey(inout $partial__7, 'type_enum_values');
            }
            return $partial__7;
          }();
        }
        return $out__4;
      }();
      $partial__3['interfaces'] = () ==> {
        $out__10 = vec[];
        foreach (($partial__3['interfaces'] as vec<_>) as $v__11) {
          $out__10[] = $v__11 as string;
        }
        return $out__10;
      }();
      $partial__3['traits'] = () ==> {
        $out__12 = vec[];
        foreach (($partial__3['traits'] as vec<_>) as $v__13) {
          $out__12[] = $v__13 as string;
        }
        return $out__12;
      }();
      return $partial__3;
    }();
  }
  return $out__0;
}
