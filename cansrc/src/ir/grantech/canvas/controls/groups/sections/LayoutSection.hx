package ir.grantech.canvas.controls.groups.sections;

import feathers.controls.PopUpListView;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;
import ir.grantech.canvas.drawables.CanItems;

class LayoutSection extends CanSection {
	override private function set_targets(value:CanItems):CanItems {
		this.visible = this.includeInLayout = value.isUI;
		super.set_targets(value);
		return value;
	}

	private var layoutsList:PopUpListView;

	override private function initialize() {
		super.initialize();
		this.layout = new AnchorLayout();
		this.title = "LAYOUT";

		var layouts = ["None", "Anchor Layout", "Vertical Layout", "Horizontal Layout"];
		this.layoutsList = this.createPopupList(layouts, new AnchorLayoutData(padding * 2.7, padding, null, padding));

		this.height = padding * 7.5;
	}

	override public function updateData():Void {
		if (this.targets == null || this.targets.isEmpty)
			return;
		this.updating = true;

		this.updating = false;
	}
}
