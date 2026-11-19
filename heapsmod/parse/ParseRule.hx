package heapsmod.parse;

import haxe.io.Path;
import hxd.fs.FileEntry;
import hxd.fs.FileSystem;

/**
 * A class for parsing and combining multiple text files.
 */
class ParseRule
{
	/**
	 * The file extensions associated with parse rules.
	 */
	public static var rules(default, null):Map<String, ParseRule> = new Map<String, ParseRule>();

	public function new()
	{
	}

	/**
	 * Gets a combined file entry from `entries`.
	 */
	public function get(entries:Array<FileEntry>):FileEntry
	{
		throw 'Not implemented';
	}

	/**
	 * Parses `base` into a merged `FileEntry`.
	 */
	public static function parse(path:String, entry:FileEntry):FileEntry
	{
		if (!HeapsMod.initialized) return entry;

		var ext:String = path.substr(path.lastIndexOf('.') + 1);

		if (!HeapsModFS.baseFS.exists(path) || !rules.exists(ext)) return entry;

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

		var result:FileEntry = rules.get(ext).get(entries);

		return result;
	}
}
