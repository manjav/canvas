package ir.grantech.canvas.controls.groups;

import feathers.controls.Button;
import feathers.controls.LayoutGroup;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;
import feathers.skins.RectangleSkin;
import ir.grantech.canvas.controls.groups.sections.CanSection;
import ir.grantech.canvas.themes.CanTheme;
import ir.grantech.canvas.themes.RectSkin;
import openfl.display.Shape;
import openfl.events.MouseEvent;
import openfl.ui.Mouse;
import openfl.ui.MouseCursor;

class Border extends LayoutGroup {
	override private function initialize():Void {
		super.initialize();

		this.layoutData = AnchorLayoutData.fill();
		this.layout = new AnchorLayout();

		var b = CanTheme.DPI * 2;
		var skin = new Shape();
		skin.graphics.beginFill(0xFF, 0.5);
		skin.graphics.drawRect(0, 0, stage.stageWidth, b);
		skin.graphics.drawRect(stage.stageWidth - b, 0, b, stage.stageHeight);
		skin.graphics.drawRect(0, stage.stageHeight - b, stage.stageWidth, b);
		skin.graphics.drawRect(0, 0, b, stage.stageHeight);
		skin.graphics.endFill();
		this.backgroundSkin = skin;
	}
}
