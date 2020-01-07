package;

import feathers.controls.Application;
import feathers.controls.LayoutGroup;
import feathers.layout.HorizontalLayout;
import feathers.layout.HorizontalLayoutData;
import feathers.layout.VerticalAlign;
import feathers.style.Theme;
import ir.grantech.canvas.controls.events.CanEvent;
import ir.grantech.canvas.controls.groups.Bar;
import ir.grantech.canvas.controls.groups.CanVas;
import ir.grantech.canvas.controls.groups.ToolBar;
import ir.grantech.canvas.themes.CanTheme;
import openfl.system.Capabilities;

class Main extends Application {
	private var left:ToolBar;
	private var leftExtension:LayoutGroup;
	private var canvas:CanVas;
	private var right:Bar;

	public function new() {
		Theme.setTheme(new CanTheme());
		super();

		var layout = new HorizontalLayout();
		layout.verticalAlign = VerticalAlign.JUSTIFY;
		layout.gap = layout.paddingTop = layout.paddingRight = layout.paddingBottom = layout.paddingLeft = CanTheme.DEFAULT_PADDING;
		this.layout = layout;

		this.left = new ToolBar();
		this.left.width = Capabilities.screenResolutionX * 0.03;
		this.left.addEventListener("change", this.left_changeHandler);
		this.addChild(this.left);

		this.canvas = new CanVas();
		this.canvas.layoutData = new HorizontalLayoutData(100);
		this.addChild(this.canvas);

		this.right = new Bar();
		this.right.width = Capabilities.screenResolutionX * 0.15;
		this.addChild(this.right);

		// stage.addEventListener(Event.RESIZE, this.stage_resizeHandler);
	}

	private function left_changeHandler(event:CanEvent):Void {
		if( this.leftExtension != null && this.leftExtension.parent == this)
			this.removeChild(this.leftExtension);

		if(event.data.index == -1)
			return;

		this.leftExtension = new Bar();
		this.leftExtension.width = Capabilities.screenResolutionX * 0.15;
		this.addChildAt(this.leftExtension, 0);
	}
}
