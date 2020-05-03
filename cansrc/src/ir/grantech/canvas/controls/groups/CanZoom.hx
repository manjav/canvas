package ir.grantech.canvas.controls.groups;

import feathers.controls.LayoutGroup;
import feathers.events.FeathersEvent;
import haxe.Timer;
import ir.grantech.canvas.drawables.CanItems;
import ir.grantech.canvas.drawables.ICanItem;
import ir.grantech.canvas.events.CanEvent;
import ir.grantech.canvas.services.BaseService;
import ir.grantech.canvas.services.Commands;
import ir.grantech.canvas.services.Inputs;
import ir.grantech.canvas.services.Layers;
import ir.grantech.canvas.services.Tools;
import openfl.display.DisplayObject;
import openfl.display.Shape;
import openfl.events.Event;
import openfl.ui.Mouse;
import openfl.ui.MouseCursor;

class CanZoom extends LayoutGroup {
	public var scene:CanScene;

	private var input:Inputs;

	override function initialize() {
		super.initialize();

		this.scene = new CanScene();
		this.addChild(this.scene);

		var background = new Shape();
		background.graphics.beginFill(0, 0);
		background.graphics.drawRect(0, 0, 100, 100);
		this.backgroundSkin = background;

		var commands = cast(BaseService.get(Commands), Commands);
		commands.addEventListener(Commands.ADDED, this.commands_addedHandler);
		commands.addEventListener(Commands.REMOVED, this.commands_removedHandler);
		commands.addEventListener(Commands.SELECT, this.commands_selectHandler);
		commands.addEventListener(Commands.ORDER, this.commands_orderHandler);

		commands.addEventListener(Commands.RESET, this.commands_itemsEventsHandler);
		commands.addEventListener(Commands.TRANSLATE, this.commands_itemsEventsHandler);
		commands.addEventListener(Commands.SCALE, this.commands_itemsEventsHandler);
		commands.addEventListener(Commands.ROTATE, this.commands_itemsEventsHandler);
		commands.addEventListener(Commands.RESIZE, this.commands_itemsEventsHandler);
		commands.addEventListener(Commands.RESET, this.commands_itemsEventsHandler);
		commands.addEventListener(Commands.ALIGN, this.commands_itemsEventsHandler);

		commands.addEventListener(Commands.ALPHA, this.commands_itemsEventsHandler);
		commands.addEventListener(Commands.VISIBLE, this.commands_itemsEventsHandler);
		commands.addEventListener(Commands.BLEND_MODE, this.commands_itemsEventsHandler);

		commands.addEventListener(Commands.FILL_ENABLED, this.commands_itemsEventsHandler);
		commands.addEventListener(Commands.FILL_COLOR, this.commands_itemsEventsHandler);
		commands.addEventListener(Commands.FILL_ALPHA, this.commands_itemsEventsHandler);
		commands.addEventListener(Commands.BORDER_ENABLED, this.commands_itemsEventsHandler);
		commands.addEventListener(Commands.BORDER_COLOR, this.commands_itemsEventsHandler);
		commands.addEventListener(Commands.BORDER_ALPHA, this.commands_itemsEventsHandler);

		commands.addEventListener(Commands.TEXT_ALIGN, this.commands_itemsEventsHandler);
		commands.addEventListener(Commands.TEXT_AUTOSIZE, this.commands_itemsEventsHandler);
		commands.addEventListener(Commands.TEXT_COLOR, this.commands_itemsEventsHandler);
		commands.addEventListener(Commands.TEXT_FONT, this.commands_itemsEventsHandler);
		commands.addEventListener(Commands.TEXT_LETTERPACE, this.commands_itemsEventsHandler);
		commands.addEventListener(Commands.TEXT_LINESPACE, this.commands_itemsEventsHandler);
		commands.addEventListener(Commands.TEXT_SIZE, this.commands_itemsEventsHandler);

		this.input = cast(BaseService.get(Inputs, [stage, this]), Inputs);
		this.input.addEventListener(Inputs.HIT, this.input_hitHandler);
		this.input.addEventListener(Inputs.PAN, this.input_panHandler);
		this.input.addEventListener(Inputs.ZOOM, this.input_zoomHandler);
		this.input.addEventListener(Inputs.POINT, this.input_pointHandler);
		this.input.addEventListener(Inputs.ZOOM_RESET, this.input_zoomHandler);

		this.addEventListener(FeathersEvent.CREATION_COMPLETE, this.creationCompleteHandler);
	}

	private function creationCompleteHandler(event:Event):Void {
		this.removeEventListener(FeathersEvent.CREATION_COMPLETE, this.creationCompleteHandler);
		Timer.delay(this.resetZoomAndPan, 0);
	}

	// ------ commands listeners ------
	private function commands_addedHandler(event:CanEvent):Void {
		this.scene.container.addChild(cast(event.data[0], DisplayObject));
	}

	private function commands_removedHandler(event:CanEvent):Void {
		cast(event.data[0], CanItems).deleteAll();
	}

