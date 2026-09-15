package heapsmod.mod.util;

import h2d.Tile;
import haxe.io.Path;
import haxe.Json;
import heapsmod.data.ModData;
import hxd.res.Image;

class ModUtil
{
    public static function getMeta(mod:String, skipWarnings:Bool = true):ModData
    {
        var path:String = Path.join([mod, HeapsMod.config.metaFile]);
        var meta:ModData = null;

        try
        {
            var text:String = HeapsModFS.modFS.get(path).getText();

            meta = Json.parse(text);
            meta ??= {};
            
            meta.title ??= '';
            meta.description ??= '';
            meta.dependencies ??= [];

            meta.mod = mod;
        }
        catch (e)
        {
            HeapsMod.error(WARNING, MOD_MISSING_META, 'Mod $mod lacks metadata');

            return null;
        }
        
        if (!skipWarnings)
        {
            if (meta.id == null) HeapsMod.error(WARNING, MOD_MISSING_ID, 'Mod $mod is missing "id"');
            if (meta.version == null) HeapsMod.error(WARNING, MOD_MISSING_MOD_VERSION, 'Mod $mod is missing "version"');
            if (meta.apiVersion == null) HeapsMod.error(WARNING, MOD_MISSING_API_VERSION, 'Mod $mod is missing "apiVersion"');

            if (!isCompatible(meta)) HeapsMod.error(WARNING, MOD_INCOMPATIBLE_VERSION, 'Mod $mod is incompatible with API version');
        }

        return meta;
    }

    public static function getIcon(mod:String):Tile
    {
        var path:String = Path.join([mod, HeapsMod.config.iconFile]);
        var tile:Tile = try { new Image(HeapsModFS.modFS.get(path)).toTile(); } catch (e) null;

        if (tile == null) HeapsMod.error(WARNING, MOD_MISSING_ICON, 'Mod $mod lacks an icon');

        return tile;
    }

    public static function isCompatible(meta:ModData):Bool
    {
        return meta != null && (meta.apiVersion == HeapsMod.config.apiVersion || HeapsMod.config.apiVersion == null);
    }
}