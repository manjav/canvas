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
		super.set_targets(value);
		var isText = value.length == 1 && value.get(0).layer.type == Layer.TYPE_TEXT;
		this.includeInLayout = isText;
		this.visible = isText;
		this.target = isText ? cast(value.get(0), CanText) : null;
		return value;
	}

	private var familyList:ComboBox;
	override private function initialize() {
		super.initialize();
		this.layout = new AnchorLayout();

		this.title = "TEXT";

		// font families
		this.familyList = this.createComboBox(Fonts.load(), new AnchorLayoutData(padding * 3, padding, null, padding));
		this.familyList.itemToText = (family:FontFamily) -> {
			return family.name;
		};

		this.height = padding * 15;
	}

	override private function popupListView_changeHandler(event:Event):Void {
		if (cast(event.currentTarget, ComboBox).selectedIndex == -1)
			return;
			var family = cast(this.familyList.selectedItem, FontFamily);
			this.changeFont(family.styles[0]);
			this.styleList.dataProvider = new ArrayCollection(family.styleNames);
	}

	function changeFont(font:Font):Void {
		Font.registerFont(font);
		var textFormat = this.target.getTextFormat();
		textFormat.font = font.fontName;
		this.target.setTextFormat(textFormat);
	}
}
