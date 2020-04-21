package feathers.controls.colors;

import feathers.controls.FixableCallout;
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

class ColorCallout extends LayoutGroup {
	static private final FLAG_H:String = "hue";
	static private final FLAG_SV:String = "saturationValue";
	static private final FLAG_A:String = "alpha";

	public var data(default, set):RGBA;

	private function set_data(value:RGBA):RGBA {
		if (this.data == value)
			return value;
		this.data = value;
		if (this.hasEventListener(Event.CHANGE))
			this.dispatchEvent(new Event(Event.CHANGE));
		var hsv = Utils.RGBtoHSV(value.r, value.g, value.b);
		this.h = hsv[0];
		this.setSV(hsv[1], hsv[2]);
		this.a = value.a;
		return value;
	}

	public var h(default, set):UInt = 0;

	private function set_h(value:UInt):UInt {
		if (this.h == value)
			return value;
		this.h = value;
		this.setInvalid(FLAG_H);
		return value;
	}

	public var s(default, null):UInt = 100;
	public var v(default, null):UInt = 100;

	private function setSV(s:UInt, v:UInt):Void {
		if (this.s == s && this.v == v)
			return;
		this.s = s;
		this.v = v;
		this.setInvalid(FLAG_SV);
	}

	public var a(default, set):UInt = 255;

	private function set_a(value:UInt):UInt {
		if (this.a == value)
			return value;
		this.a = value;
		this.setInvalid(FLAG_A);
		return value;
	}

	public var callout:FixableCallout;

	private var activeSlider:String = null;
	private var roundness = CanTheme.DPI * 3;
	private var columnSize = CanTheme.DPI * 90;
	private var padding = CanTheme.DEFAULT_PADDING;

	private var matrixV:Matrix;
	private var matrixH:Matrix;
	private var hueTrack:Shape;
	private var hueSlider:Sprite;
	private var saturationTrack:Shape;
	private var saturationSlider:Shape;
	private var alphaTrack:Shape;
	private var alphaSlider:Shape;

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
		#if flash
		this.hueSlider.filters = [innerGlow];
		#else
		this.hueSlider.graphics.lineStyle(CanTheme.DPI, theme.disabledTextColor);
		#end
		this.hueSlider.graphics.beginGradientFill(GradientType.LINEAR, [0xff0000, 0xffff00, 0x00ff00, 0x00ffff, 0x0000ff, 0xff00ff, 0xff0000],
			[1, 1, 1, 1, 1, 1, 1], [0, 43, 86, 129, 172, 212, 255], this.matrixV);
		this.hueSlider.graphics.drawRoundRect(0, 0, this.padding, this.columnSize, roundness, roundness);
		this.hueSlider.x = this.columnSize + this.padding * 2;
		this.hueSlider.y = this.padding;
		this.addChild(this.hueSlider);

		this.hueTrack = this.createTrack();
		this.hueTrack.x = this.padding * 0.5;
		hueSlider.addChild(this.hueTrack);

		var hueMask:Shape = new Shape();
		hueMask.graphics.beginFill();
		hueMask.graphics.drawRoundRect(0, 0, this.padding, this.columnSize, roundness, roundness);
		hueMask.x = this.hueSlider.x;
		hueMask.y = this.hueSlider.y;
		this.hueSlider.mask = hueMask;
		this.addChild(hueMask);

		// saturation / value slider
		var saturationContainer:Sprite = new Sprite();
		#if flash
		saturationContainer.filters = [innerGlow];
		#else
		saturationContainer.graphics.lineStyle(CanTheme.DPI, theme.disabledTextColor);
		#end
		saturationContainer.graphics.beginFill(0xFFFFFF);
		saturationContainer.graphics.drawRoundRect(0, 0, this.columnSize, this.columnSize, roundness, roundness);
		saturationContainer.x = saturationContainer.y = this.padding;
		this.addChild(saturationContainer);

		var svMask:Shape = new Shape();
		svMask.graphics.beginFill();
		svMask.graphics.drawRoundRect(0, 0, this.columnSize, this.columnSize, roundness, roundness);
		svMask.x = saturationContainer.x;
		svMask.y = saturationContainer.y;
		saturationContainer.mask = svMask;
		this.addChild(svMask);

		this.saturationSlider = new Shape();
		saturationContainer.addChild(this.saturationSlider);

		var valueGradient = new Shape();
		valueGradient.graphics.beginGradientFill(GradientType.LINEAR, [0, 0], [0, 1], [0, 0xFF], this.matrixV);
		valueGradient.graphics.drawRoundRect(0, 0, this.columnSize, this.columnSize, roundness, roundness);
		saturationContainer.addChild(valueGradient);

		this.saturationTrack = this.createTrack();
		saturationContainer.addChild(this.saturationTrack);

		// alpha slider
		var alphaContainer:Sprite = new Sprite();
		#if flash
		alphaContainer.filters = [innerGlow];
		#else
		alphaContainer.graphics.lineStyle(CanTheme.DPI, theme.disabledTextColor);
		#end
		alphaContainer.graphics.beginBitmapFill(Assets.getBitmapData("transparent"));
		alphaContainer.graphics.drawRoundRect(0, 0, this.padding, this.columnSize, roundness, roundness);
		alphaContainer.x = this.columnSize + this.padding * 4;
		alphaContainer.y = this.padding;
		this.addChild(alphaContainer);

