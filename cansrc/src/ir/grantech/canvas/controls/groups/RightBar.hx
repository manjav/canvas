package ir.grantech.canvas.controls.groups;

import ir.grantech.canvas.controls.groups.panels.TransformPanel;
import ir.grantech.services.InputService;
import ir.grantech.services.ToolsService;
import openfl.events.Event;

class RightBar extends VGroup {
	private var transfromPanel:TransformPanel;

	override private function initialize() {
		super.initialize();

		this.transfromPanel = new TransformPanel();
		this.addChild(this.transfromPanel);

		this.inputService.addEventListener(InputService.SELECT, this.input_selectHandler);
		this.inputService.addEventListener(InputService.POINT, this.input_pointHandler);
		this.enabled = false;
	}

	private function input_pointHandler(event:Event):Void {
		if (this.inputService.pointPhase >= InputService.PHASE_UPDATE && ToolsService.instance.toolType == Tool.SELECT)
			this.transfromPanel.updateData();
	}

	private function input_selectHandler(event:Event):Void {
		this.enabled = inputService.selectedItem != null;
	}
}
