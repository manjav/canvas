class Document extends BaseService {
	/**
		The singleton method of Files.
		```hx
		Document.instance. ....
		```
		@since 1.0.0
	**/
	static public var instance(get, null):Document;

	static private function get_instance():Document {
		return BaseService.get(Document);
	}
}
