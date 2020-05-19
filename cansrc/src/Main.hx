package;

import feathers.controls.Application;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;
import feathers.style.Theme;
import flash.system.Capabilities;
import haxe.Timer;
import ir.grantech.canvas.controls.groups.CanZoom;
import ir.grantech.canvas.controls.groups.Header;
import ir.grantech.canvas.controls.groups.Menu;
import ir.grantech.canvas.controls.groups.RightBar;
import ir.grantech.canvas.controls.groups.ToolBar;
import ir.grantech.canvas.controls.groups.sections.AssetsSection;
import ir.grantech.canvas.controls.groups.sections.CanSection;
import ir.grantech.canvas.controls.groups.sections.LayersSection;
import ir.grantech.canvas.events.CanEvent;
import ir.grantech.canvas.services.BaseService;
import ir.grantech.canvas.services.Libs;
import ir.grantech.canvas.themes.CanTheme;
import openfl.display.StageQuality;
import openfl.display.StageScaleMode;
import openfl.events.Event;

class Main extends Application {
	private var menu:Menu;
	private var zoom:CanZoom;
	private var header:Header;
	private var left:ToolBar;
	private var right:RightBar;
	private var leftExtension:CanSection;
	private var extensions:Map<Int, CanSection>;
	private var zoomLayout:AnchorLayoutData;

	public function new() {
		Theme.setTheme(new CanTheme());
		var h = Math.round(Capabilities.screenResolutionY * 0.08) * 10;
		var w = Math.round(Capabilities.screenResolutionY * 0.08) * 15;
		stage.quality = StageQuality.BEST;
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.window.x = stage.window.y = Math.round((Capabilities.screenResolutionY * 0.95 - h) / 2);
		stage.window.width = w;
		stage.window.height = h;
		BaseService.get(Libs, [stage]);
		super();

		var p = CanTheme.DPI;
		this.layout = new AnchorLayout();
		this.extensions = new Map<Int, CanSection>();
		this.zoom = new CanZoom();
		this.zoom.layoutData = this.zoomLayout = new AnchorLayoutData(0, 0, p);
		this.addChild(this.zoom);

		var h = CanTheme.DPI * 20 + p * 2;

		this.left = new ToolBar();
		this.left.width = CanTheme.DPI * 24;
		this.left.layoutData = new AnchorLayoutData(h, null, p, p);
		this.left.addEventListener("change", this.left_changeHandler);
		this.addChild(this.left);

		this.right = new RightBar();
		this.right.layoutData = new AnchorLayoutData(h, p, p, null);
		this.right.width = CanTheme.DPI * 144;
		this.addChild(this.right);

		this.zoomLayout.top = h;
		this.zoomLayout.right = this.right.width + p;
		this.zoomLayout.left = this.left.width + p * 2;
		// stage.addEventListener(Event.RESIZE, this.stage_resizeHandler);

		this.header = new Header();
		this.header.height = h - p * 2;
		this.header.layoutData = new AnchorLayoutData(p, p, null, p);
		this.header.addEventListener(Event.INIT, this.header_initHandler);
		this.addChild(this.header);

		this.menu = new Menu();
		this.menu.layoutData = AnchorLayoutData.fill();
		this.addChild(this.menu);
	}

	// private static var getDesktopResolution = System.load("SomeHeaderFile.h", "GetDesktopResolution", 2);

	private function header_initHandler(event:Event):Void {
		this.menu.open();
	}

	private function left_changeHandler(event:CanEvent):Void {
		if (this.leftExtension != null && this.leftExtension.parent == this)
			this.removeChild(this.leftExtension);
		if (event.data == -1) {
			this.zoomLayout.left = this.left.width + CanTheme.DPI * 2;
		} else {
			this.leftExtension = this.createSection(event.data);
			this.addChild(this.leftExtension);
			this.zoomLayout.left = this.left.width + this.leftExtension.width + CanTheme.DPI * 3;
		}
		Timer.delay(this.zoom.resetZoomAndPan, 0);
	}

	private function createSection(index:Int):CanSection {
		if (!this.extensions.exists(index)) {
			var p = CanTheme.DPI * 2;
			var pnl:CanSection = index == 0 ? new LayersSection() : new AssetsSection();
			pnl.layoutData = new AnchorLayoutData(this.header.height + p, null, CanTheme.DPI, this.left.width + p);
			pnl.width = CanTheme.DPI * 120;
			this.extensions.set(index, pnl);
		}
		return this.extensions.get(index);
	}
}
