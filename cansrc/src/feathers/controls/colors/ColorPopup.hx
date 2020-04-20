package feathers.controls.colors;

import feathers.core.InvalidationFlag;
import feathers.layout.AnchorLayout;
import feathers.skins.RectangleSkin;
import feathers.style.Theme;
import ir.grantech.canvas.themes.CanTheme;
import ir.grantech.canvas.utils.Utils;
import lime.math.RGBA;
import openfl.Assets;
import openfl.display.GradientType;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.filters.GlowFilter;
import openfl.geom.Matrix;

class ColorPopup extends LayoutGroup {
	public var data(default, set):RGBA;

	private function set_data(value:RGBA):RGBA {
		if (this.data == value)
			return value;
		this.data = value;
		if (this.hasEventListener(Event.CHANGE))
			this.dispatchEvent(new Event(Event.CHANGE));
		this.setInvalid(InvalidationFlag.DATA);
		return value;
	}

	private var activeSlider:Int = -1;
	private var _hue:Float = 0;
	private var _alpha:Float = 1.0;
	private var _saturation:Float = 100;
	private var _value:Float = 100;
	private var roundness = CanTheme.DPI * 3;
	private var columnSize = CanTheme.DPI * 90;
	private var padding = CanTheme.DEFAULT_PADDING;

	private var matrixV:Matrix;
	private var matrixH:Matrix;
	private var hueSlider:Sprite;
	private var alphaSlider:Shape;
	private var saturationSlider:Shape;

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

		this.alphaSlider = new Shape();
		alphaContainer.addChild(this.alphaSlider);

		// saturation / value slider
		var saturationContainer:Sprite = new Sprite();
		saturationContainer.graphics.beginFill(0xFFFFFF);
		saturationContainer.graphics.drawRoundRect(0, 0, this.columnSize, this.columnSize, roundness, roundness);
		saturationContainer.x = saturationContainer.y = this.padding;
		saturationContainer.filters = [innerGlow];
		this.addChild(saturationContainer);

		this.saturationSlider = new Shape();
		saturationContainer.addChild(this.saturationSlider);

		var valueGradient = new Shape();
		valueGradient.graphics.beginGradientFill(GradientType.LINEAR, [0, 0], [0, 1], [0, 0xFF], this.matrixV);
		valueGradient.graphics.drawRoundRect(0, 0, this.columnSize, this.columnSize, roundness, roundness);
		saturationContainer.addChild(valueGradient);

		this.addEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownHandler);
	}

		}
	
	private function mouseDownHandler(event:MouseEvent):Void {
		this.removeEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownHandler);

		if (this.saturationSlider.mouseX >= 0
			&& this.saturationSlider.mouseX <= this.columnSize
			&& this.saturationSlider.mouseY >= 0
			&& this.saturationSlider.mouseY <= this.columnSize)
			this.activeSlider = 0;
		else if (this.hueSlider.mouseX >= 0
			&& this.hueSlider.mouseX <= this.padding
			&& this.hueSlider.mouseX >= 0
			&& this.hueSlider.mouseX <= this.columnSize)
			this.activeSlider = 1;
		else if (this.alphaSlider.mouseX >= 0
			&& this.alphaSlider.mouseX <= this.padding
			&& this.alphaSlider.mouseX >= 0
			&& this.alphaSlider.mouseX <= this.columnSize)
			this.activeSlider = 2;
		else
			this.activeSlider = -1;

		this.addEventListener(MouseEvent.MOUSE_MOVE, this.mouseMoveHandler);
		stage.addEventListener(MouseEvent.MOUSE_UP, this.stage_mouseUpHandler);
	}

	private function mouseMoveHandler(event:MouseEvent):Void {
		var x = 0.0, y = 0.0;
		if (this.activeSlider == 0) {
			x = Math.max(0, Math.min(1, this.saturationSlider.mouseX / this.columnSize));
			y = Math.max(0, Math.min(1, this.saturationSlider.mouseY / this.columnSize));
			this._saturation = x * 100;
			this._value = 100 - y * 100;
			this.data = Utils.HSVAtoRGBA(this._hue, this._saturation, this._value, this._alpha);
			// trace("sv", this._saturation, this._value, StringTools.hex(this.data, 8));
		} else if (this.activeSlider == 1) {
			this._hue = Math.round(Math.max(0, Math.min(1, this.hueSlider.mouseY / this.columnSize)) * 360);
			this.data = Utils.HSVAtoRGBA(this._hue, this._saturation, this._value, this._alpha);
			this.hueUI(Utils.RGBA2RGB(Utils.HSVAtoRGBA(this._hue, 100, 100, 1)));
			// trace("h", this._hue, this.data, StringTools.hex(this.data, 8));
		} else if (this.activeSlider == 2) {
			this._alpha = 1 - Math.max(0, Math.min(1, this.alphaSlider.mouseY / this.columnSize));
			this.data = Utils.HSVAtoRGBA(this._hue, this._saturation, this._value, this._alpha);
			// trace("a", this._alpha, this.data, StringTools.hex(this.data, 8));
		}
	}

	private function stage_mouseUpHandler(event:MouseEvent):Void {
		this.addEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownHandler);
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

	override private function update():Void {
		if (this.isInvalid(InvalidationFlag.DATA)) {
			this.saturateUI(Utils.RGBA2RGB(this.data));
		}
		super.update();
	}
}