	private function commands_selectHandler(event:CanEvent):Void {
		this.scene.transformHint.set(event.data[0]);
	}

	private function commands_orderHandler(event:CanEvent):Void {
		var layers = cast(event.data[2], Layers);
		var len = layers.length;
		for (i in 0...len)
			this.scene.container.setChildIndex(cast(layers.get(i).item, DisplayObject), len - i - 1);
	}

	private function commands_itemsEventsHandler(event:CanEvent):Void {
		var items = cast(event.data[0], CanItems);
		switch (event.type) {
			case Commands.TRANSLATE:
				items.translate(event.data[1], event.data[2]);
			case Commands.SCALE:
				items.scale(event.data[1], event.data[2]);
			case Commands.ROTATE:
				items.rotate(event.data[1]);
			case Commands.RESIZE:
				items.resize(event.data[1].x, event.data[1].y, event.data[1].width, event.data[1].height);
			case Commands.RESET:
				items.resetTransform();
			case Commands.ALIGN:
				items.align(event.data[1]);
			default:
				items.setProperty(event.type, event.data[1]);
		}
	}

	// ------ inputs listeners ------
	private function input_hitHandler(event:CanEvent):Void {
		this.scene.drawHit(event.data != null ? cast(event.data, ICanItem) : null);
	}

	private function input_panHandler(event:CanEvent):Void {
		if (this.input.panPhase == Inputs.PHASE_BEGAN)
			Mouse.cursor = MouseCursor.HAND;
		else if (this.input.panPhase == Inputs.PHASE_ENDED)
			Mouse.cursor = MouseCursor.AUTO;

		this.scene.x = this.input.pointX;
		this.scene.y = this.input.pointY;
	}

	private function input_zoomHandler(event:CanEvent):Void {
		if (event.type == Inputs.ZOOM_RESET)
			this.resetZoomAndPan();
		else
			this.setZoom(this.input.zoom);
	}

	@:access(ir.grantech.canvas.services.Inputs)
	private function input_pointHandler(event:CanEvent):Void {
		if (input.beganFrom == Inputs.TARGET_NONE)
			return;
		this.performSelection(input.pointPhase, input.beganFrom, input.selectedItems, input.shiftKey || input.ctrlKey);

		if (Tools.instance.toolType != Tool.SELECT)
			return;

		if (input.pointPhase == Inputs.PHASE_ENDED) {
			this.scene.transformHint.updateBounds();
			return;
		}

		if (this.input.selectedItems.isFill)
			this.scene.transformHint.perform(input.pointPhase);
	}

	@:access(ir.grantech.canvas.services.Inputs)
	function performSelection(pointPhase:Int, beganFrom:Int, selectedItems:CanItems, fixed:Bool):Void {
		if (beganFrom != Inputs.TARGET_SCENE || beganFrom == Inputs.TARGET_NONE)
			return;

		this.scene.updateSlection(input.pointPhase, fixed);
		if (pointPhase < Inputs.PHASE_ENDED || this.scene.selection.width < 10)
			return;

		var selectionBounds = this.scene.selection.getBounds(this.scene);
		if (Tools.instance.toolType == Tool.SELECT) {
			if (!Inputs.instance.shiftKey && !Inputs.instance.ctrlKey)
				selectedItems.removeAll(false);
			for (i in 0...this.scene.container.numChildren)
				if (selectionBounds.containsRect(this.scene.container.getChildAt(i).getBounds(this.scene)))
					selectedItems.add(cast(this.scene.container.getChildAt(i), ICanItem), false);
			selectedItems.calculateBounds();
			Commands.instance.commit(Commands.SELECT, [selectedItems]);
			return;
		}

		if (Tools.instance.toolType == Tool.RECTANGLE || Tools.instance.toolType == Tool.ELLIPSE || Tools.instance.toolType == Tool.TEXT)
			Commands.instance.commit(Commands.ADDED, [
				Tools.instance.toolType,
				input.selectedItems.getUInt(Commands.FILL_COLOR),
				input.selectedItems.getFloat(Commands.FILL_ALPHA),
				input.selectedItems.getFloat(Commands.BORDER_SIZE),
				input.selectedItems.getUInt(Commands.BORDER_COLOR),
				input.selectedItems.getFloat(Commands.BORDER_ALPHA),
				selectionBounds,
				0
			]);
	}

	private function setZoom(value:Float):Void {
		var w = this.scene.width;
		var h = this.scene.height;
		this.scene.scaleX = this.scene.scaleY = value;
		this.input.pointX = this.scene.x += (w - this.scene.width) * (mouseX / this._layoutMeasurements.width);
		this.input.pointY = this.scene.y += (h - this.scene.height) * (mouseY / this._layoutMeasurements.height);
	}

	public function resetZoomAndPan():Void {
		this.setZoom(1);
		this.scene.x = this.input.pointX = (this.explicitWidth - this.scene.canWidth) * 0.5;
		this.scene.y = this.input.pointY = (this.explicitHeight - this.scene.canHeight) * 0.5;
	}
}
