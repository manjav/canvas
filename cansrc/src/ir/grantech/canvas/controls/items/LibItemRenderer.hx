package ir.grantech.canvas.controls.items;

import feathers.controls.dataRenderers.IDataRenderer;
import ir.grantech.canvas.events.CanEvent;
import ir.grantech.canvas.services.Libs.LibItem;
import ir.grantech.canvas.services.Libs.LibType;
import ir.grantech.canvas.themes.CanTheme;
import ir.grantech.canvas.themes.ScaledBitmap;
import openfl.display.Bitmap;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;

class LibItemRenderer extends CanItemRenderer implements IDataRenderer {

	override private function set_data(value:Dynamic):Dynamic {
		if (this.data == value)
			return value;
		super.set_data(value);
		this.item = cast(this.data, LibItem);
		return value;
	}


	private var item:LibItem;
	private var typeField:TextField;

	public function new() {
		super();
		this.height = CanTheme.CONTROL_SIZE + CanTheme.DPI * 8;
	}
	override function initialize():Void {
		super.initialize();

		this.icon = this.item.type == LibType.Image ? new Bitmap(this.item.source) : new ScaledBitmap("bitmap");
		var pw = this.icon.width;
		var ph = this.icon.height;
		if (pw > ph) {
			this.icon.width = this.actualHeight - this.paddingLeft * 2;
			this.icon.height = ph * this.icon.width / pw;
		} else {
			this.icon.height = this.actualHeight - this.paddingLeft * 2;
			this.icon.width = pw * this.icon.height / ph;
		}

		this.typeField = new TextField();
		this.typeField.autoSize = TextFieldAutoSize.RIGHT;
		this.addChild(this.typeField);

		this.iconPosition = MANUAL;
		this.gap = CanTheme.DEFAULT_PADDING;
		this.addEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownHandler);
	}

	private function mouseDownHandler(event:Event):Void {
		this.removeEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownHandler);
		this.addEventListener(MouseEvent.MOUSE_OUT, this.mouseOutHandler);
		stage.addEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
	}

	private function mouseOutHandler(event:Event):Void {
		CanEvent.dispatch(this, CanEvent.ITEM_SELECT, item, true);
	}

	private function mouseUpHandler(event:Event):Void {
		this.removeEventListener(MouseEvent.MOUSE_OUT, this.mouseOutHandler);
		stage.removeEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
		this.addEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownHandler);
	}

	override private function refreshText():Void {
		super.refreshText();
		this.typeField.text = Std.string(this.item.type);
	}

	override private function layoutContent():Void {
		this.icon.x = this.paddingLeft + (this.actualHeight - this.icon.width) * 0.5;
		this.icon.y = (this.actualHeight - this.icon.height) * 0.5;

		this.textField.x = this.actualHeight;
		this.textField.y = (this.actualHeight - this.textField.height) * 0.5;

		this.typeField.x = this.actualWidth - this.typeField.width - this.paddingRight;
		this.typeField.y = (this.actualHeight - this.textField.height) * 0.5;
	}
}
