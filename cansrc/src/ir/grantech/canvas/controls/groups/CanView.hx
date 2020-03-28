package ir.grantech.canvas.controls.groups;

import ir.grantech.services.InputService;
import feathers.controls.LayoutGroup;

class CanView extends LayoutGroup {

	public var input(get, null):InputService;

	private function get_input():InputService {
		return InputService.instance;
	}
}