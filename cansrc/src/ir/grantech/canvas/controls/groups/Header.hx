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
	private var closeButton:Button;
	private var maximizeButton:Button;
	private var minimizeButton:Button;

	override private function initialize() {
		super.initialize();

		this.layout = new AnchorLayout();

		menuButton = this.createButton("humborger-menu", AnchorLayoutData.middleLeft(0, 3 * CanTheme.DPI));

		closeButton = this.createButton("header-close", AnchorLayoutData.middleRight(0, 3 * CanTheme.DPI));
		maximizeButton = this.createButton("header-maximize", AnchorLayoutData.middleRight(0, 24 * CanTheme.DPI));
		minimizeButton = this.createButton("header-minimize", AnchorLayoutData.middleRight(0, 48 * CanTheme.DPI));
	}

	override private function buttons_clickHandler(event:MouseEvent):Void {
		if (event.currentTarget == menuButton)
			CanEvent.dispatch(this, Event.INIT);
		else if (event.currentTarget == closeButton)
			CanEvent.dispatch(this, Event.CLOSE);
		else if (event.currentTarget == maximizeButton)
			this.maximize();
		else if (event.currentTarget == minimizeButton)
			this.minimize();
	}

	private function maximize():Void {
		this.maximizeButton.visible = false;
		this.restoreButton.visible = true;
		this.stage.window.maximized = true;
	}

	}

	private function minimize():Void {
		this.stage.window.minimized = true;
	}
}
