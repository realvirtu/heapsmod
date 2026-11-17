# HeapsMod

HeapsMod is a modding framework designed specifically for the [Heaps](https://heaps.io) game engine.

## Installation

- Run `haxelib git heapsmod https://github.com/realvirtu/heapsmod`.
- Add `-lib heapsmod` to your hxml.

## Usage

```haxe
import heapsmod.HeapsMod;

HeapsMod.init();

// Enable mods
HeapsMod.enableMod("testmod");
HeapsMod.enableMod("testmod2");
HeapsMod.enableMod("testmod3");

// Same as above, but safer as dependency checks are done
for (meta in HeapsMod.scan())
{
    HeapsMod.enableMod(meta.dir);
}
```

### Mod Structure

Mods are stored in a directory named `mods`. HeapsMod doesn't automatically create this directory.

Mods require a `meta.json` file for HeapsMod to load it. Mod metadata is structured like this:

```json
{
    "title": "My Mod",
    "description": "My description",
    "id": "mymod",
    "version": 1,
    "apiVersion": 1,
    "dependencies": {
        "modid": 1
    }
}
```

Mods can also have an `icon.png` file. However, mod icons are completely optional and are not required for mods to be loaded.

## Scripting (Optional)

HeapsMod allows for scripting through `hxscript`, a haxelib for interpreting Haxe code at runtime. If you don't want mods to have script support, you can completely ignore this as HeapsMod doesn't require it.

### Installation

- Run `haxelib install hxscript`.
- Add `-lib hxscript` to your hxml.

### Usage

```haxe
import heapsmod.script.HeapsScript;

// Should be done before loading mods

HeapsScript.setGlobalImport("package.Class");

HeapsScript.blacklistClass("bad.package.DangerousClass");
HeapsScript.blacklistPackage("bad.package");

// Should be done after loading mods

// Outputs all scripted classes
trace(HeapsScript.listClasses());

// Outputs all scripted classes that extend DummyClass
trace(HeapsScript.listClasses(DummyClass));
```

### Scripted Classes

For classes to be extendable by scripted classes, they require a scripted version as done below. Although needed, scripted classes can still extend the original class.

```haxe
class ScriptedDummyClass extends DummyClass implements hxscript.IScripted {}
```