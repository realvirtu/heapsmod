package heapsmod.format;

import haxe.io.Bytes;
import hxd.fs.BytesFileSystem.BytesFileEntry;
import hxd.fs.FileEntry;

/**
 * A parse format for generic text files.
 */
class TextParseFormat extends ParseFormat
{
	override function get(base:FileEntry, files:Array<FileEntry>):FileEntry
	{
		var result:String = base.getText();

		for (file in files)
		{
			result += '\n';
			result += file.getText();
		}

		return new BytesFileEntry(base.path, Bytes.ofString(result));
	}
}
