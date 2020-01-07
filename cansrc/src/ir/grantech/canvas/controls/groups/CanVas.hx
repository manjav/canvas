package ir.grantech.canvas.controls.groups;

import ir.grantech.canvas.themes.CanTheme;
import feathers.controls.colors.ColorLine;
import feathers.controls.LayoutGroup;
import openfl.events.Event;

class CanVas extends LayoutGroup {
  public function new() {
    super();

    // var backgroundSkin = new RectangleSkin();
    // backgroundSkin.fill = SolidColor(0x33);
    // this.backgroundSkin = backgroundSkin;

    var c = new ColorLine();
    c.height = CanTheme.CONTROL_SIZE;
    c.addEventListener(Event.CHANGE, changed);
    addChild(c);
  }

  function changed(e:Event):Void {
    // trace(cast(e.currentTarget, ColorPicker).data);
  }
}