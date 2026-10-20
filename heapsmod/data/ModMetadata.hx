package heapsmod.data;

/**
 * The metadata for a mod.
 */
typedef ModMetadata = {
    /**
     * A title for the mod.
     */
    @:optional
    var title:String;

    /**
     * A description for the mod.
     */
    @:optional
    var description:String;

    /**
     * A unique id for the mod.
     */
    @:optional
    var id:String;

    /**
     * The version number for the mod.
     */
    @:optional
    var version:Int;

    /**
     * The API version of the mod.
     */
    @:optional
    var apiVersion:Int;

    /**
     * A list of required dependencies for the mod.
     */
    @:optional
    var dependencies:Map<String, Int>;

    #if hxscript
    /**
     * A list of preprocessors for the mod, to be used in scripts.
     */
    @:optional
    var preprocessors:Map<String, String>;
    #end

    /**
     * The mod's directory name.
     */
    @:optional
    var dir:String;
}