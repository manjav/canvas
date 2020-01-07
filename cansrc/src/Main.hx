package;

import feathers.controls.Application;
import feathers.controls.LayoutGroup;
import feathers.layout.HorizontalLayout;
import feathers.layout.HorizontalLayoutData;
import feathers.layout.VerticalAlign;
import feathers.style.Theme;
import ir.grantech.canvas.controls.groups.Bar;
import ir.grantech.canvas.controls.groups.ToolBar;
import ir.grantech.canvas.themes.CanTheme;
import openfl.events.Event;
import openfl.system.Capabilities;

class Main extends Application {
	private var left:ToolBar;
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
		this.addChild(this.left);

		this.right = new Bar();
		this.right.width = Capabilities.screenResolutionX * 0.15;
		this.addChild(this.right);

			return;


	}
}
