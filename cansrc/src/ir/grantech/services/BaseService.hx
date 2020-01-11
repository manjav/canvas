package ir.grantech.services;

class BaseService {
	static private var classes = new Map<String, Dynamic>();

	// static public function set(ng, cl:Class<T>, args:Array<Dynamic> = null):Void {
	// 	classes.set(cl., Type.createInstance(cl, args));
	// }

	static public function get(cl:Class<BaseService>, args:Array<Dynamic> = null):Dynamic {
		if( args == null )
			args = new Array<Dynamic>();
		var name = Std.string(cl);
		if (!classes.exists(name))
			classes.set(name, Type.createInstance(cl, args));
		return classes.get(name);
	}
}
