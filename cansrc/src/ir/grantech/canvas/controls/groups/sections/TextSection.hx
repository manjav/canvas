package ir.grantech.canvas.controls.groups.sections;

import feathers.controls.ButtonGroup;
import feathers.controls.CanRangeInput;
import feathers.controls.ComboBox;
import feathers.controls.colors.ColorPicker;
import feathers.data.ArrayCollection;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;
import ir.grantech.canvas.drawables.CanItems;
import ir.grantech.canvas.services.Commands.*;
import ir.grantech.canvas.services.Fonts;
import ir.grantech.canvas.services.Layers.Layer;
import openfl.events.Event;
import openfl.events.FocusEvent;
import openfl.text.Font;
import openfl.text.TextFormatAlign;

class TextSection extends CanSection {
	override private function set_targets(value:CanItems):CanItems {
		this.visible = this.includeInLayout = value.type == Layer.TYPE_TEXT;
		super.set_targets(value);
		return value;
	}

	private var families:Array<FontFamily>;
	private var familyList:ComboBox;
	private var styleList:ComboBox;
	private var sizeInput:CanRangeInput;
	private var spaceLineInput:CanRangeInput;
	private var spaceLetterInput:CanRangeInput;
	private var alignsButtons:ButtonGroup;
	private var sutoSizeButtons:ButtonGroup;
	private var colorPicker:ColorPicker;

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

		// font color
		this.colorPicker = new ColorPicker();
		this.colorPicker.hasAlpha = false;
		this.colorPicker.addEventListener(Event.CHANGE, this.colorPicker_changeHandler);
		this.colorPicker.layoutData = AnchorLayoutData.topLeft(padding * 7, padding);
		this.addChild(this.colorPicker);

		// font size
		this.sizeInput = this.createRangeInput(null, AnchorLayoutData.topLeft(padding * 9, padding));
		this.sizeInput.step = 1;

		// letter space
		this.spaceLetterInput = this.createRangeInput("tspace-letter", AnchorLayoutData.topLeft(padding * 9, padding * 7));
		this.spaceLetterInput.step = 1;

		// lince space
		this.spaceLineInput = this.createRangeInput("tspace-line", AnchorLayoutData.topRight(padding * 9, padding));
		this.spaceLineInput.step = 1;

		// text align
		var alignes = [
			TextFormatAlign.LEFT,
			TextFormatAlign.CENTER,
			TextFormatAlign.RIGHT,
			TextFormatAlign.JUSTIFY
		];
		this.alignsButtons = this.createButtonGroup(alignes, AnchorLayoutData.topLeft(padding * 12, padding));
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
		if (this.updating || this.targets == null || this.targets.type != Layer.TYPE_TEXT)
			return;
		if (event.currentTarget == this.sizeInput)
			commands.commit(TEXT_SIZE, [this.targets, Math.round(this.sizeInput.value)]);
		else if (event.currentTarget == this.spaceLetterInput)
			commands.commit(TEXT_LETTERPACE, [this.targets, Math.round(this.spaceLetterInput.value)]);
		else if (event.currentTarget == this.spaceLineInput)
			commands.commit(TEXT_LINESPACE, [this.targets, Math.round(this.spaceLineInput.value)]);
	}

	private function colorPicker_changeHandler(event:Event):Void {
		if (this.updating || this.targets != null && this.targets.type == Layer.TYPE_TEXT)
			commands.commit(TEXT_COLOR, [this.targets, this.colorPicker.rgb]);
	}

	override private function buttonGroup_changeHandler(event:Event):Void {
		if (this.updating || this.targets == null || this.targets.type != Layer.TYPE_TEXT)
			return;
		if (event.currentTarget == this.alignsButtons) {
			commands.commit(TEXT_ALIGN, [this.targets, this.alignsButtons.selectedItem]);
			return;
		}

		commands.commit(TEXT_AUTOSIZE, [this.targets, this.sutoSizeButtons.selectedItem]);
	}

	function changeFont(font:FontStyle):Void {
		Font.registerFont(font.font);
		commands.commit(TEXT_FONT, [this.targets, font.fontName]);
	}

	override public function updateData():Void {
		if (this.targets == null || this.targets.type != Layer.TYPE_TEXT)
			return;
		this.updating = true;

		var style:FontStyle = FontFamily.findByStyle(this.families, this.targets.getString(TEXT_FONT));
		this.familyList.selectedItem = style.family;
		this.styleList.selectedItem = style;

		this.colorPicker.rgb = this.targets.getUInt(TEXT_COLOR);
		this.sizeInput.value = this.targets.getInt(TEXT_SIZE);
		this.spaceLetterInput.value = this.targets.getInt(TEXT_LETTERPACE);
		this.spaceLineInput.value = this.targets.getInt(TEXT_LINESPACE);

		this.updating = false;
	}
}
