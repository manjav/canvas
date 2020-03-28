package ir.grantech.canvas.controls.groups;

import openfl.events.Event;
import ir.grantech.canvas.themes.CanTheme;
import ir.grantech.services.InputService;

class RightBar extends VGroup {
  override private function initialize() {
    super.initialize();
    this.padding = this.gap = CanTheme.DEFAULT_PADDING;
		this.input.addEventListener(InputService.SELECT, this.input_selectHandler);
	}
  
  private function input_selectHandler(event:Event):Void {
    trace(event, input.selectedItem);
  }
}
