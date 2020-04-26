package ir.grantech.canvas.controls.groups.sections;

import feathers.controls.ButtonGroup;
import feathers.controls.CanRangeInput;
import feathers.controls.ComboBox;
import feathers.data.ArrayCollection;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;
import ir.grantech.canvas.drawables.CanItems;
import ir.grantech.canvas.drawables.CanText;
import ir.grantech.canvas.services.Fonts;
import ir.grantech.canvas.services.Layers.Layer;
import openfl.events.Event;
import openfl.events.FocusEvent;
import openfl.text.Font;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormatAlign;

class TextSection extends CanSection {
	private var target:CanText;

	override private function set_targets(value:CanItems):CanItems {
		var isText = value.length == 1 && value.get(0).layer.type == Layer.TYPE_TEXT;
		this.includeInLayout = isText;
		this.visible = isText;
		this.target = isText ? cast(value.get(0), CanText) : null;
		super.set_targets(value);
		return value;
	}

	private var families:Array<FontFamily>;
	private var familyList:ComboBox;
	private var styleList:ComboBox;
	private var sizeInput:CanRangeInput;
	private var spaceLineInput:CanRangeInput;
	private var alignsButtons:ButtonGroup;
	private var sutoSizeButtons:ButtonGroup;

	override private function initialize() {
		super.initialize();
		this.layout = new AnchorLayout();

		this.title = "TEXT";
		this.families = Fonts.load();

		// font families
		this.familyList = this.createComboBox(this.families, new AnchorLayoutData(padding * 3, padding, null, padding));
		this.familyList.itemToText = (family:FontFamily) -> {
			return family.name;
		};

		// font styles
		this.styleList = this.createComboBox(null, new AnchorLayoutData(padding * 6, padding, null, padding * 7));
		this.styleList.itemToText = (style:FontStyle) -> {
			return style.styleName;
		};

		// font size
		this.sizeInput = this.createRangeInput(null, AnchorLayoutData.topLeft(padding * 6, padding));
		this.sizeInput.step = 1;

		// lince space
		this.spaceLineInput = this.createRangeInput("tspace-line", AnchorLayoutData.topLeft(padding * 9, padding * 6));
		this.spaceLineInput.step = 1;

		// text align
		var alignes = [
			TextFormatAlign.LEFT,
			TextFormatAlign.CENTER,
			TextFormatAlign.RIGHT,
			TextFormatAlign.JUSTIFY
		];
		this.alignsButtons = this.createButtonGroup(alignes, AnchorLayoutData.topLeft(padding * 9, padding));
		this.alignsButtons.itemToText = (align:TextFormatAlign) -> {
			return switch (align) {
				case TextFormatAlign.JUSTIFY: "talign-justify";
				case TextFormatAlign.CENTER: "talign-center";
				case TextFormatAlign.RIGHT: "talign-right";
				case TextFormatAlign.LEFT: "talign-left";
				default: null;
			}
		}

		// text auto size
		this.sutoSizeButtons = this.createButtonGroup([0, 1], AnchorLayoutData.topLeft(padding * 12, padding * 10));
		this.sutoSizeButtons.itemToText = (autosize:Int) -> {
			return autosize == 0 ? "tsize-align" : "tsize-none";
		}

		this.height = padding * 15;
	}

	override private function popupListView_changeHandler(event:Event):Void {
		if (this.updating || cast(event.currentTarget, ComboBox).selectedIndex == -1)
			return;
		var family = cast(this.familyList.selectedItem, FontFamily);
		if (event.currentTarget == this.familyList) {
			this.changeFont(family.styles[0]);
			this.updating = true;
			this.styleList.dataProvider = new ArrayCollection(family.styles);
			this.updating = false;
		} else if (event.currentTarget == this.styleList) {
			this.changeFont(family.styles[this.styleList.selectedIndex]);
		}
	}

	override private function textInputs_focusInHandler(event:FocusEvent):Void {
		cast(event.currentTarget, CanRangeInput).addEventListener(Event.CHANGE, this.textInputs_changeHandler);
	}

	override private function textInputs_focusOutHandler(event:FocusEvent):Void {
		cast(event.currentTarget, CanRangeInput).removeEventListener(Event.CHANGE, this.textInputs_changeHandler);
	}

	private function textInputs_changeHandler(event:Event):Void {
		if (this.targets.type != Layer.TYPE_TEXT)
			return;
		var textFormat = this.target.getTextFormat();
		if (event.currentTarget == this.sizeInput)
			textFormat.size = Math.round(this.sizeInput.value);
		else if (event.currentTarget == this.spaceLineInput)
			textFormat.leading = Math.round(this.spaceLineInput.value);

		this.target.setTextFormat(textFormat);
	}

	override private function buttonGroup_changeHandler(event:Event):Void {
		if (this.targets == null || this.targets.type != Layer.TYPE_TEXT)
			return;
		if (event.currentTarget == this.alignsButtons) {
			if (this.alignsButtons.selectedItem == null)
				return;
			for (item in this.targets.items) {
				var textfield = cast(item, CanText);
				var textFormat = textfield.getTextFormat();
				textFormat.align = this.alignsButtons.selectedItem;
				textfield.setTextFormat(textFormat);
			}
		} else if (event.currentTarget == this.sutoSizeButtons) {
			if (this.sutoSizeButtons.selectedItem == null)
				return;
			for (item in this.targets.items) {
				var textfield = cast(item, CanText);
				if (this.sutoSizeButtons.selectedIndex == 1) {
					textfield.autoSize = TextFieldAutoSize.NONE;
				} else {
					var textFormat = textfield.getTextFormat();
					textfield.autoSize = switch (textFormat.align) {
						case TextFormatAlign.CENTER: TextFieldAutoSize.CENTER;
						case TextFormatAlign.RIGHT: TextFieldAutoSize.RIGHT;
						default: TextFieldAutoSize.LEFT;
					}
				}
			}
		}
	}

	function changeFont(font:FontStyle):Void {
		Font.registerFont(font.font);
		var textFormat = this.target.getTextFormat();
		textFormat.font = font.fontName;
		this.target.setTextFormat(textFormat);
	}

	override public function updateData():Void {
		if (this.target == null)
			return;
		this.updating = true;

		var textFormat = this.target.getTextFormat();
		if (textFormat.font != null) {
			var style:FontStyle = FontFamily.findByStyle(this.families, textFormat.font);
			this.familyList.selectedItem = style.family;
			this.styleList.selectedItem = style;
		}
		if (textFormat.size != null)
			this.sizeInput.value = textFormat.size;

		this.updating = false;
	}
}
