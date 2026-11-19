package heapsmod.format;

import haxe.io.Path;
import hxd.fs.FileEntry;
import hxd.fs.FileSystem;

/**
 * A class for parsing and formatting text files.
 */
class ParseFormat
{
	public function new()
	{
	}

	/**
	 * Gets a formatted file entry from `base` and `files`.
	 */
	public function get(base:FileEntry, files:Array<FileEntry>):FileEntry
	{
		throw 'Not implemented';
	}

	/**
	 * Parses `base` into the format associated with its file extension.
	 */
	public static function parse(path:String, entry:FileEntry):FileEntry
	{
		if (!HeapsMod.initialized) return entry;

		var formats:Map<String, ParseFormat> = HeapsMod.config.parseFormats;
		var ext:String = path.substr(path.lastIndexOf('.') + 1);

		if (!HeapsModFS.baseFS.exists(path) || !formats.exists(ext)) return entry;

		var fs:Array<FileSystem> = HeapsModFS.instance.fs;
		var files:Array<FileEntry> = [];

		for (i in 0...fs.length)
		{
			var path:String = Path.join([HeapsMod.config.parseDir, path]);
			var fs:FileSystem = fs[fs.length - i - 1];

			if (fs == HeapsModFS.baseFS || !fs.exists(path)) continue;

			files.push(fs.get(path));
		}

		return formats.get(ext).get(entry, files);
	}
}
