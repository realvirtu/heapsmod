package heapsmod;

import heapsmod.format.ParseFormat;
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

		modFS = try new LocalFileSystem(HeapsMod.config.modRoot, null) catch (e) null;
		baseFS = fs;

		super([baseFS]);
	}

	override function get(path:String):FileEntry
	{
		return ParseFormat.parse(path, super.get(path));
	}

	override function dir(path:String):Array<FileEntry>
	{
		var result:Array<FileEntry> = [];

		for (fs in fs)
		{
			var entries:Array<FileEntry> = try fs.dir(path) catch (e) [];

			for (entry in entries)
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

		modFS?.dispose();

		modFS = null;
		baseFS = null;
		instance = null;

		super.dispose();
	}
}
