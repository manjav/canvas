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
	static final B:Int = Math.floor(CanTheme.DPI * 1.6);

	override private function initialize():Void {
		super.initialize();

		this.layoutData = AnchorLayoutData.fill();
		this.layout = new AnchorLayout();

		var skin = new Shape();
		skin.graphics.beginFill(0xFF, 0);
		skin.graphics.drawRect(0, 0, stage.stageWidth, B);
		skin.graphics.drawRect(stage.stageWidth - B, B, B, stage.stageHeight - B * 2);
		skin.graphics.drawRect(0, stage.stageHeight - B, stage.stageWidth, B);
		skin.graphics.drawRect(0, B, B, stage.stageHeight - B * 2);
		skin.graphics.endFill();
		this.backgroundSkin = skin;
	}
}
