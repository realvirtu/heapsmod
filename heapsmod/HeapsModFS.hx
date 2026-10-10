package heapsmod;

import hxd.fs.FileEntry;
import hxd.fs.FileSystem;
import hxd.fs.LocalFileSystem;
import hxd.fs.MultiFileSystem;
import hxd.res.Loader;
import hxd.Res;

using Lambda;

/**
 * Filesystem class for HeapsMod.
 */
class HeapsModFS extends MultiFileSystem
{
    /**
     * The `HeapsModFS` instance.
     */
    public static var instance:HeapsModFS;
    
    /**
     * A local filesystem used for mods.
     */
    public static var modFS:LocalFileSystem;

    /**
     * The original filesystem used.
     */
    public static var baseFS:FileSystem;

    public function new(fs:FileSystem)
    {
        instance = this;

        modFS = new LocalFileSystem(HeapsMod.config.modRoot, null);
        baseFS = fs;

        super([baseFS]);
    }

    override function dir(path:String):Array<FileEntry>
    {
        var result:Array<FileEntry> = [];

        for (fs in fs)
        {
            for (entry in try fs.dir(path) catch (e) [])
            {
                if (result.exists(file -> return file.path == entry.path)) continue;

                result.push(entry);
            }
        }

        return result;
    }

    override function dispose()
    {
        Res.loader = new Loader(baseFS);
        
        fs.remove(baseFS);
        
        modFS.dispose();
        
        modFS = null;
        baseFS = null;
        instance = null;

        super.dispose();
    }
}