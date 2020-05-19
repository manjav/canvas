package ir.grantech.canvas.controls.groups;

import feathers.controls.Button;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;
import ir.grantech.canvas.controls.groups.sections.CanSection;
import ir.grantech.canvas.events.CanEvent;
import ir.grantech.canvas.themes.CanTheme;
import openfl.events.Event;
import openfl.events.MouseEvent;

class Header extends CanSection {
	private var menuButton:Button;

	override private function initialize() {
		super.initialize();

		this.layout = new AnchorLayout();

		menuButton = this.createButton("humborger-menu", new AnchorLayoutData(null, null, null, 3 * CanTheme.DPI, null, 0));
	}

	override private function buttons_clickHandler(event:MouseEvent):Void {
		if (event.currentTarget == menuButton)
			CanEvent.dispatch(this, Event.INIT);
	}
}
