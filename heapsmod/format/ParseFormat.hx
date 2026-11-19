package heapsmod.format;

import haxe.io.Path;
import hxd.fs.FileEntry;
import hxd.fs.FileSystem;

/**
 * A class for parsing and combining multiple text files.
 */
class ParseFormat
{
	/**
	 * A map of file extensions and their associated parse formats.
	 */
	public static var formats(default, null):Map<String, ParseFormat> = new Map<String, ParseFormat>();

	public function new()
	{
	}

	/**
	 * Gets a formatted file entry from `entries`.
	 */
	public function get(entries:Array<FileEntry>):FileEntry
	{
		throw 'Not implemented';
	}

	/**
	 * Parses `base` into the format associated with its file extension.
	 */
	public static function parse(path:String, entry:FileEntry):FileEntry
	{
		if (!HeapsMod.initialized) return entry;

		var ext:String = path.substr(path.lastIndexOf('.') + 1);

		if (!HeapsModFS.baseFS.exists(path) || !formats.exists(ext)) return entry;

		var entries:Array<FileEntry> = [];
		var fs:Array<FileSystem> = HeapsModFS.instance.fs;

		entries.push(entry);

		for (i in 0...fs.length)
		{
			var path:String = Path.join([HeapsMod.config.parseDir, path]);
			var fs:FileSystem = fs[fs.length - i - 1];

			if (fs == HeapsModFS.baseFS || !fs.exists(path)) continue;

			entries.push(fs.get(path));
		}

		var result:FileEntry = formats.get(ext).get(entries);

		return result;
	}
}
