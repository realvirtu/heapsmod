package heapsmod.data;

typedef ConfigData = {
    ?modRoot:String,
    ?metaFile:String,
    ?iconFile:String,
    ?apiVersion:Int,
    ?skipDependencies:Bool,
    ?skipDependencyErrors:Bool,
    ?onError:HeapsModError->Void,
    ?exclude:Array<String>,
    ?compat:Map<String, String>,
    ?mods:Array<String>,
    #if hxscript
    ?scriptExts:Array<String>,
    #end
}