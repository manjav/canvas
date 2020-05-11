package ir.grantech.canvas.controls.groups.sections;

import feathers.controls.ButtonGroup;
import feathers.controls.Button;
import feathers.controls.ButtonState;
import feathers.controls.CanHSlider;
import feathers.controls.CanRangeInput;
import feathers.controls.CanTextInput;
import feathers.controls.ComboBox;
import feathers.controls.Label;
import feathers.controls.ListView;
import feathers.controls.PopUpListView;
import feathers.controls.colors.ColorLine;
import feathers.data.ArrayCollection;
import feathers.data.ListViewItemState;
import feathers.layout.AnchorLayoutData;
import feathers.skins.RectangleSkin;
import feathers.style.Theme;
import feathers.themes.steel.BaseSteelTheme;
import feathers.utils.DisplayObjectRecycler;
import ir.grantech.canvas.controls.popups.DropCenterPopUpAdapter;
import ir.grantech.canvas.drawables.CanItems;
import ir.grantech.canvas.themes.CanTheme;
import lime.math.RGB;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.DisplayObject;
import openfl.events.Event;
import openfl.events.FocusEvent;
import openfl.events.MouseEvent;

class CanSection extends CanView {
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
	private var updating = false;

	@:access(feathers.themes.steel.BaseSteelTheme)
	override private function initialize() {
		super.initialize();
		var theme = Std.downcast(Theme.getTheme(), BaseSteelTheme);
		var skin = new RectangleSkin();
		skin.fill = SolidColor(theme.controlFillColor1);
		this.backgroundSkin = skin;
	}

	public var targets(default, set):CanItems;

	private function set_targets(value:CanItems):CanItems {
		this.targets = value;
		if (value != null)
			this.updateData();
		return value;
	}

	public function updateData():Void {}

	private function createColorLine(label:String, color:RGB, alpha:UInt = 0xFF, selected:Bool = true, layoutData:AnchorLayoutData = null):ColorLine {
		var element = new ColorLine();
		element.a = alpha;
		element.rgb = color;
		element.label = label;
		element.selected = selected;
		element.layoutData = layoutData;
		element.addEventListener(Event.SELECT, this.colorLines_selectHandler);
		element.addEventListener(Event.CHANGE, this.colorLines_changeHandler);
		this.addChild(element);
		return element;
	}

	private function createSlider(minimum:Float, value:Float, maximum:Float, layoutData:AnchorLayoutData):CanHSlider {
		var element = new CanHSlider();
		element.value = value;
		element.minimum = minimum;
		element.maximum = maximum;
		element.layoutData = layoutData;
		element.height = CanTheme.CONTROL_SIZE;
		element.addEventListener(Event.CHANGE, this.sliders_changeHandler);
		this.addChild(element);
		return element;
	}

	private function createComboBox(items:Array<Dynamic>, layoutData:AnchorLayoutData):ComboBox {
		var element = new ComboBox();
		element.dataProvider = new ArrayCollection(items);
		element.layoutData = layoutData;
		element.height = CanTheme.CONTROL_SIZE;
		element.addEventListener(Event.CHANGE, this.popupListView_changeHandler);
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
		element.variant = ListView.VARIANT_BORDERLESS;
		if (items != null)
			element.dataProvider = new ArrayCollection(items);
		if (itemRendererRecycler != null)
			element.itemRendererRecycler = itemRendererRecycler;
		element.layoutData = layoutData;
		this.addChild(element);
		return element;
	}

	private function createButtonGroup(items:Array<Dynamic>, layoutData:AnchorLayoutData):ButtonGroup {
		var element = new ButtonGroup();
		element.layoutData = layoutData;
		element.height = CanTheme.CONTROL_SIZE;
		element.dataProvider = new ArrayCollection(items);
		element.addEventListener(Event.CHANGE, this.buttonGroup_changeHandler);
		this.addChild(element);
		return element;
	}

	private function createLabel(text:String, layoutData:AnchorLayoutData, variant:String = null):Label {
		var element = new Label();
		element.embedFonts = true;
		element.text = text;
		if (variant != null)
			element.variant = variant;
		element.layoutData = layoutData;
		this.addChild(element);
		return element;
	}

	private function createButton(icon:String, layoutData:AnchorLayoutData):Button {
		var bd = CanTheme.getScaledBitmapData(icon);
		var disabledIcon = new Bitmap(bd);
		disabledIcon.alpha = 0.5;
		var element = new Button();
		element.name = icon;
		element.width = element.height = 16 * CanTheme.DPI;
		element.icon = new Bitmap(bd);
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

	private function buttonGroup_changeHandler(event:Event):Void {}

	private function colorLines_selectHandler(event:Event):Void {}

	private function colorLines_changeHandler(event:Event):Void {}

	private function popupListView_changeHandler(event:Event):Void {}

	private function sliders_changeHandler(event:Event):Void {}

	private function buttons_clickHandler(event:MouseEvent):Void {}

	private function textInputs_focusInHandler(event:FocusEvent):Void {}

	private function textInputs_focusOutHandler(event:FocusEvent):Void {}
}
