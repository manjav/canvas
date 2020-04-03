package ir.grantech.canvas.controls.groups;

import feathers.layout.VerticalLayoutData;
import ir.grantech.canvas.controls.groups.panels.AppearPanel;
import ir.grantech.canvas.controls.groups.panels.FiltersPanel;
import ir.grantech.canvas.controls.groups.panels.TransformPanel;
import ir.grantech.canvas.themes.CanTheme;
import ir.grantech.canvas.services.Commands;
import ir.grantech.canvas.services.Inputs;
import ir.grantech.canvas.services.ToolsService;
import openfl.events.Event;

class RightBar extends VGroup {
	private var appearPanel:AppearPanel;
	private var filtersPanel:FiltersPanel;
	private var transfromPanel:TransformPanel;

	override private function initialize() {
		super.initialize();
		this.padding = 0;
		this.gap = CanTheme.DPI;

		this.transfromPanel = new TransformPanel();
		this.addChild(this.transfromPanel);

		this.appearPanel = new AppearPanel();
		this.addChild(this.appearPanel);

		this.filtersPanel = new FiltersPanel();
		this.filtersPanel.layoutData = new VerticalLayoutData(100, 100);
		this.addChild(this.filtersPanel);

		this.inputs.addEventListener(Inputs.POINT, this.input_pointHandler);
		this.commands.addEventListener(Commands.SELECT, this.commands_selectHandler);
		this.enabled = false;
	}

	private function input_pointHandler(event:Event):Void {
		if (ToolsService.instance.toolType != Tool.SELECT)
			return;
		if (this.inputs.pointPhase < Inputs.PHASE_UPDATE)
			this.appearPanel.updateData();
	}

	private function commands_selectHandler(event:Event):Void {
		this.enabled = inputs.selectedItem != null;
		if(!this.enabled)
			return;
		this.appearPanel.updateData();
		this.transfromPanel.updateData();	}
}
