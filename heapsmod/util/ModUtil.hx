package heapsmod.util;

import h2d.Tile;
import haxe.io.Path;
import haxe.Json;
import heapsmod.data.ModMetadata;
import hxd.res.Image;

/**
 * A utility class for mods.
 */
class ModUtil
{
    /**
     * Retrieves the metadata for a mod.
     * @param mod The mod folder name.
     * @param skipWarnings Whether warnings should be ignored.
     * @return Mod metadata.
     */
    public static function getMeta(mod:String, skipWarnings:Bool = false):ModMetadata
    {
        if (!HeapsMod.initialized) return null;

        var path:String = Path.join([mod, HeapsMod.config.metaFile]);
        var meta:ModMetadata = {};

        // Don't parse metadata if it doesn't exist
        if (!HeapsModFS.modFS.exists(path))
        {
            HeapsMod.error(WARNING, MOD_MISSING_META, 'Mod $mod is missing metadata');

            return null;
        }

        // Try and parse the mod metadata
        // If it fails to parse, output an error
        try
        {
            var json:Dynamic = Json.parse(HeapsModFS.modFS.get(path).getText());

            meta.title = JsonUtil.getString('title', json);
            meta.description = JsonUtil.getString('description', json);
            meta.version = JsonUtil.getInt('version', json);
            meta.apiVersion = JsonUtil.getInt('apiVersion', json);
            meta.dependencies = JsonUtil.getStringMap('dependencies', json);
            meta.id = JsonUtil.getString('id', json);

            #if hxscript
            meta.preprocessors = JsonUtil.getStringMap('preprocessors', json);
            #end

            meta.dir = mod;
        }
        catch (e)
        {
            HeapsMod.error(ERROR, MOD_META_PARSE_ERROR, 'Failed to parse metadata for mod $mod');

            return null;
        }
        
        // Give a warning if the mod's API version is incompatible
        if (!isCompatible(meta) && !skipWarnings) HeapsMod.error(WARNING, MOD_INCOMPATIBLE_VERSION, 'Mod $mod is incompatible with API version');

        return meta;
    }

    /**
     * Retrieves the icon for a mod.
     * @param mod The mod folder name.
     * @return The mod icon as a `Tile`.
     */
    public static function getIcon(mod:String):Tile
    {
        if (!HeapsMod.initialized) return null;

        var path:String = Path.join([mod, HeapsMod.config.iconFile]);
        var tile:Tile = try { new Image(HeapsModFS.modFS.get(path)).toTile(); } catch (e) null;

        if (tile == null) HeapsMod.error(WARNING, MOD_MISSING_ICON, 'Mod $mod lacks an icon');

        return tile;
    }

    /**
     * @return Whether `meta` is compatible with the current API version.
     */
    public static function isCompatible(meta:ModMetadata):Bool
    {
        if (!HeapsMod.initialized) return false;

        return meta != null && (HeapsMod.config.apiVersion == null || HeapsMod.config.apiVersion(meta.apiVersion));
    }
}