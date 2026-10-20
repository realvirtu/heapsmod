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

    /**
     * The mod folder name.
     */
    @:optional
    var mod:String;
}