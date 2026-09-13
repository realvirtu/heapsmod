package heapsmod.script;

#if hxscript
import hxd.fs.FileEntry;
import hxscript.Module;

class HeapsModule extends Module
{
    public function new(entry:FileEntry)
    {
        super(entry.getText(), entry.name, [], entry.path);

        HeapsMod.error(INFO, SCRIPT_INIT, 'Loaded script ${entry.name}');
    }
}
#end