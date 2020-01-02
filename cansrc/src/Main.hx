package;

import feathers.controls.Application;
import feathers.controls.Label;
import feathers.controls.LayoutGroup;
import feathers.controls.Panel;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;
import feathers.style.Theme;
import ir.grantech.canvas.controls.groups.Bar;
import ir.grantech.canvas.themes.CanTheme;
import openfl.events.Event;
import openfl.system.Capabilities;

class Main extends Application {
	private var panel:Panel;
	private var left:Bar;
	private var right:Bar;
	public function new() {
		Theme.setTheme(new CanTheme());
		super();
		this.layout = new AnchorLayout();

		this.left = new Bar();
		this.left.width = Capabilities.screenResolutionX * 0.04;
		this.left.layoutData = new AnchorLayoutData(0, null, 0, 0);
		this.addChild(this.left);

		this.right = new Bar();
		this.right.width = Capabilities.screenResolutionX * 0.15;
		this.right.layoutData = new AnchorLayoutData(0, 0, 0, null);
		this.addChild(this.right);

return;
		this.panel = new Panel();
		this.panel.layoutData = AnchorLayoutData.center();
		this.panel.headerFactory = () -> {
			var header = new LayoutGroup();
			header.variant = LayoutGroup.VARIANT_TOOL_BAR;
			var title = new Label();
			title.text = "Header";
			header.addChild(title);
			return header;
		};
		this.panel.footerFactory = () -> {
			var footer = new LayoutGroup();
			footer.variant = LayoutGroup.VARIANT_TOOL_BAR;
			var title = new Label();
			title.text = "Footer";
			footer.addChild(title);
			return footer;
		};
		this.panel.layout = new AnchorLayout();
		var message = new Label();
		message.text = "I'm a Panel container";
		message.layoutData = AnchorLayoutData.fill(10.0);
		this.panel.addChild(message);
		this.addChild(this.panel);

		stage.addEventListener(Event.RESIZE, stage_resizeHandler);
	}
	private function stage_resizeHandler(event:Event):Void {}
}
