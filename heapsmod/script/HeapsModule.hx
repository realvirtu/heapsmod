package heapsmod.script;

#if hxscript
import hxd.fs.FileEntry;
import hxscript.Module;

/**
 * A script class to be loaded by the `HeapsScript` class.
 */
class HeapsModule extends Module
{
    public function new(entry:FileEntry)
    {
        super(entry.getText(), entry.name, [], entry.path);

        HeapsMod.error(INFO, SCRIPT_INIT, 'Initialized script ${entry.name}');
    }
}
#end