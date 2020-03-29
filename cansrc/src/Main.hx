package;

import feathers.controls.Application;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;
import feathers.style.Theme;
import haxe.Timer;
import ir.grantech.canvas.controls.events.CanEvent;
import ir.grantech.canvas.controls.groups.CanZoom;
import ir.grantech.canvas.controls.groups.Panel;
import ir.grantech.canvas.controls.groups.RightBar;
import ir.grantech.canvas.controls.groups.ToolBar;
import ir.grantech.canvas.themes.CanTheme;
import openfl.display.StageQuality;
import openfl.display.StageScaleMode;

class Main extends Application {
	private var left:ToolBar;
	private var leftExtension:Panel;
	private var zoom:CanZoom;
	private var right:RightBar;
	private var zoomLayout:AnchorLayoutData;

	public function new() {
		stage.quality = StageQuality.BEST;
		stage.scaleMode = StageScaleMode.NO_SCALE;
		Theme.setTheme(new CanTheme());
		super();

		var p = CanTheme.DEFAULT_PADDING;
		this.layout = new AnchorLayout();

		this.zoom = new CanZoom();
		this.zoom.layoutData = this.zoomLayout = new AnchorLayoutData(p, 0, p);
		this.addChild(this.zoom);

		this.left = new ToolBar();
		this.left.width = CanTheme.DPI * 24;
		this.left.layoutData = new AnchorLayoutData(p, null, p, p);
		this.left.addEventListener("change", this.left_changeHandler);
		this.addChild(this.left);

		this.right = new RightBar();
		this.right.layoutData = new AnchorLayoutData(p, p, p, null);
		this.right.width = CanTheme.DPI * 144;
		this.addChild(this.right);

		this.leftExtension = new Panel();
		this.leftExtension.layoutData = new AnchorLayoutData(p, null, p, this.left.width + p * 2);
		this.leftExtension.width = CanTheme.DPI * 120;

		this.zoomLayout.right = this.right.width;
		this.zoomLayout.left = this.left.width + p * 2;
		// stage.addEventListener(Event.RESIZE, this.stage_resizeHandler);
	}

	private function left_changeHandler(event:CanEvent):Void {
		if (event.data.index == -1) {
			if (this.leftExtension != null && this.leftExtension.parent == this)
				this.removeChild(this.leftExtension);
			this.zoomLayout.left = this.left.width + CanTheme.DEFAULT_PADDING * 2;
		} else {
			this.addChild(this.leftExtension);
			this.zoomLayout.left = this.left.width + this.leftExtension.width + CanTheme.DEFAULT_PADDING * 3;
		}
		Timer.delay(this.zoom.resetZoomAndPan, 0);
	}
}
