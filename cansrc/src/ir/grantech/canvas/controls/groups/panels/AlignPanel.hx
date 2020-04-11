package ir.grantech.canvas.controls.groups.panels;

import feathers.controls.Button;
import feathers.layout.HorizontalLayout;
import feathers.layout.VerticalAlign;
import ir.grantech.canvas.drawables.CanItems;
import ir.grantech.canvas.services.Commands;
import ir.grantech.canvas.themes.CanTheme;
import openfl.display.InteractiveObject;
import openfl.events.MouseEvent;

class AlignPanel extends Panel {
	private var alignT:Button;
	private var alignM:Button;
	private var alignB:Button;
	private var alignL:Button;
	private var alignC:Button;
	private var alignR:Button;
	private var distrH:Button;
	private var distrV:Button;

	override private function set_targets(value:CanItems):CanItems {
		super.set_targets(value);
		distrH.enabled = value.length > 2;
		distrV.enabled = value.length > 2;
		return value;
	}

	override private function initialize() {
		super.initialize();

		var layout = new HorizontalLayout();
		layout.verticalAlign = VerticalAlign.JUSTIFY;
		layout.gap = layout.paddingLeft = layout.paddingRight = Math.floor(CanTheme.DEFAULT_PADDING * 0.3);
		this.layout = layout;

		this.alignT = this.createButton("align-t", null);
		this.alignM = this.createButton("align-m", null);
		this.alignB = this.createButton("align-b", null);
		this.alignL = this.createButton("align-l", null);
		this.alignC = this.createButton("align-c", null);
		this.alignR = this.createButton("align-r", null);
		this.distrH = this.createButton("distr-h", null);
		this.distrV = this.createButton("distr-v", null);

		this.height = padding * 4;
	}

	override private function buttons_clickHandler(event:MouseEvent):Void {
		var name = cast(event.currentTarget, InteractiveObject).name;
		Commands.instance.commit(Commands.ALIGN, [this.targets, name]);
	}
}
