package heapsmod.util;

/**
 * A utility class to retrieve the values of keys from JSON data.
 */
class JsonUtil
{
    /**
     * @return The dynamic value of `id` from `json`.
     */
    public static inline function get(id:String, json:Dynamic):Dynamic
    {
        return Reflect.field(json, id);
    }

    /**
     * @return The integer value of `id` from `json`.
     */
    public static inline function getInt(id:String, json:Dynamic):Int
    {
        return Std.int(get(id, json));
    }

    /**
     * @return The bool value of `id` from `json`.
     */
    public static inline function getBool(id:String, json:Dynamic):Bool
    {
        return get(id, json) == true;
    }

    /**
     * @return The string value of `id` from `json`.
     */
    public static inline function getString(id:String, json:Dynamic):String
    {
        return Std.string(get(id, json));
    }

    /**
     * @return A string map of `id` from `json`.
     */
    public static inline function getStringMap<V>(id:String, json:Dynamic):Map<String, V>
    {
        var result:Map<String, V> = [];
        
        if (exists(id, json))
        {
            var map:Dynamic = get(id, json);

            for (field in Reflect.fields(map)) result.set(field, get(field, map));
        }

        return result;
    }

    /**
     * @return Whether `id` exists for `json`.
     */
    public static inline function exists(id:String, json:Dynamic):Bool
    {
        return Reflect.hasField(json, id);
    }
}