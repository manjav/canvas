package feathers.controls;

import openfl.events.MouseEvent;

class FixableCallout extends Callout {
	public var fixed:Bool;

	override private function callout_stage_mouseDownHandler(event:MouseEvent):Void {
		if (this.fixed || this.hitTestPoint(event.stageX, event.stageY)) {
			return;
		}
		this.close();
	}
}
