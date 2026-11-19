package heapsmod.format;

import haxe.io.Bytes;
import hxd.fs.BytesFileSystem.BytesFileEntry;
import hxd.fs.FileEntry;

using StringTools;

/**
 * `ParseRule` class for `.txt` files.
 */
class TxtParseFormat extends ParseFormat
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