		this.alphaSlider = new Shape();
		alphaContainer.addChild(this.alphaSlider);

		this.alphaTrack = this.createTrack();
		this.alphaTrack.x = this.padding * 0.5;
		alphaContainer.addChild(this.alphaTrack);

		var alphaMask:Shape = new Shape();
		alphaMask.graphics.beginFill();
		alphaMask.graphics.drawRoundRect(0, 0, this.padding, this.columnSize, roundness, roundness);
		alphaMask.x = alphaContainer.x;
		alphaMask.y = alphaContainer.y;
		alphaContainer.mask = alphaMask;
		this.addChild(alphaMask);

		this.addEventListener(Event.ADDED_TO_STAGE, this.addedToStageHandler);
	}

	private function addedToStageHandler(event:Event):Void {
		this.removeEventListener(Event.REMOVED_FROM_STAGE, this.removedFromStageHandler);
		this.addEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownHandler);
	}

	private function removedFromStageHandler(event:Event):Void {
		this.stage.removeEventListener(MouseEvent.MOUSE_UP, this.stage_mouseUpHandler);
		this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.stage_mouseMoveHandler);
		this.removeEventListener(Event.REMOVED_FROM_STAGE, this.removedFromStageHandler);
		this.removeEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownHandler);
	}

	private function createTrack():Shape {
		var ret = new Shape();
		ret.graphics.lineStyle(CanTheme.DPI * 1.5, 0x848484);
		ret.graphics.drawCircle(0, CanTheme.DPI * 0.2, CanTheme.DPI * 3);
		ret.graphics.lineStyle(CanTheme.DPI, 0xFFFFFF);
		ret.graphics.drawCircle(0, 0, CanTheme.DPI * 3);
		ret.graphics.endFill();
		return ret;
	}

	private function mouseDownHandler(event:MouseEvent):Void {
		this.removeEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownHandler);
		this.stage.addEventListener(MouseEvent.MOUSE_MOVE, this.stage_mouseMoveHandler);
		this.stage.addEventListener(MouseEvent.MOUSE_UP, this.stage_mouseUpHandler);

		if (this.hueSlider.mouseX >= 0
			&& this.hueSlider.mouseX <= this.padding
			&& this.hueSlider.mouseX >= 0
			&& this.hueSlider.mouseX <= this.columnSize)
			this.activeSlider = FLAG_H;
		else if (this.saturationSlider.mouseX >= 0
			&& this.saturationSlider.mouseX <= this.columnSize
			&& this.saturationSlider.mouseY >= 0
			&& this.saturationSlider.mouseY <= this.columnSize)
			this.activeSlider = FLAG_SV;
		else if (this.alphaSlider.mouseX >= 0
			&& this.alphaSlider.mouseX <= this.padding
			&& this.alphaSlider.mouseX >= 0
			&& this.alphaSlider.mouseX <= this.columnSize)
			this.activeSlider = FLAG_A;
		else
			this.activeSlider = null;
	}

	private function stage_mouseMoveHandler(event:MouseEvent):Void {
		if (this.activeSlider == null)
			return;
		if (this.activeSlider == FLAG_H)
			this.h = Math.round(Math.max(0, Math.min(1, this.hueSlider.mouseY / this.columnSize)) * 360);
		else if (this.activeSlider == FLAG_SV)
			this.setSV(Math.round(Math.max(0, Math.min(1, this.saturationSlider.mouseX / this.columnSize)) * 100),
				100 - Math.round(Math.max(0, Math.min(1, this.saturationSlider.mouseY / this.columnSize)) * 100));
		else if (this.activeSlider == FLAG_A)
			this.a = 255 - Math.round(Math.max(0, Math.min(1, this.alphaSlider.mouseY / this.columnSize)) * 255);

		this.data = Utils.HSVAtoRGBA(this.h, this.s, this.v, this.a);
		// trace("h", this.h, "sv", this.s, this.v, "a", this.a);
	}

	private function stage_mouseUpHandler(event:MouseEvent):Void {
		this.addEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownHandler);
		if (this.stage == null)
			return;
		this.stage.removeEventListener(MouseEvent.MOUSE_UP, this.stage_mouseUpHandler);
		this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.stage_mouseMoveHandler);
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
		var hueChanged = this.isInvalid(FLAG_H);
		if (hueChanged) {
			this.hueUI(Utils.RGBA2RGB(Utils.HSVAtoRGBA(this.h, 100, 100, 1)));
			this.hueTrack.y = this.h / 360 * this.columnSize;
		}

		if (hueChanged || this.isInvalid(FLAG_SV)) {
			this.saturationTrack.x = this.s * 0.01 * this.columnSize;
			this.saturationTrack.y = (1 - this.v * 0.01) * this.columnSize;
			this.saturateUI(Utils.RGBA2RGB(this.data));
		}

		if (this.isInvalid(FLAG_A))
			this.alphaTrack.y = (1 - this.a / 255) * this.columnSize;

		super.update();
	}
}
