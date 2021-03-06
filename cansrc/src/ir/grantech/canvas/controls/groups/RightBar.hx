package ir.grantech.canvas.controls.groups;

import ir.grantech.canvas.controls.groups.sections.LayoutSection;
import ir.grantech.canvas.controls.groups.sections.LayersSection;
import feathers.controls.LayoutGroup;
import feathers.controls.ScrollContainer;
import feathers.layout.HorizontalAlign;
import feathers.layout.VerticalLayout;
import feathers.layout.VerticalLayoutData;
import ir.grantech.canvas.controls.groups.sections.AlignSection;
import ir.grantech.canvas.controls.groups.sections.AppearSection;
import ir.grantech.canvas.controls.groups.sections.FiltersSection;
import ir.grantech.canvas.controls.groups.sections.TextSection;
import ir.grantech.canvas.controls.groups.sections.TransformSection;
import ir.grantech.canvas.drawables.CanItems;
import ir.grantech.canvas.events.CanEvent;
import ir.grantech.canvas.services.Commands;
import ir.grantech.canvas.services.Inputs;
import ir.grantech.canvas.themes.CanTheme;
import openfl.events.Event;

class RightBar extends ScrollContainer {
	private var textSection:TextSection;
	private var alignSection:AlignSection;
	private var layoutSection:LayoutSection;
	private var appearSection:AppearSection;
	private var filtersSection:FiltersSection;
	private var transfromSection:TransformSection;

	override function initialize():Void {
		super.initialize();
		this.backgroundSkin = null;
		// this.scroller.mouseWheelDeltaY = 100;
		
		var layout = new VerticalLayout();
		layout.horizontalAlign = HorizontalAlign.JUSTIFY;
		layout.paddingTop = layout.paddingRight = layout.paddingBottom = layout.paddingLeft = 0;
		layout.gap = CanTheme.DPI;
		this.layout = layout;

		this.alignSection = new AlignSection();
		this.addChild(this.alignSection);

		this.layoutSection = new LayoutSection();
		this.addChild(this.layoutSection);

		this.transfromSection = new TransformSection();
		this.addChild(this.transfromSection);

		this.textSection = new TextSection();
		this.addChild(this.textSection);

		this.appearSection = new AppearSection();
		this.addChild(this.appearSection);

		this.filtersSection = new FiltersSection();
		this.filtersSection.layoutData = new VerticalLayoutData(100, 100);
		this.addChild(this.filtersSection);

		Inputs.instance.addEventListener(Inputs.POINT, this.input_pointHandler);
		Commands.instance.addEventListener(Commands.SELECT, this.commands_selectHandler);
		this.enabled = false;
	}

	private function input_pointHandler(event:Event):Void {
		if (Inputs.instance.pointPhase < Inputs.PHASE_ENDED)
			this.transfromSection.updateData();
	}

	private function commands_selectHandler(event:CanEvent):Void {
		var items = cast(event.data[0], CanItems);
		this.enabled = items.isFill;
		this.textSection.targets = items;
		this.alignSection.targets = items;
		this.layoutSection.targets = items;
		this.appearSection.targets = items;
		this.transfromSection.targets = items;
	}
}
