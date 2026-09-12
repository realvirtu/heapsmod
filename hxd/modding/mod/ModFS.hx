package hxd.modding.mod;

import haxe.io.Path;
import hxd.fs.LocalFileSystem;

using StringTools;
using Lambda;

class ModFS extends LocalFileSystem
{
    public var mod(default, null):Mod;

    public function new(mod:Mod)
    {
        super(Path.join([HeapsMod.config.modRoot, mod.mod]), null);

        this.mod = mod;
    }

    override function open(path:String, check:Bool = true):LocalEntry
    {
        if (path.startsWith('/')) path = path.substr(1);

        // Skip excluded paths
        if (HeapsMod.config.exclude.exists(exclude -> return path.startsWith(exclude))) return null;

        var entry:LocalEntry = super.open(path, check);

        if (entry != null) return entry;

        // Check if the path can be converted for backwards compatibility
        for (oldPath => newPath in HeapsMod.config.compat)
        {
            if (path.startsWith(newPath))
            {
                entry = super.open(oldPath + path.substr(newPath.length), check);

                if (entry != null) break;
            }
        }

        if (entry != null) HeapsMod.error(INFO, COMPAT_CONVERT_PATH, 'Converted path ${entry.path} -> $path');

        return entry;
    }
}