package heapsmod.mod;

import h2d.Tile;
import heapsmod.data.ModMetadata;
import heapsmod.util.ModUtil;

#if hxscript
import heapsmod.script.HeapsScript;
#end

using StringTools;

/**
 * A class that's loaded when enabling mods through HeapsMod.
 */
class Mod
{
    /**
     * The mod's metadata.
     */
    public final meta:ModMetadata;

    /**
     * The mod's directory name.
     */
    public var dir(get, never):String;

    /**
     * The mod's id.
     */
    public var id(get, never):String;

    /**
     * The current version of the mod.
     */
    public var version(get, never):Int;

    #if hxscript
    /**
     * A preprocessor for the mod to be used in scripts. Ex. `#if mod`.
     */
    public var preprocessor(get, never):String;

    /**
     * Whether the mod has a preprocessor or not.
     */
    public var hasPreprocessor(get, never):Bool;
    #end

    /**
     * A unique filesystem for the mod.
     */
    public var fs(default, null):ModFS;

    public function new(meta:ModMetadata)
    {
        this.meta = meta;

        HeapsModFS.instance.fs.insert(0, fs = new ModFS(this));

        #if hxscript
        if (!HeapsMod.config.modPreprocessors) return;
        
        for (name => value in meta.preprocessors) HeapsScript.setPreprocessor(name, value);

        if (hasPreprocessor) HeapsScript.setPreprocessor(preprocessor, Std.string(version));
        #end
    }

    /**
     * Retrieves the mod's icon image.
     * @return The icon as a `Tile`.
     */
    public function getIcon():Tile
    {
        return ModUtil.getIcon(dir);
    }

    /**
     * Clears the mod filesystem cache.
     */
    public function clearCache()
    {
        fs.clearCache();
    }

    /**
     * Disposes the mod and its filesystem.
     */
    public function dispose()
    {
        HeapsModFS.instance.fs.remove(fs);

        fs.dispose();

        #if hxscript
        if (!HeapsMod.config.modPreprocessors) return;

        for (name => value in meta.preprocessors) HeapsScript.removePreprocessor(name);

        if (hasPreprocessor) HeapsScript.removePreprocessor(preprocessor);
        #end
    }

    public function toString():String
    {
        return dir;
    }

    @:noCompletion
    inline function get_dir():String
    {
        return meta.dir;
    }

    @:noCompletion
    inline function get_id():String
    {
        return meta.id ?? '';
    }

    @:noCompletion
    inline function get_version():Int
    {
        return meta.version;
    }

    #if hxscript
    @:noCompletion
    function get_preprocessor():String
    {
        return ~/[^A-Za-z0-9_]/g.replace(id, '_');
    }

    @:noCompletion
    function get_hasPreprocessor():Bool
    {
        return id.trim() != '';
    }
    #end
}