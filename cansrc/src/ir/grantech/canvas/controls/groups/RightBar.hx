package ir.grantech.canvas.controls.groups;

import feathers.layout.VerticalLayoutData;
import ir.grantech.canvas.controls.groups.panels.AlignPanel;
import ir.grantech.canvas.controls.groups.panels.AppearPanel;
import ir.grantech.canvas.controls.groups.panels.FiltersPanel;
import ir.grantech.canvas.controls.groups.panels.TextPanel;
import ir.grantech.canvas.controls.groups.panels.TransformPanel;
import ir.grantech.canvas.drawables.CanItems;
import ir.grantech.canvas.events.CanEvent;
import ir.grantech.canvas.services.Commands;
import ir.grantech.canvas.services.Inputs;
import ir.grantech.canvas.services.Tools;
import ir.grantech.canvas.themes.CanTheme;
import openfl.events.Event;

class RightBar extends VGroup {
	private var textPanel:TextPanel;
	private var alignPanel:AlignPanel;
	private var appearPanel:AppearPanel;
	private var filtersPanel:FiltersPanel;
	private var transfromPanel:TransformPanel;

	override private function initialize() {
		super.initialize();
		this.padding = 0;
		this.gap = CanTheme.DPI;

		this.alignPanel = new AlignPanel();
		this.addChild(this.alignPanel);

		this.transfromPanel = new TransformPanel();
		this.addChild(this.transfromPanel);

		this.textPanel = new TextPanel();
		this.addChild(this.textPanel);

		this.appearPanel = new AppearPanel();
		this.addChild(this.appearPanel);

		this.filtersPanel = new FiltersPanel();
		this.filtersPanel.layoutData = new VerticalLayoutData(100, 100);
		this.addChild(this.filtersPanel);

		Inputs.instance.addEventListener(Inputs.POINT, this.input_pointHandler);
		this.commands.addEventListener(Commands.SELECT, this.commands_selectHandler);
		this.enabled = false;
	}

	private function input_pointHandler(event:Event):Void {
		if (Tools.instance.toolType != Tool.SELECT)
			return;
		if (Inputs.instance.pointPhase < Inputs.PHASE_ENDED)
			this.transfromPanel.updateData();
	}

	private function commands_selectHandler(event:CanEvent):Void {
		var items = cast(event.data[0], CanItems);
		this.enabled = items.filled;
		this.textPanel.targets = items;
		this.alignPanel.targets = items;
		this.appearPanel.targets = items;
		this.transfromPanel.targets = items;
	}
}
