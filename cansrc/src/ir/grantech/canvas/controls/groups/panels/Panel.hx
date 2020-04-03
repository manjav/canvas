package ir.grantech.canvas.controls.groups.panels;

import ir.grantech.canvas.drawables.ICanItem;
import openfl.display.DisplayObject;
import feathers.data.ListViewItemState;
import ir.grantech.canvas.controls.items.ToolBarItemRenderer;
import feathers.utils.DisplayObjectRecycler;
import feathers.controls.ListView;
import feathers.controls.Button;
import feathers.controls.ButtonState;
import feathers.controls.CanHSlider;
import feathers.controls.CanRangeInput;
import feathers.controls.CanTextInput;
import feathers.controls.Label;
import feathers.controls.PopUpListView;
import feathers.data.ArrayCollection;
import feathers.layout.AnchorLayoutData;
import feathers.style.Theme;
import ir.grantech.canvas.controls.popups.DropCenterPopUpAdapter;
import ir.grantech.canvas.themes.CanTheme;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.events.Event;
import openfl.events.FocusEvent;
import openfl.events.MouseEvent;

class Panel extends CanView {
	public var title(default, set):String;

	private function set_title(value:String):String {
		if (this.title == value)
			return this.title;
		if (value == null) {
			if (this.titleDisplay != null)
				this.removeChild(this.titleDisplay);
			return null;
		}

		this.titleDisplay = this.createLabel(value, AnchorLayoutData.topLeft(padding, padding), Label.VARIANT_HEADING);
		return this.title = value;
	}

	private var titleDisplay:Label;

	@:access(feathers.themes.steel.CanTheme)
	override private function initialize() {
		super.initialize();
		Std.downcast(Theme.getTheme(), CanTheme).setPanelStyles(this);
	}

	public var target(default, set):ICanItem;

	private function set_target(value:ICanItem):ICanItem {
		if (this.target == value)
			return this.target;
		this.target = value;
		if (this.target != null)
			this.update();
		return this.target;
	}

	public function updateData():Void {}

	private function createSlider(minimum:Float, value:Float, maximum:Float, layoutData:AnchorLayoutData):CanHSlider {
		var element = new CanHSlider();
		element.minimum = minimum;
		element.value = value;
		element.maximum = maximum;
		element.layoutData = layoutData;
		element.height = CanTheme.CONTROL_SIZE;
		element.addEventListener(Event.CHANGE, this.sliders_changeHandler);
		this.addChild(element);
		return element;
	}

	private function createPopupList(items:Array<Dynamic>, layoutData:AnchorLayoutData):PopUpListView {
		var element = new PopUpListView();
		element.dataProvider = new ArrayCollection(items);
		element.layoutData = layoutData;
		element.height = CanTheme.CONTROL_SIZE;
		element.popUpAdapter = new DropCenterPopUpAdapter(12 * CanTheme.CONTROL_SIZE);
		element.addEventListener(Event.CHANGE, this.popupListView_changeHandler);
		this.addChild(element);
		return element;
	}

	private function createList(items:Array<Dynamic>, itemRendererRecycler:DisplayObjectRecycler<Dynamic, ListViewItemState, DisplayObject>,
			layoutData:AnchorLayoutData = null):ListView {
		var element = new ListView();
		if (items != null)
			element.dataProvider = new ArrayCollection(items);
		if (itemRendererRecycler != null)
			element.itemRendererRecycler = itemRendererRecycler;
		element.layoutData = layoutData;
		this.addChild(element);
		return element;
	}

	private function createLabel(text:String, layoutData:AnchorLayoutData, variant:String = null):Label {
		var element = new Label();
		element.text = text;
		if (variant != null)
			element.variant = variant;
		element.layoutData = layoutData;
		this.addChild(element);
		return element;
	}

	private function createButton(icon:String, layoutData:AnchorLayoutData):Button {
		var disabledIcon = new Bitmap(Assets.getBitmapData(icon));
		disabledIcon.alpha = 0.6;
		var element = new Button();
		element.width = element.height = 16 * CanTheme.DPI;
		element.icon = new Bitmap(Assets.getBitmapData(icon));
		element.setIconForState(ButtonState.DISABLED, disabledIcon);
		element.layoutData = layoutData;
		element.addEventListener(MouseEvent.CLICK, this.buttons_clickHandler);
		this.addChild(element);
		return element;
	}

	private function createTextInput(icon:String, layoutData:AnchorLayoutData):CanTextInput {
		var element = new CanTextInput();
		this.redjustInput(element, icon, layoutData);
		return element;
	}

	private function createRangeInput(icon:String, layoutData:AnchorLayoutData):CanRangeInput {
		var element = new CanRangeInput();
		this.redjustInput(element, icon, layoutData);
		element.step = 2;
		return element;
	}

	private function redjustInput(element:CanTextInput, icon:String, layoutData:AnchorLayoutData):Void {
		element.width = 36 * CanTheme.DPI;
		element.height = 16 * CanTheme.DPI;
		element.icon = icon;
		element.layoutData = layoutData;
		element.addEventListener(FocusEvent.FOCUS_IN, this.textInputs_focusInHandler);
		element.addEventListener(FocusEvent.FOCUS_OUT, this.textInputs_focusOutHandler);
		this.addChild(element);
	}

	private function popupListView_changeHandler(event:Event):Void {}

	private function sliders_changeHandler(event:Event):Void {}

	private function buttons_clickHandler(event:MouseEvent):Void {}

	private function textInputs_focusInHandler(event:FocusEvent):Void {}

	private function textInputs_focusOutHandler(event:FocusEvent):Void {}
}
