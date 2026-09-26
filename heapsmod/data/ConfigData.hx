package heapsmod.data;

/**
 * Configuration data used when initializing HeapsMod.
 */
typedef ConfigData = {
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
     * The API version number mods are required to be at.
     */
    @:optional
    var apiVersion:Int;

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
    var exclude:Array<String>;

    /**
     * A string map for validating file paths with newer ones.
     */
    @:optional
    var compat:Map<String, String>;

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
    #end
}