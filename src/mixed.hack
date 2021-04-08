/** sgml-stream-codegen is MIT licensed, see /LICENSE. */
namespace HTL\SGMLStreamCodegen;

/**
 * Erases the `_` type from untyped built-ins.
 */
function mixed(mixed $mixed): mixed {
  return $mixed;
}
