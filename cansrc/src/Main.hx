package;

import feathers.controls.Application;
import feathers.controls.LayoutGroup;
import feathers.layout.HorizontalLayout;
import feathers.layout.HorizontalLayoutData;
import feathers.layout.VerticalAlign;
import feathers.style.Theme;
import ir.grantech.canvas.controls.events.CanEvent;
import ir.grantech.canvas.controls.groups.Bar;
import ir.grantech.canvas.controls.groups.CanZoom;
import ir.grantech.canvas.controls.groups.ToolBar;
import ir.grantech.canvas.themes.CanTheme;
import openfl.display.StageQuality;
import openfl.display.StageScaleMode;

class Main extends Application {
	private var left:ToolBar;
	private var leftExtension:LayoutGroup;
	private var zoom:CanZoom;
	private var right:Bar;

	public function new() {
		stage.quality = StageQuality.BEST;
		stage.scaleMode = StageScaleMode.NO_SCALE;
		Theme.setTheme(new CanTheme());
		super();

		// BaseService.get(KeyBoardService, [stage]);
		var layout = new HorizontalLayout();
		layout.verticalAlign = VerticalAlign.JUSTIFY;
		layout.gap = layout.paddingTop = CanTheme.DEFAULT_PADDING;
		this.layout = layout;

		this.left = new ToolBar();
		this.left.width = CanTheme.DPI * 24;
		this.left.addEventListener("change", this.left_changeHandler);
		this.addChild(this.left);

		this.zoom = new CanZoom();
		this.zoom.layoutData = new HorizontalLayoutData(100);
		this.addChild(this.zoom);

		this.right = new Bar();
		this.right.width = CanTheme.DPI * 144;
		this.addChild(this.right);

		this.leftExtension = new Bar();
		this.leftExtension.width = CanTheme.DPI * 120;

		// stage.addEventListener(Event.RESIZE, this.stage_resizeHandler);
	}

	private function left_changeHandler(event:CanEvent):Void {
		if (this.leftExtension != null && this.leftExtension.parent == this)
			this.removeChild(this.leftExtension);

		if (event.data.index == -1)
			return;

		this.addChildAt(this.leftExtension, 0);
	}
}
