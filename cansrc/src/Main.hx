package;

import feathers.controls.Application;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;
import feathers.style.Theme;
import haxe.Timer;
import ir.grantech.canvas.controls.events.CanEvent;
import ir.grantech.canvas.controls.groups.CanZoom;
import ir.grantech.canvas.controls.groups.RightBar;
import ir.grantech.canvas.controls.groups.ToolBar;
import ir.grantech.canvas.controls.groups.panels.AssetsPanel;
import ir.grantech.canvas.controls.groups.panels.LayersPanel;
import ir.grantech.canvas.controls.groups.panels.Panel;
import ir.grantech.canvas.themes.CanTheme;
import ir.grantech.services.BaseService;
import openfl.display.StageQuality;
import openfl.display.StageScaleMode;

class Main extends Application {
	private var zoom:CanZoom;
	private var header:Panel;
	private var right:RightBar;
	private var left:ToolBar;
	private var leftExtension:Panel;
	private var extensions:Map<Int, Panel>;
	private var zoomLayout:AnchorLayoutData;

	public function new() {
		stage.quality = StageQuality.BEST;
		stage.scaleMode = StageScaleMode.NO_SCALE;
		Theme.setTheme(new CanTheme());
		super();

		var p = CanTheme.DPI;
		this.layout = new AnchorLayout();
		this.extensions = new Map<Int, Panel>();
		this.zoom = new CanZoom();
		this.zoom.layoutData = this.zoomLayout = new AnchorLayoutData(0, 0, p);
		this.addChild(this.zoom);

		this.header = new Panel();
		this.header.height = CanTheme.DPI * 20;
		this.header.layoutData = new AnchorLayoutData(p, p, null, p);
		this.addChild(this.header);

		var h = this.header.height + p * 2;

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
	}

	private function left_changeHandler(event:CanEvent):Void {
		if (this.leftExtension != null && this.leftExtension.parent == this)
			this.removeChild(this.leftExtension);
		if (event.data.index == -1) {
			this.zoomLayout.left = this.left.width + CanTheme.DPI * 2;
		} else {
			this.leftExtension = this.createPanel(event.data.index);
			this.addChild(this.leftExtension);
			this.zoomLayout.left = this.left.width + this.leftExtension.width + CanTheme.DPI * 3;
		}
		Timer.delay(this.zoom.resetZoomAndPan, 0);
	}

	private function createPanel(index:Int):Panel {
		if (!this.extensions.exists(index)) {
			var p = CanTheme.DPI * 2;
			var pnl:Panel = index == 0 ? new LayersPanel() : new AssetsPanel();
			pnl.layoutData = new AnchorLayoutData(this.header.height + p, null, CanTheme.DPI, this.left.width + p);
			pnl.width = CanTheme.DPI * 120;
			this.extensions.set(index, pnl);
		}
		return this.extensions.get(index);
	}
}
