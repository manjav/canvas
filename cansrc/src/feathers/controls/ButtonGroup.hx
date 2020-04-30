package feathers.controls;

import feathers.layout.HorizontalListLayout;
import feathers.utils.DisplayObjectRecycler;
import flash.display.DisplayObject;
import ir.grantech.canvas.controls.items.ButtonGroupRenderer;

class ButtonGroup extends ListView {
	public function new() {
		super();

		this.layout = new HorizontalListLayout();
		this.variant = ListView.VARIANT_BORDERLESS;
		this.itemRendererRecycler = DisplayObjectRecycler.withClass(ButtonGroupRenderer);
	}

	override private function refreshScrollRect():Void {}

	override private function refreshBackgroundSkin():Void {}

	override private function createItemRenderer(item:Dynamic, index:Int):DisplayObject {
		var itemRenderer = super.createItemRenderer(item, index);
		var buttonRenderer = cast(itemRenderer, ButtonGroupRenderer);
		buttonRenderer.index = index;
		buttonRenderer.owner = this;
		buttonRenderer.draw();
		return itemRenderer;
	}
}
