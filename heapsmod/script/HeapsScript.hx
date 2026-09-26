package heapsmod.script;

#if hxscript
import hxd.Res;
import hxscript.error.Sink;
import hxscript.types.ScriptedClass;
import hxscript.Config;
import hxscript.Environment;

using Lambda;

/**
 * A script handler for HeapsMod.
 */
class HeapsScript
{
    /**
     * The environment where scripts are handled.
     */
    static var world(default, null):Environment;

    /**
     * Checks for any script files and loads them.
     * 
     * It'll only load scripts for mods that are enabled,
     * but can load any script outside the mod root directory.
     */
    public static function loadScripts()
    {
        if (!HeapsMod.initialized) return;

        clearScripts();

        world = new Environment();

        Sink.listen(e -> HeapsMod.error(ERROR, SCRIPT_ERROR, e.message));

        function loadPath(path:String)
        {
            for (file in Res.loader.dir(path))
            {
                if (file.entry.isDirectory)
                {
                    loadPath(file.entry.path);

                    continue;
                }

                if (!HeapsMod.config.scriptExts.contains(file.entry.extension)) continue;

                world.addModule(new HeapsModule(file.entry));
            }
        }

        loadPath('');

        world.start();
    }

    /**
     * Retrieves a list of scripted classes that extend `base`.
     * @param base The class to check for.
     * @return An array of scripted classes.
     */
    public static function listClasses(?base:Class<Dynamic>):Array<ScriptedClass>
    {
        if (!HeapsMod.initialized || world == null) return [];

        var result:Array<ScriptedClass> = [];

        for (module in world.modules)
        {
            for (type in module.types)
            {
                if (type is ScriptedClass)
                {
                    var cls:ScriptedClass = cast type;
                    var native:Dynamic = try { cls.instanceClass; } catch (e) null;

                    while (native != null)
                    {
                        native = Type.getSuperClass(native);

                        if (native == null || native == base) break;
                    }

                    if (native != base) continue;

                    result.push(cls);
                }
            }
        }

        return result;
    }

    /**
     * Creates an instance of a scripted class.
     * @param cls The scripted class.
     * @param args Constructor arguments.
     * @return The scripted class instance.
     */
    public static function initClass(cls:ScriptedClass, args:Array<Dynamic>):Dynamic
    {
        if (!HeapsMod.initialized || cls == null) return null;

        return try { cls.typeCreateInstance(args); } catch (e)
        {
            HeapsMod.error(ERROR, SCRIPT_ERROR, e.message);

            null;
        }
    }

    /**
     * Like `initClass`, but instead creates a scripted class instance from its name.
     * @param name The name of the scripted class.
     */
    public static function initClassByName(name:String, args:Array<Dynamic>):Dynamic
    {
        return initClass(listClasses().find(cls -> return cls.name == name), args);
    }

    /**
     * Imports a class that can be used globally throughout scripts.
     * @param path The class path to import.
     * @param alias An optional alias for the imported class.
     */
    public static function setGlobalImport(path:String, ?alias:String)
    {
        if (!HeapsMod.initialized) return;

        alias ??= path.substr(path.lastIndexOf('.') + 1);

        Config.globalImports.set(path, IAsName(alias));
    }

    /**
     * Removes a global import.
     * @param path The class path to remove.
     */
    public static function removeGlobalImport(path:String)
    {
        if (!HeapsMod.initialized) return;

        Config.globalImports.remove(path);
    }

    /**
     * Sets a variable that can be used globally throughout scripts.
     * @param name The name of the variable.
     * @param value The variable's value.
     */
    public static function setGlobalVariable(name:String, value:Dynamic)
    {
        if (!HeapsMod.initialized) return;

        Config.globalVariables.set(name, value);
    }

    /**
     * Removes a global variable.
     * @param name The name of the variable.
     */
    public static function removeGlobalVariable(name:String)
    {
        if (!HeapsMod.initialized) return;

        Config.globalVariables.remove(name);
    }

    /**
     * Sets a preprocessor that can be used in scripts. Ex. `#if name`.
     * @param name The name of the preprocessor.
     * @param value A value for the preprocessor.
     */
    public static function setPreprocessor(name:String, value:String)
    {
        if (!HeapsMod.initialized) return;
        
        Config.preprocessorValues.set(name, value);
    }

    /**
     * Removes a preprocessor.
     * @param name The name of the preprocessor.
     */
    public static function removePreprocessor(name:String)
    {
        if (!HeapsMod.initialized) return;

        Config.preprocessorValues.remove(name);
    }

    /**
     * Prevents a class from being used in scripts.
     * @param path The class path to blacklist.
     */
    public static function blacklistClass(path:String)
    {
        if (!HeapsMod.initialized) return;

        Config.blacklist.get(ByModule).push(path);
    }

    /**
     * Like `blacklistClass`, but instead blacklists an entire package.
     * @param path The package to blacklist.
     * @param recursive Whether to blacklist sub-packages.
     */
    public static function blacklistPackage(path:String, recursive:Bool = true)
    {
        if (!HeapsMod.initialized) return;

        Config.blacklist.get(ByPackage(recursive)).push(path);
    }

    /**
     * Clears all loaded scripts.
     */
    public static function clearScripts()
    {
        world = null;

        Sink.onDiagnostic = [];
    }
}
#end