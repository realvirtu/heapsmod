package heapsmod.data;

typedef ModData = {
    ?title:String,
    ?description:String,
    ?id:String,
    ?version:Int,
    ?apiVersion:Int,
    ?dependencies:Array<DependencyData>,
    ?mod:String
}

typedef DependencyData = {
    ?id:String,
    ?version:Int
}