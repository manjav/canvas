package ir.grantech.canvas.controls.groups;

import feathers.controls.Button;
import feathers.controls.LayoutGroup;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;
import feathers.skins.RectangleSkin;
import ir.grantech.canvas.controls.groups.sections.CanSection;
import ir.grantech.canvas.themes.CanTheme;
import ir.grantech.canvas.themes.RectSkin;
import openfl.display.Shape;
import openfl.events.MouseEvent;
import openfl.ui.Mouse;
import openfl.ui.MouseCursor;

class Border extends LayoutGroup {
	static final B:Int = Math.floor(CanTheme.DPI * 1.6);
	static final CURSORS:Array<String> = [
		"resize_nwse",
		"resize_ns",
		"resize_nesw",
		"resize_we",
		"auto",
		"resize_we",
		"resize_nesw",
		"resize_ns",
		"resize_nwse"
	];
	private var side:Int;

	override private function initialize():Void {
		super.initialize();

		this.layoutData = AnchorLayoutData.fill();
		this.layout = new AnchorLayout();

		var skin = new Shape();
		skin.graphics.beginFill(0xFF, 0);
		skin.graphics.drawRect(0, 0, stage.stageWidth, B);
		skin.graphics.drawRect(stage.stageWidth - B, B, B, stage.stageHeight - B * 2);
		skin.graphics.drawRect(0, stage.stageHeight - B, stage.stageWidth, B);
		skin.graphics.drawRect(0, B, B, stage.stageHeight - B * 2);
		skin.graphics.endFill();
		this.backgroundSkin = skin;

		this.addEventListener(MouseEvent.MOUSE_DOWN, this.borders_mouseDownHandler);
		this.addEventListener(MouseEvent.MOUSE_MOVE, this.borders_mouseMoveHandler);
		this.addEventListener(MouseEvent.MOUSE_OUT, this.borders_mouseOutHandler);
	}

	private function borders_mouseMoveHandler(event:MouseEvent):Void {
		event.updateAfterEvent();
		if (event.stageY < B) {
			if (event.stageX < B)
				this.side = 0;
			else if (event.stageX > stage.stageWidth - B)
				this.side = 2;
			else
				this.side = 1;
		} else if (event.stageY > stage.stageHeight - B) {
			if (event.stageX < B)
				this.side = 6;
			else if (event.stageX > stage.stageWidth - B)
				this.side = 8;
			else
				this.side = 7;
		} else {
			if (event.stageX < B)
				this.side = 3;
			else if (event.stageX > stage.stageWidth - B)
				this.side = 5;
			else
				this.side = 4;
		}
		#if desktop
		Mouse.cursor = CURSORS[side];
		#end
	}

	private function borders_mouseOutHandler(event:MouseEvent):Void {
		Mouse.cursor = MouseCursor.AUTO;
	}

	private function borders_mouseDownHandler(event:MouseEvent):Void {
		this.removeEventListener(MouseEvent.MOUSE_OUT, this.borders_mouseOutHandler);
		this.removeEventListener(MouseEvent.MOUSE_MOVE, this.borders_mouseMoveHandler);
		this.removeEventListener(MouseEvent.MOUSE_DOWN, this.borders_mouseDownHandler);
		stage.addEventListener(MouseEvent.MOUSE_UP, this.borders_mouseUpHandler);
		stage.window.onMouseMoveRelative.add(windowMouseMove);
	}

	private function borders_mouseUpHandler(event:MouseEvent):Void {
		this.addEventListener(MouseEvent.MOUSE_OUT, this.borders_mouseOutHandler);
		this.addEventListener(MouseEvent.MOUSE_MOVE, this.borders_mouseMoveHandler);
		this.addEventListener(MouseEvent.MOUSE_DOWN, this.borders_mouseDownHandler);
		stage.removeEventListener(MouseEvent.MOUSE_UP, this.borders_mouseUpHandler);
		Mouse.cursor = MouseCursor.AUTO;
	}
}
