package heapsmod.data;

/**
 * The data for a mod.
 */
typedef ModData = {
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
    var dependencies:Array<DependencyData>;

    /**
     * The mod folder name.
     */
    @:optional
    var mod:String;
}

/**
 * The data for mod dependencies.
 */
typedef DependencyData = {
    /**
     * The id for the dependency.
     */
    @:optional
    var id:String;

    /**
     * The version number for the dependency.
     */
    @:optional
    var version:Int;
}