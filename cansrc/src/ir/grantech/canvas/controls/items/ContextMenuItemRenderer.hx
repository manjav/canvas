package ir.grantech.canvas.controls.items;

import feathers.controls.ToggleButtonState;
import feathers.controls.dataRenderers.IDataRenderer;
import feathers.controls.dataRenderers.ItemRenderer;
import feathers.core.InvalidationFlag;
import feathers.events.FeathersEvent;
import feathers.skins.BaseGraphicsPathSkin;
import feathers.skins.DividerSkin;
import feathers.skins.RectangleSkin;
import feathers.style.Theme;
import ir.grantech.canvas.events.CanEvent;
import ir.grantech.canvas.services.Configs.Config;
import ir.grantech.canvas.themes.CanTheme;
import ir.grantech.canvas.themes.ScaledBitmap;
import openfl.events.Event;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;

class ContextMenuItemRenderer extends ItemRenderer implements IDataRenderer {
	public static final HEIGHT:Int = Math.floor(CanTheme.CONTROL_SIZE * 1.4); 
	@:isVar
	public var data(get, set):Dynamic;

	private function set_data(value:Dynamic):Dynamic {
		if (this.data == value)
			return this.data;
		if (value == null)
			return value;
		this.data = value;
		this.menuData = cast(this.data, Config);
		this.setInvalid(InvalidationFlag.DATA);
		return this.data;
	}

	private function get_data():Dynamic {
		return this.data;
	}

	override private function set_selected(value:Bool):Bool {
		if (this.menuData.isDivider || !value || this.selected == value)
			return this.selected;
		if (this.menuData.children.length == 0) {
			CanEvent.dispatch(this, CanEvent.ITEM_SELECT, this, true);
			return false;
		}
		return super.set_selected(value);
	}

	public var menuData:Config;

	private var shortkeyField:TextField;

	public function new() {
		super();
	}

	override private function initializeItemRendererTheme():Void {}

	override function initialize():Void {
		super.initialize();
		this.height = HEIGHT;

		this.selectedTextFormat = this.textFormat;
		this.setTextFormatForState(ToggleButtonState.DOWN(false), this.textFormat);

		this.iconPosition = MANUAL;
		this.gap = CanTheme.DEFAULT_PADDING;

		this.addEventListener(FeathersEvent.STATE_CHANGE, this.stateChangeHandler);
	}

	@:access(ir.grantech.canvas.themes.CanTheme)
	override private function update():Void {
		if (this.isInvalid(InvalidationFlag.DATA)) {
			var theme = Std.downcast(Theme.getTheme(), CanTheme);
			var skin:BaseGraphicsPathSkin = null;
			if (this.menuData.isDivider) {
				skin = new DividerSkin(CanTheme.DPI * 4);
				skin.border = LineStyle.SolidColor(CanTheme.DPI * 0.5, theme.dividerColor);
			} else {
				skin = new RectangleSkin();
				skin.selectedFill = SolidColor(theme.dividerColor);
				#if !desktop
				skin.setFillForState(ToggleButtonState.HOVER(false), SolidColor(theme.dividerColor, 0.2));
				#end
			}
			skin.fill = theme.getContainerFill();
			this.backgroundSkin = skin;

			if (!this.menuData.isDivider) {
				if (this.menuData.children.length > 0) {
					this.icon = new ScaledBitmap("chevron-r");
				} else {
					if (this.shortkeyField == null) {
						this.shortkeyField = new TextField();
						this.shortkeyField.embedFonts = true;
						this.shortkeyField.defaultTextFormat = this.textFormat;
						this.shortkeyField.autoSize = TextFieldAutoSize.RIGHT;
						this.shortkeyField.selectable = false;
						this.addChild(this.shortkeyField);
					}
					if (this.menuData.shortKey != null)
						this.shortkeyField.text = this.menuData.shortKey;
				}
			}
		}
		super.update();
	}

	private function stateChangeHandler(event:Event):Void {
		if (!this.menuData.isDivider && Type.enumEq(currentState, ToggleButtonState.HOVER(false)))
			CanEvent.dispatch(this, CanEvent.ITEM_HOVER, this.menuData.children.length > 0, true);
	}

	override private function layoutContent():Void {
		if (this.menuData.isDivider)
			return;

		this.refreshTextFieldDimensions(false);

		this.textField.x = this.paddingLeft;
		this.textField.height = this.actualHeight * 0.5;
		this.textField.y = (this.actualHeight - this.textField.height) * 0.5;

		if (this.icon != null) {
			this.icon.x = this.actualWidth - this.paddingRight - this.icon.width;
			this.icon.y = (this.actualHeight - this.icon.height) * 0.5;
		}
		if (this.shortkeyField != null) {
			this.shortkeyField.x = this.actualWidth - this.paddingRight - this.shortkeyField.width;
			this.shortkeyField.y = (this.actualHeight - this.shortkeyField.height) * 0.5;
		}
	}
}
