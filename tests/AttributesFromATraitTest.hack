/** sgml-stream-codegen is MIT licensed, see /LICENSE. */
namespace HTL\SGMLCodegen\Tests;

use type Facebook\HackTest\HackTest;
use function Facebook\FBExpect\expect;

final class AttributesFromATraitTest extends HackTest {
  public function test_attributes_from_a_trait(): void {
    $decl = InvisibleHerp::getAttributeDecl();
    expect($decl)->toContainKey('derp', 'Attribute from decl');
    expect($decl)->toNotContainKey('herp', 'From trait (invisible)');

    $ok = <InvisibleHerp herp="ok" />;
    expect($ok->:herp)->toEqual('ok', 'The typechecker has the attribute');
  }
}

abstract xhp class BaseClass {
  private dict<string, mixed> $attrs;
  final public function __construct(
    KeyedTraversable<string, mixed> $attributes,
    Traversable<?\XHPChild> $_children,
    dynamic ...$_debug_info
  ) {
    $this->attrs = dict($attributes);
  }

  protected static function __xhpAttributeDeclaration(
  ): darray<string, varray<mixed>> {
    return darray[];
  }

  final public function getAttribute(string $key): mixed {
    return $this->attrs[$key];
  }

  public static function getAttributeDecl(): darray<string, varray<mixed>> {
    return static::__xhpAttributeDeclaration();
  }
}

trait HasHerp {
  attribute string herp;
}

final xhp class InvisibleHerp extends BaseClass {
  use HasHerp;
  attribute string derp;
}
