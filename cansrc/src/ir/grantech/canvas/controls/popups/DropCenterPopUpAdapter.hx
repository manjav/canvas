package ir.grantech.canvas.controls.popups;

import feathers.controls.popups.DropDownPopUpAdapter;
import feathers.core.IValidating;
import feathers.core.PopUpManager;
import flash.geom.Point;

/**
	Displays a pop-up like a drop-down, either center the source.

	@since 1.0.0
**/
class DropCenterPopUpAdapter extends DropDownPopUpAdapter {
	private var height:Float = 480;

	public function new(height:Float) {
		super();
		this.height = height;
	}

	override private function layout():Void {
		if (Std.is(this.origin, IValidating))
			cast(this.origin, IValidating).validateNow();

		var popUpRoot = PopUpManager.forStage(this.origin.stage).root;

		var originTopLeft = new Point(this.origin.x, this.origin.y);
		originTopLeft = origin.parent.localToGlobal(originTopLeft);
		originTopLeft = popUpRoot.globalToLocal(originTopLeft);

		var originBottomRight = new Point(this.origin.x + this.origin.width, this.origin.y + this.origin.height);
		originBottomRight = origin.parent.localToGlobal(originBottomRight);
		originBottomRight = popUpRoot.globalToLocal(originBottomRight);

		this.content.x = originTopLeft.x;
		this.content.y = originTopLeft.y - this.height * 0.5;
		this.content.width = originBottomRight.x - originTopLeft.x;
		this.content.height = this.height;
	}
}
