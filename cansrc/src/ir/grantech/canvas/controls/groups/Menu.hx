package ir.grantech.canvas.controls.groups;

import feathers.controls.ListView;
import feathers.layout.AnchorLayout;
import feathers.skins.RectangleSkin;
import ir.grantech.canvas.controls.groups.sections.CanSection;
import motion.Actuate;

class Menu extends CanSection {
	private var listView:ListView;

	override private function initialize() {
		var skin = new RectangleSkin();
		skin.fill = SolidColor(0xFFFFFF);
		this.backgroundSkin = skin;

		this.layout = new AnchorLayout();
	}

	public function toggle() {
		if (this.visible) {
			Actuate.tween(this, 0.4, {x: -this.width}).onComplete((?p:Array<Dynamic>) -> {
				this.visible = false;
			});
			return;
		}
		this.visible = true;
		Actuate.tween(this, 0.4, {x: 0});
	}
}
