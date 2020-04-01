package ir.grantech.services;

import openfl.display.Stage;
import feathers.data.ArrayCollection;
import feathers.events.FeathersEvent;
import openfl.display.Bitmap;
import openfl.events.Event;

class LayersService extends BaseService {
	/**
		The singleton method of itemsService.
		```hx
		itemsService.instance. ....
		```
		@since 1.0.0
	**/
	static public var instance(get, null):LayersService;

	static private function get_instance():LayersService {
		return BaseService.get(LayersService);
	}

	public var items(default, default):ArrayCollection<Layer>;

	public var selectedItem(default, set):Layer;

	private function set_selectedItem(value:Layer):Layer {
		if (this.selectedItem == value)
			return value;
		var index = this.items.indexOf(value);
		if (index > -1)
			this.selectedIndex = index;
		this.selectedItem = value;
		return this.selectedItem;
	}

	/**
	 * Method to select layer with index.
	 */
	public var selectedIndex(default, set):Int = -1;

	private function set_selectedIndex(value:Int):Int {
		if (this.selectedIndex == value)
			return this.selectedIndex;

		this.selectedItem = value > -1 ? this.items.get(this.selectedIndex) : null;
		this.selectedIndex = value;
		FeathersEvent.dispatch(this, Event.SELECT);
		return this.selectedIndex;
	}

  private var stage:Stage;

	/**
	 * Constructor.
	 */
   public function new(stage:Stage) {
		super();
		this.stage = stage;
		this.items = new ArrayCollection<Layer>();
    this.items.sortCompareFunction = orderFunction;
    add(0);
    add(1);
    add(2);
	}

	/**
	 * Method to add new layer.
	 */
	public function add(type:Int):Void {
		var layer:Layer = new Layer(0,type);
		// if( type == Layer.TYPE_PARTICLE )
		//   layer = new ParticleDataModel() as LayerDataModel;
		// else if( type == LayerDataModel.TYPE_IMAGE )
		//   layer = new ImageDataModel() as LayerDataModel;
		// layer.type = type;

    // this.addLayerConfig(layer, null);
    this.items.add(layer);
	}

	/**
	 * Method to remove layer with it's object.
	 */
	public function remove(layer:Layer):Void {
		this.items.remove(layer);
		this.selectedIndex = -1;
		FeathersEvent.dispatch(this, Event.REMOVED);
	}

	/**
	 * Method to remove layer with it's index.
	 */
	public function removeLayerAt(index:Int):Void {
		this.items.removeAt(index);
		this.selectedIndex = -1;
		FeathersEvent.dispatch(this, Event.REMOVED);
	}

	private function getItemIndex(item:Layer):Int {
		return -1;
	}

	private function changeOrder(index:Int, direction:Int):Void {
		var oldLayer = this.items.get(index);
		var newLayer = this.items.get(index + direction);

		var tmp:Int = oldLayer.order;
		oldLayer.order = newLayer.order;
		newLayer.order = tmp;

		this.items.refresh();
		this.selectedItem = newLayer;
	}

	private function orderFunction(left:Layer, right:Layer):Int {
		return left.order - right.order;
	}
}

class Layer {
	static public final TYPE_SHAPE:Int = 0;
	static public final TYPE_SPRITE:Int = 1;
	static public final TYPE_BITMAP:Int = 2;
	static public final TYPE_PARTICLE:Int = 6;

	public var id(default, default):Int;
	public var type(default, default):Int;
	public var order(default, default):Int;
	public var name(default, default):String;
  public var icon(default, default):Bitmap;
  public var visible(default, default):Bool = true;
  public var enabled(default, default):Bool = true;
  
  public function new(id:Int, type:Int) {
    this.id = id;
    this.type = type;
    this.name = "Layer " + id;
  }
}
