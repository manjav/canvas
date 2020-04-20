package feathers.controls.colors;

import ir.grantech.canvas.utils.Utils;
import openfl.Assets;
import feathers.core.InvalidationFlag;
import feathers.core.PopUpManager;
import feathers.layout.AnchorLayout;
import feathers.skins.RectangleSkin;
import feathers.style.Theme;
import openfl.display.Shape;
import openfl.geom.Matrix;
import ir.grantech.canvas.themes.CanTheme;
import lime.math.RGBA;
import openfl.display.GradientType;
import openfl.display.Sprite;
import openfl.events.MouseEvent;
import openfl.filters.GlowFilter;

class ColorPopup extends LayoutGroup {
	public var data(default, set):RGBA;

	private function set_data(value:RGBA):RGBA {
		if (this.data == value)
			return this.data;
		this.data = value;
		this.setInvalid(InvalidationFlag.DATA);
		return this.data;
	}

	private var roundness = CanTheme.DPI * 3;
	private var columnSize = CanTheme.DPI * 90;
	private var padding = CanTheme.DEFAULT_PADDING;

	private var matrixV:Matrix;
	private var matrixH:Matrix;
	private var hueSlider:Sprite;
	private var alphaSlider:Sprite;
	private var saturationSlider:Sprite;

	@:access(ir.grantech.canvas.themes.CanTheme)
	override private function initialize() {
		super.initialize();

		this.layout = new AnchorLayout();

		this.layout = new AnchorLayout();
		this.width = CanTheme.DPI * 140;
		this.height = CanTheme.DPI * 140;

		var theme = Std.downcast(Theme.getTheme(), CanTheme);
		var skin = new RectangleSkin();
		skin.cornerRadius = CanTheme.DPI * 4;
		skin.border = LineStyle.SolidColor(CanTheme.DPI * 0.5, theme.disabledTextColor);
		skin.fill = SolidColor(theme.controlFillColor1, 1);
		skin.filters = [new GlowFilter(0, 0.3, this.padding, this.padding, 1, 2)];
		this.backgroundSkin = skin;

		var innerGlow = new GlowFilter(0, 0.2, CanTheme.DPI * 2, CanTheme.DPI * 2, 1, 1, true);
		this.matrixH = new Matrix();
		this.matrixH.createGradientBox(this.columnSize, this.columnSize);
		this.matrixV = new Matrix();
		this.matrixV.createGradientBox(this.columnSize, this.columnSize, Math.PI * 0.5);

		// hue slider
		this.hueSlider = new Sprite();
		this.hueSlider.graphics.beginGradientFill(GradientType.LINEAR, [0xff0000, 0xffff00, 0x00ff00, 0x00ffff, 0x0000ff, 0xff00ff, 0xff0000],
			[1, 1, 1, 1, 1, 1, 1], [0, 43, 86, 129, 172, 212, 255], this.matrixV);
		this.hueSlider.graphics.drawRoundRect(0, 0, this.padding, this.columnSize, roundness, roundness);
		this.hueSlider.x = this.columnSize + this.padding * 2;
		this.hueSlider.y = this.padding;
		this.hueSlider.filters = [innerGlow];
		this.addChild(this.hueSlider);

		// alpha slider
		var alphaContainer:Sprite = new Sprite();
		alphaContainer.graphics.beginBitmapFill(Assets.getBitmapData("transparent"));
		alphaContainer.graphics.drawRoundRect(0, 0, this.padding, this.columnSize, roundness, roundness);
		alphaContainer.x = this.columnSize + this.padding * 4;
		alphaContainer.y = this.padding;
		alphaContainer.filters = [innerGlow];
		this.addChild(alphaContainer);

		this.alphaSlider = new Sprite();
		alphaContainer.addChild(this.alphaSlider);

		// saturation / value slider
		var saturationContainer:Sprite = new Sprite();
		saturationContainer.graphics.beginFill(0xFFFFFF);
		saturationContainer.graphics.drawRoundRect(0, 0, this.columnSize, this.columnSize, roundness, roundness);
		saturationContainer.x = saturationContainer.y = this.padding;
		saturationContainer.filters = [innerGlow];
		this.addChild(saturationContainer);

		this.saturationSlider = new Sprite();
		saturationContainer.addChild(this.saturationSlider);

		var valueGradient = new Shape();
		valueGradient.graphics.beginGradientFill(GradientType.LINEAR, [0, 0], [0, 1], [0, 0xFF], this.matrixV);
		valueGradient.graphics.drawRoundRect(0, 0, this.columnSize, this.columnSize, roundness, roundness);
		saturationContainer.addChild(valueGradient);

		this.stage.addEventListener(MouseEvent.MOUSE_DOWN, this.stage_mouseDownHandler);
	}

	private function stage_mouseDownHandler(event:MouseEvent):Void {
		this.stage.removeEventListener(MouseEvent.MOUSE_DOWN, this.stage_mouseDownHandler);
		// point outside detection
		var b = this.getBounds(stage);
		if (!b.contains(event.stageX, event.stageY)) {
			PopUpManager.removePopUp(this);
			return;
		}

		this.addEventListener(MouseEvent.MOUSE_MOVE, this.mouseMoveHandler);
		stage.addEventListener(MouseEvent.MOUSE_UP, this.stage_mouseUpHandler);
	}

	private function mouseMoveHandler(event:MouseEvent):Void {
		event.updateAfterEvent();
	}

	private function stage_mouseUpHandler(event:MouseEvent):Void {
		if (stage != null)
			this.stage.addEventListener(MouseEvent.MOUSE_DOWN, this.stage_mouseDownHandler);
		this.removeEventListener(MouseEvent.MOUSE_MOVE, this.mouseMoveHandler);
	}

	private function hueUI(color:UInt):Void {
		this.saturationSlider.graphics.clear();
		this.saturationSlider.graphics.beginGradientFill(GradientType.LINEAR, [color, color], [0, 1], [0, 0xFF], this.matrixH);
		this.saturationSlider.graphics.drawRoundRect(0, 0, this.columnSize, this.columnSize, roundness, roundness);
	}

	private function saturateUI(color:UInt):Void {
		this.alphaSlider.graphics.clear();
		this.alphaSlider.graphics.beginGradientFill(GradientType.LINEAR, [color, color], [1, 0], [0, 0xFF], this.matrixV);
		this.alphaSlider.graphics.drawRoundRect(0, 0, this.padding, this.columnSize, roundness, roundness);
	}
}
