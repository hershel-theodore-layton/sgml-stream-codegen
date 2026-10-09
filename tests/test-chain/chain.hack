/** sgml-stream-codegen is MIT licensed, see /LICENSE. */
namespace HTL\Project_Yl8qGnLI9yiv\GeneratedTestChain;

use namespace HTL\TestChain;
use type HTL\Pragma\Pragmas;

<<file: Pragmas(vec['PhaLinters', 'digest:808dbf6fb947b37ad4d8'])>>

async function tests_async(
  TestChain\ChainController<\HTL\TestChain\Chain> $controller,
)[defaults]: Awaitable<TestChain\ChainController<\HTL\TestChain\Chain>> {
  return $controller
    ->addTestGroup(\HTL\SGMLStreamCodegen\doc_block_test<>)
    ->addTestGroup(\HTL\SGMLStreamCodegen\type_as_string_test<>);
}
