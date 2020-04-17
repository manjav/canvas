package ir.grantech.canvas.controls.groups.panels;

import feathers.controls.ComboBox;
import feathers.data.ArrayCollection;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;
import ir.grantech.canvas.drawables.CanItems;
import ir.grantech.canvas.drawables.CanText;
import ir.grantech.canvas.services.Fonts;
import ir.grantech.canvas.services.Layers.Layer;
import openfl.events.Event;
import openfl.text.Font;

class TextPanel extends Panel {
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
		this.styleList = this.createComboBox(null, new AnchorLayoutData(padding * 7, padding, null, padding * 7));
		this.styleList.itemToText = (style:FontStyle) -> {
			return style.styleName;
		};
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

	}

	function changeFont(font:FontStyle):Void {
		Font.registerFont(font.font);
		var textFormat = this.target.getTextFormat();
		textFormat.font = font.fontName;
		this.target.setTextFormat(textFormat);
	}

	override public function updateData():Void {
		if (this.target == null || !this.targets.filled)
			return;
		this.updating = true;

		var textFormat = this.target.getTextFormat();
		var style:FontStyle = FontFamily.findByStyle(this.families, textFormat.font);
		this.familyList.selectedItem = style.family;
		this.styleList.selectedItem = style;

		this.updating = false;
	}
}