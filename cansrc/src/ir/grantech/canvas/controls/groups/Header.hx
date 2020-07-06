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
	private var restoreButton:Button;

	override private function initialize() {
		super.initialize();

		this.layout = new AnchorLayout();

		this.menuButton = this.createButton("humborger-menu", AnchorLayoutData.middleLeft(0, 3 * CanTheme.DPI));

		var w = 22 * CanTheme.DPI;
		this.closeButton = this.createButton("header-close", AnchorLayoutData.middleRight(0, 3 * CanTheme.DPI));
		this.maximizeButton = this.createButton("header-maximize", AnchorLayoutData.middleRight(0, 24 * CanTheme.DPI));
		this.maximizeButton.width = w;
		this.minimizeButton = this.createButton("header-minimize", AnchorLayoutData.middleRight(0, 48 * CanTheme.DPI));
		this.minimizeButton.width = w;
		this.restoreButton = this.createButton("header-restore", AnchorLayoutData.middleRight(0, 24 * CanTheme.DPI));
		this.restoreButton.width = w;
		this.restoreButton.visible = false;

		closeButton = this.createButton("header-close", AnchorLayoutData.middleRight(0, 3 * CanTheme.DPI));
		maximizeButton = this.createButton("header-maximize", AnchorLayoutData.middleRight(0, 24 * CanTheme.DPI)); maximizeButton.width = w;
		minimizeButton = this.createButton("header-minimize", AnchorLayoutData.middleRight(0, 48 * CanTheme.DPI)); minimizeButton.width = w;
		restoreButton = this.createButton("header-restore", AnchorLayoutData.middleRight(0, 24 * CanTheme.DPI)); restoreButton.width = w;
		restoreButton.visible = false;

		this.stage.window.resizable = true;
		this.stage.window.borderless = true;
	}

	override private function buttons_clickHandler(event:MouseEvent):Void {
		if (event.currentTarget == this.menuButton)
			CanEvent.dispatch(this, Event.INIT);
		else if (event.currentTarget == this.closeButton)
			CanEvent.dispatch(this, Event.CLOSE);
		else if (event.currentTarget == this.maximizeButton)
			this.maximize();
		else if (event.currentTarget == this.minimizeButton)
			this.minimize();
		else if (event.currentTarget == this.restoreButton)
			this.restore();
	}

	private function maximize():Void {
		this.maximizeButton.visible = false;
		this.restoreButton.visible = true;
		this.stage.window.maximized = true;
	}

	private function restore():Void {
		this.restoreButton.visible = false;
		this.maximizeButton.visible = true;
		this.stage.window.maximized = false;
	}

	private function minimize():Void {
		this.stage.window.minimized = true;
	}
}
