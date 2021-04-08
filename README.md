# sgml-stream

Build your own custom native sgml-stream tags from a json definition

## What this code is

This code powers the codegen for html-stream-(non)-namespaced. Those packages are all you need if you wish to use a vanilla, pure to the spec, xhp implementation. If you wish to add some things of your own, you can use this code to adapt your version of html-stream to your needs. This codebase is not a library. We don't intend make this a composer package. If you wish to use this code, use `git clone`.

## Why would you want your own html tags?

When migrating some html-as-strings-code to xhp, you'll realize that xhp does not permit bogus attributes. You may depend on these bogus attributes, because some frontend code does something with that attribute. `<button refusedoubleclick>Submit</button>` would be such a use case. When using the default html-stream (or xhp-lib) classes, this code won't typecheck. If using a `data-` attribute is not feasible, you could add `refusedoubleclick` to your definition of `button`.

When migrating from xhp-lib to sgml-stream, you'll realize that `->getFirstChildOfType<T>()` and friends are not provided by sgml-stream. If you want to (re)add these methods, you can add them via a trait or with a base class.

Maybe you have some amazing idea for xhp. If you want to experiment, add it to your own custom version. We are not likely to accept your custom changes if this adds a feature. Html-stream is meant as a reference implementation. If you want to share your ideas with the world, publish your codegen changes on github and add your repository to this list. _The repositories linked below are NOT endorsed nor checked by the contributors. The code linked below may be malicious, broken, removed, etc. We are not responsible for the code linked below._

 * [Example](https://example.com/some/repository?remove-when-adding-the-first-repository) (short description here)

## How to build your own custom version

That depends on what kind of change you want to make. Do you want to add, change or remove an: attribute, base class, comment, interface, or trait? I'd recommend writing a script which takes the `global_attributes.json` or `tags.json` file and transforms it. Use this new file when emitting codegen. When a new version of these files is released, you can regenerate your custom version of our new base. You can check out the [Makefile](./Makefile) see what arguments to pass to `bin/generate.hack`.

If you want to do something else, change the codegen code manually. You can do anything you want, but this comes with a merge burden*. If we change the codegen code and you want to use our new code, you'll have to merge it using git.

\* The merge burden is yours to bare and we will not refrain from refactoring / making changes to support this use case. 

## Versioning

The versioning of this code follows html-stream. So html-stream v0.5.3 came from sgml-stream-codegen v0.5.3. **This code does not follow semver conventions!**
