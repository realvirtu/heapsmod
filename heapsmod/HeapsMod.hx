package heapsmod;

import heapsmod.data.ConfigData;
import heapsmod.data.ModData;
import heapsmod.mod.util.DependencyUtil;
import heapsmod.mod.util.ModUtil;
import heapsmod.mod.Mod;
import heapsmod.HeapsModError;
import hxd.res.Loader;
import hxd.Res;

#if hxscript
import heapsmod.script.HeapsScript;
#end

using Lambda;

/**
 * A class for implementing a modding system.
 */
class HeapsMod
{
    /**
     * The default directory where mods are stored.
     */
    static final DEFAULT_MOD_ROOT:String = 'mods';

    /**
     * The default file name for mod metadata.
     */
    static final DEFAULT_META_FILE:String = 'meta.json';

    /**
     * The default file name for mod icons.
     */
    static final DEFAULT_ICON_FILE:String = 'icon.png';

    /**
     * An array of default file paths to exclude from mod filesystems.
     */
    static final DEFAULT_EXCLUDES:Array<String> = ['.vscode', '.git'];
    
    #if hxscript
    /**
     * An array of default file extensions to use for checking scripts.
     */
    static final DEFAULT_SCRIPT_EXTS:Array<String> = ['hxc'];
    #end

    /**
     * Whether HeapsMod had been initialized or not.
     */
    public static var initialized(default, null):Bool;

    /**
     * Configuration data for HeapsMod.
     */
    public static var config(default, null):ConfigData;

    static var onError(default, null):HeapsModError->Void;
    static var mods(default, null):Array<Mod>;

    /**
     * Initializes the HeapsMod modding system.
     * @param config Configuration data.
     */
    public static function init(?config:ConfigData)
    {
        if (initialized) return;

        initialized = true;

        // Loads the config
        config ??= {};
        config.modRoot ??= DEFAULT_MOD_ROOT;
        config.metaFile ??= DEFAULT_META_FILE;
        config.iconFile ??= DEFAULT_ICON_FILE;
        config.skipDependencies ??= false;
        config.skipDependencyErrors ??= false;
        config.exclude ??= DEFAULT_EXCLUDES;
        config.compat ??= [];
        config.mods ??= [];

        #if hxscript
        config.scriptExts ??= DEFAULT_SCRIPT_EXTS;
        #end

        onError = config.onError;
        mods = [];

        HeapsMod.config = config;

        // Loads a new resource loader
        Res.loader = new Loader(new HeapsModFS(Res.loader.fs));

        error(INFO, HEAPSMOD_INITIALIZED, 'HeapsMod initialized');

        enableMods(config.mods);
    }

    /**
     * Enables a mod.
     * @param mod The mod folder to enable.
     */
    public static function enableMod(mod:String)
    {
        enableMods([mod]);
    }

    /**
     * Disables a mod.
     * @param mod The mod folder to disable.
     */
    public static function disableMod(mod:String)
    {
        disableMods([mod]);
    }

    /**
     * Like `enableMod`, but instead loads multiple mods.
     * @param mods The mod folders to enable.
     */
    public static function enableMods(mods:Array<String>)
    {
        if (!initialized) return;
        
        for (mod in mods)
        {
            var meta:ModData = ModUtil.getMeta(mod);

            if (!ModUtil.isCompatible(meta)) continue;

            // Missing dependency check
            var missing:Array<String> = DependencyUtil.getMissingDependencies(meta);

            if (missing.length > 0 && !config.skipDependencies)
            {
                var skipErrors:Bool = config.skipDependencyErrors;

                error(skipErrors ? WARNING : ERROR, MOD_MISSING_DEPENDENCIES, 'Mod $mod has missing dependencies: $missing');

                if (!skipErrors) continue;
            }

            if (hasEnabledMod(mod)) continue;

            HeapsMod.mods.push(new Mod(meta));

            error(INFO, MOD_ENABLED, 'Enabled mod $mod');
        }

        #if hxscript
        HeapsScript.loadScripts();
        #end
    }

    /**
     * Like `disableMod`, but instead disables multiple mods.
     * @param mods The mod folders to disable.
     */
    public static function disableMods(mods:Array<String>)
    {
        if (!initialized) return;

        for (mod in mods)
        {
            var mod:Mod = getEnabledMod(mod);
            mod.dispose();

            HeapsMod.mods.remove(mod);

            error(INFO, MOD_DISABLED, 'Disabled mod $mod');
        }

        enableMods(getEnabledMods().map(mod -> return mod.mod));
    }

    /**
     * Scans the mod root for mod metadata.
     * @return An array of mod metadata.
     */
    public static function scan():Array<ModData>
    {
        if (!initialized) return [];

        var result:Array<ModData> = [];

        for (mod in HeapsModFS.modFS.dir(''))
        {
            var meta:ModData = ModUtil.getMeta(mod.name, true);

            if (meta == null) continue;
            
            result.push(meta);
        }

        return DependencyUtil.sortByDependencies(result);
    }

    /**
     * @return A list of all currently enabled mods.
     */
    public static function getEnabledMods():Array<Mod>
    {
        if (!initialized) return [];

        return mods.copy();
    }

    /**
     * Gets the instance of a specific mod that's enabled.
     * @param id The mod id.
     * @return The mod instance.
     */
    public static function getEnabledMod(id:String):Mod
    {
        if (!initialized) return null;

        return getEnabledMods().find(m -> return m.mod == id || m.id == id);
    }

    /**
     * Retrives the version of an enabled mod.
     * @param id The mod id.
     * @return The mod version.
     */
    public static function getEnabledModVersion(id:String):Null<Int>
    {
        if (!initialized) return null;

        return getEnabledMod(id)?.version;
    }

    /**
     * Whether a mod is enabled or not.
     * @param id The mod id.
     */
    public static function hasEnabledMod(id:String):Bool
    {
        if (!initialized) return false;

        return getEnabledMod(id) != null;
    }

    /**
     * Fully disables the HeapsMod modding system.
     */
    public static function disable()
    {
        if (!initialized) return;

        error(INFO, HEAPSMOD_DISABLED, 'HeapsMod disabled');

        #if hxscript
        HeapsScript.clearScripts();
        #end
        
        HeapsModFS.instance.dispose();
        
        config = null;
        onError = null;
        mods = null;

        initialized = false;
    }

    /**
     * Runs the `onError` callback.
     * @param code The error code (INFO, WARNING, ERROR).
     * @param type The type of error it is.
     * @param message A message for giving the error details.
     */
    public static function error(code:ErrorCode, type:ErrorType, message:String)
    {
        if (onError != null) onError(HeapsModError.get(code, type, message));
    }

    /**
     * Clears the cache of every mod filesystem + the HeapsMod filesystem.
     */
    public static function clearCache()
    {
        if (!initialized) return;

        for (mod in mods)
            mod.clearCache();

        HeapsModFS.modFS.clearCache();
    }
}