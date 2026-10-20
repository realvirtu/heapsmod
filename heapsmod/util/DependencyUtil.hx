package heapsmod.util;

import heapsmod.data.ModData;

using Lambda;

/**
 * A utility class for dependencies.
 */
class DependencyUtil
{
    /**
     * Gets a list of dependencies for a mod.
     * @param meta The mod metadata to check.
     * @return An array of dependency ids.
     */
    public static function getDependencies(meta:ModData):Array<String>
    {
        if (meta == null) return [];
        
        return [for (id in meta.dependencies.keys()) id];
    }

    /**
     * Gets a list of missing dependencies for a mod.
     * @param meta The mod metadata to check.
     * @return An array of dependency ids.
     */
    public static function getMissingDependencies(meta:ModData):Array<String>
    {
        if (meta == null) return [];

        return getDependencies(meta).filter(id -> return HeapsMod.getEnabledModVersion(id) != meta.dependencies.get(id));
    }

    /**
     * Sorts an array of mod metadata by dependencies.
     * @param mods A list of mods to sort.
     * @return A sorted list of the mods.
     */
    public static function sortByDependencies(mods:Array<ModData>):Array<ModData>
    {
        var result:Array<ModData> = [];
        var checked:Array<String> = [];

        function add(id:String)
        {
            var meta:ModData = mods.find(mod -> return mod.id == id);

            if (meta == null || result.contains(meta)) return;

            checked.push(id);

            if (!HeapsMod.config.skipDependencies)
            {
                for (id in meta.dependencies.keys())
                {
                    var skipErrors:Bool = HeapsMod.config.skipDependencyErrors;

                    if (id == meta.id)
                    {
                        HeapsMod.error(skipErrors ? WARNING : ERROR, MOD_DEPENDENCY_ERROR, 'Mod ${meta.id} cannot depend on itself');

                        if (skipErrors) continue;
                        
                        return;
                    }

                    if (checked.contains(id))
                    {
                        HeapsMod.error(skipErrors ? WARNING : ERROR, MOD_DEPENDENCY_ERROR, 'Mods cannot depend on each other');

                        if (skipErrors) continue;

                        return;
                    }

                    add(id);
                }
            }

            result.push(meta);
        }

        for (mod in mods) add(mod.id);

        return result;
    }
}