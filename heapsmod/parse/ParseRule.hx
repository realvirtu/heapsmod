package heapsmod.parse;

import hxd.fs.BytesFileSystem.BytesFileEntry;
import hxd.fs.FileSystem;
import haxe.io.Bytes;
import haxe.io.Path;
import hxd.fs.FileEntry;

using StringTools;

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
	public static function parse(base:FileEntry):FileEntry
	{
		if (!HeapsMod.initialized) return base;

		var path:String = base.path;
		var ext:String = path.substr(path.lastIndexOf('.') + 1);

		if (!HeapsModFS.baseFS.exists(path) || !rules.exists(ext)) return base;

		var entries:Array<FileEntry> = [];
		var fs:Array<FileSystem> = HeapsModFS.instance.fs;

		entries.push(base);

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

/**
 * `ParseRule` class for `.txt` files.
 */
class TxtParseRule extends ParseRule
{
	override function get(entries:Array<FileEntry>):FileEntry
	{
		var result:String = '';

		for (entry in entries)
		{
			result += entry.getText();
			result += '\n';
		}

		return new BytesFileEntry(entries[0].path, Bytes.ofString(result.trim()));
	}
}
