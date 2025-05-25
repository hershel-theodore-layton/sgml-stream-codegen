/** sgml-stream-codegen is MIT licensed, see /LICENSE. */
namespace HTL\SGMLStreamCodegen;

use namespace HH\Lib\File;
use namespace HTL\HH4Shim;

/**
 * $file->truncate() is not available in hhvm 4.128.
 * Reimplement this based on the PHP apis of your.
 * @see https://github.com/hershel-theodore-layton/portable-hack-ast/blob/7453f1d6b9ae902994a84dab69762fd737abcb8a/bin/gen/ftruncate.hack
 */
function ftruncate(File\Handle $file, int $size)[defaults]: void {
  // Even more legacy baggage.
  // $file->getPath() used to return a path object.
  // This gets the string path on any version of hhvm.
  $path = (): string ==> {
    $path_as_object_or_string = HH4Shim\to_mixed($file->getPath());

    if ($path_as_object_or_string is string) {
      return $path_as_object_or_string;
    }

    return new \ReflectionObject($path_as_object_or_string)
      |> $$->getMethod('toString')
      ->invoke($path_as_object_or_string) as string;
  }();

  \fopen($path, 'r+') |> \ftruncate($$, $size);
}
