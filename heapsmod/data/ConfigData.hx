package heapsmod.data;

import heapsmod.parse.ParseRule;

/**
 * Configuration data used when initializing HeapsMod.
 */
typedef ConfigData =
{
	/**
	 * The root directory where mods are checked for.
	 */
	@:optional
	var modRoot:String;

	/**
	 * The name of the metadata file for mods.
	 */
	@:optional
	var metaFile:String;

	/**
	 * The name of the icon file for mods.
	 */
	@:optional
	var iconFile:String;

	/**
	 * The API version rule mods are required to be compatible with.
	 */
	@:optional
	var apiVersion:Int->Bool;

	/**
	 * Whether dependency checks should be skipped or not.
	 */
	@:optional
	var skipDependencies:Bool;

	/**
	 * Whether dependency errors should be ignored or not.
	 */
	@:optional
	var skipDependencyErrors:Bool;

	/**
	 * A callback that runs when an error occurs.
	 */
	@:optional
	var onError:HeapsModError->Void;

	/**
	 * An array of file paths that should be ignored by mod filesystems.
	 */
	@:optional
	var ignored:Array<String>;

	/**
	 * A string map for validating file paths with newer ones.
	 */
	@:optional
	var compat:Map<String, String>;

	/**
	 * A string map associating file extensions with parse rules for combining text files.
	 */
	@:optional
	var parseRules:Map<String, ParseRule>;

	/**
	 * The directory where text files are parsed.
	 */
	@:optional
	var parseDir:String;

	/**
	 * An array of mod folders that should be enabled.
	 */
	@:optional
	var mods:Array<String>;

	#if hxscript
	/**
	 * An array of file extensions to be checked for when loading scripts.
	 */
	@:optional
	var scriptExts:Array<String>;

	/**
	 * Whether mods have their own script preprocessors.
	 */
	@:optional
	var modPreprocessors:Bool;
	#end
}
